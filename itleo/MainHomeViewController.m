//
//  MainHomeViewController.m
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "MainHomeViewController.h"
#import "LEOLoginViewController.h"
#import "Menu_home.h"
#import "Cell_menu_item.h"
#import "Web_app_config.h"
#import "Web_get_chart_data.h"
#import "Web_order_list.h"
#import "Timer_bg_upload_data.h"
#import "DB_LoginInfo.h"
#import "DB_single_field.h"
#import "DB_RespAppConfig.h"
#import "DB_Location.h"
#import "DB_ePod.h"
#import "DB_sypara.h"
#import "DB_Chart.h"
#import "DB_whs_config.h"
#import "DB_order.h"
#import "DB_permit.h"
#import "LocationManager.h"

@interface MainHomeViewController ()

@property (strong, nonatomic) UIBarButtonItem *ibtn_logout;
@property (strong, nonatomic) UIBarButtonItem *ibtn_settings;
@property (strong, nonatomic) NSMutableArray *alist_menu;
@property (strong, nonatomic) Menu_home *menu_item;
@property (assign, nonatomic) NSInteger flag_launch_isLogin;//APP启动的时候，判断是否已经有用户登录，1->登录 0->未登录
@property (nonatomic, assign) NSInteger flag_opened_record_thread;
@property (nonatomic, assign) NSInteger flag_opened_gps_thread;

@end

@implementation MainHomeViewController
@synthesize alist_menu;
@synthesize menu_item;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_users_isLogin];
    [self fn_add_right_items];
    [self fn_create_menu];
    [self fn_isStart_open_thread];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    //启动的时候，没有登录，则弹出登录界面
    if (_flag_launch_isLogin==0) {
        [self fn_present_loginView];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"get_chartImages" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark creat menu item
-(void)fn_add_right_items{
    self.ibtn_logout=[[UIBarButtonItem alloc]initWithTitle:MY_LocalizedString(@"lbl_logout", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(fn_logout_itleo:)];
    UIBarButtonItem *ibtn_space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ibtn_space.width=FIXSPACE;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,1.5,20)];
    view.backgroundColor=[UIColor lightGrayColor];
    UIBarButtonItem *ibtn_space1=[[UIBarButtonItem alloc]initWithCustomView:view];
    ibtn_space1.width=ITEM_LINE_WIDTH;
    UIBarButtonItem *ibtn_space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ibtn_space2.width=FIXSPACE;
    self.ibtn_settings=[[UIBarButtonItem alloc]initWithTitle:MY_LocalizedString(@"ibtn_settings", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(fn_manually_settings:)];
    NSArray *array=@[self.ibtn_logout,ibtn_space,ibtn_space1,ibtn_space2,self.ibtn_settings];
    self.navigationItem.rightBarButtonItems=array;
}
//创建功能菜单
-(void) fn_create_menu{
    [self fn_set_nav_item];
    alist_menu=nil;
    alist_menu=[[NSMutableArray alloc]init];
    
    DB_permit *db_permit_obj=[[DB_permit alloc]init];
    if ([db_permit_obj fn_isExist_module:MODULE_AIR_LOAD_PLAN f_exec:MODULE_F_EXEC]) {
        [alist_menu addObject:[Menu_home fn_create_item:MY_LocalizedString(@"module_air_Load_Plan", nil) image:@"ic_airloadplan" segue:@"segue_aejob_browse"]];
    }
    if ([db_permit_obj fn_isExist_module:MODULE_EPOD f_exec:MODULE_F_EXEC]) {
        [alist_menu addObject:[Menu_home fn_create_item:MY_LocalizedString(@"module_epod", nil) image:@"delivery" segue:@"segue_epod"]];
        [self fn_add_notificaiton];
    }
    if ([db_permit_obj fn_isExist_module:MODULE_WHS_SUMMARY f_exec:MODULE_F_EXEC]) {
        [alist_menu addObject:[Menu_home fn_create_item:MY_LocalizedString(@"module_charts", nil) image:@"ic_summary" segue:@"segue_chart"]];
        [[Web_get_chart_data fn_shareInstance]fn_asyn_get_all_charts];
    }
    if ([db_permit_obj fn_isExist_module:MODULE_CFSRECV f_exec:MODULE_F_EXEC]) {
        [alist_menu addObject:[Menu_home fn_create_item:MY_LocalizedString(@"module_cfsrecv", nil) image:@"ic_cfsrecv" segue:@"segue_cfsrecv"]];
    }
    if ([db_permit_obj fn_isExist_module:MODULE_WAREHOUSE f_exec:MODULE_F_EXEC]) {
        [alist_menu addObject:[Menu_home fn_create_item:MY_LocalizedString(@"module_warehouse", nil) image:@"ic_warehouse" segue:@"segue_warehouse"]];
    }
    db_permit_obj=nil;
    
    self.icollectionView.delegate=self;
    self.icollectionView.dataSource=self;
    [self.icollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell_menu"];
}
-(void)fn_set_nav_item{
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:MY_LocalizedString(@"lbl_home", nil)
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:nil
                                                                          action:nil];
    [self.navigationItem setHidesBackButton:YES];
    [_ibtn_home_logo setTitle:MY_LocalizedString(@"lbl_home", nil) forState:UIControlStateNormal];
    [_ibtn_home_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];

    [_ibtn_logout setTitle:MY_LocalizedString(@"lbl_logout", nil)];
    [_ibtn_settings setTitle:MY_LocalizedString(@"ibtn_settings", nil)];
}
/**
 *  判断用户是否登录，如果已经登录，则设置语言环境
 */
-(void)fn_users_isLogin{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    _flag_launch_isLogin=[userDefaults integerForKey:@"isLogin"];
    if (_flag_launch_isLogin==1) {
        NSString *lang=[Conversion_helper fn_get_lang_code];
        [[MY_LocalizedString getshareInstance]fn_setLanguage_type:lang];
    }
}
//如果用户未登录 或者用户退出登录则弹出登录页面
- (void)fn_present_loginView{
    LEOLoginViewController *VC=(LEOLoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LEOLoginViewController"];
    if (_flag_launch_isLogin==0) {
        [self presentViewController:VC animated:NO completion:nil];
    }else{
        [self presentViewController:VC animated:YES completion:nil];
    }
    VC.refresh=^(){
        [self fn_create_menu];
        [self fn_isRequest_all_order_list];
        [self.icollectionView reloadData];
        if (_flag_launch_isLogin==1){
            [[Timer_bg_upload_data fn_shareInstance]fn_start_upload_GPS];
            [[Timer_bg_upload_data fn_shareInstance]fn_start_upload_records];
        }
        _flag_launch_isLogin=1;
    };
}
//当登录成功后，判断用户是否拥有epod的权限和epod中是否有查看order list的功能，如果有则把所有的order list请求下来
- (void)fn_isRequest_all_order_list{
    DB_sypara *db_sypara_obj=[[DB_sypara alloc]init];
    DB_permit *db_permit_obj=[[DB_permit alloc]init];
    if ( [db_permit_obj fn_isExist_module:MODULE_EPOD f_exec:MODULE_F_EXEC] && [db_sypara_obj fn_isExist_sypara_data:PARA_CODE_ORDERLIST data1:PARA_DATA1] ) {
        Web_order_list *web_obj=[[Web_order_list alloc]init];
        NSSet *arr_uid=[NSSet setWithObject:@""];
        [web_obj fn_handle_order_list_data:arr_uid type:kGet_order_list_all];
        web_obj=nil;
    }
    db_permit_obj=nil;
    db_sypara_obj=nil;
}
#pragma mark -addObserver notificaiton
-(void)fn_add_notificaiton{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SETTINGS_AUTO_UPLOAD_RECORD object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_isAuto_transfer_record) name:SETTINGS_AUTO_UPLOAD_RECORD object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SETTINGS_AUTO_UPLOAD_GPS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_isAuto_transmission_GPS) name:SETTINGS_AUTO_UPLOAD_GPS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SETTINGS_AUTO_UPLOAD_WHS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_isAuto_upload_whs) name:SETTINGS_AUTO_UPLOAD_WHS object:nil];
}
-(void)fn_isStart_open_thread{
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSInteger _flag_transfer_record= [userDefault integerForKey:SETTINGS_AUTO_UPLOAD_RECORD];
    if (_flag_transfer_record==1) {
        [[Timer_bg_upload_data fn_shareInstance] fn_open_upload_records_thread];
        _flag_opened_record_thread=1;//标记已经打开上传输入记录的线程
    }
    
    NSInteger _flag_transfer_GPS= [userDefault integerForKey:SETTINGS_AUTO_UPLOAD_GPS];
    if (_flag_transfer_GPS==1) {
        [[Timer_bg_upload_data fn_shareInstance] fn_open_upload_GPS_thread];
        _flag_opened_gps_thread=1;//标识已经打开上传gps记录的线程
    }
}
#pragma mark -open a thread
-(void)fn_isAuto_transfer_record{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSInteger _flag_transfer_record= [userDefault integerForKey:SETTINGS_AUTO_UPLOAD_RECORD];
    if (_flag_transfer_record==1) {
        //自动上传记录
        [[Timer_bg_upload_data fn_shareInstance]fn_start_upload_records];
        if (_flag_opened_record_thread!=1) {
            [[Timer_bg_upload_data fn_shareInstance]fn_open_upload_records_thread];
        }
    }else{
        //关闭自动上传记录
        [[Timer_bg_upload_data fn_shareInstance]fn_stop_upload_records];
    }
    
}

-(void)fn_isAuto_transmission_GPS{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSInteger _flag_transfer_GPS= [userDefault integerForKey:SETTINGS_AUTO_UPLOAD_GPS];
    if (_flag_transfer_GPS==1) {
        
        //开启自动上传GPS的功能
        [[Timer_bg_upload_data fn_shareInstance]fn_start_upload_GPS];
        if (_flag_opened_gps_thread!=1) {
            [[Timer_bg_upload_data fn_shareInstance]fn_open_upload_GPS_thread];
        }
    }else{
        
        //gps停止记录坐标
        [[LocationManager fn_shareManager]fn_stopUpdating];
        //关闭自动上传GPS的功能
        [[Timer_bg_upload_data fn_shareInstance]fn_stop_upload_GPS];
        
    }
}
- (void)fn_isAuto_upload_whs{
    
}

#pragma mark -event action
- (void)fn_manually_settings:(id)sender {
    [self performSegueWithIdentifier:@"segue_setting" sender:nil];
}
- (void)fn_logout_itleo:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:MY_LocalizedString(@"logout_alert", nil) delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_cancel", nil) otherButtonTitles:MY_LocalizedString(@"lbl_ok", nil), nil];
    [alert show];
    
}

- (IBAction)fn_click_menu:(id)sender {
    UIButton *ibtn=(UIButton*)sender;
    menu_item=[alist_menu objectAtIndex:ibtn.tag];
    if ([menu_item.is_segue isEqualToString:@"segue_chart"]) {
        NSMutableDictionary *idic_chartImages=[[Web_get_chart_data fn_shareInstance]fn_get_ChartImages];
        if ([idic_chartImages count]==0) {
            [SVProgressHUD showWithStatus:MY_LocalizedString(@"load_order_alert", nil)];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_complete_load_chartImages) name:@"get_chartImages" object:nil];
        }else{
            [self performSegueWithIdentifier:menu_item.is_segue sender:self];
        }
        
    }else{
        [self performSegueWithIdentifier:menu_item.is_segue sender:self];
    }
}
//完成绘图表时，触发的方法
- (void)fn_complete_load_chartImages{
    [self performSegueWithIdentifier:@"segue_chart" sender:self];
    [SVProgressHUD dismiss];
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==[alertView firstOtherButtonIndex]) {
        [self fn_clear_the_cache];
    }
}
/**
 *  确定强制退出后，将清除缓存
 */
-(void)fn_clear_the_cache{
    //logout的时候，清除epod所有相关的信息
    DB_ePod *db_epod=[[DB_ePod alloc]init];
    [db_epod fn_delete_all_epod_data];
    DB_single_field *db=[[DB_single_field alloc]init];
    [db fn_delete_all_data:@"vehicle_no"];
    DB_Location *db_location=[[DB_Location alloc]init];
    [db_location fn_delete_location_data];
    DB_LoginInfo *db_logininfo=[[DB_LoginInfo alloc]init];
    [db_logininfo fn_delete_LoginInfo_data];
    DB_RespAppConfig *db_config=[[DB_RespAppConfig alloc]init];
    [db_config fn_delete_all_RespAppConfig_data];
    /**
     *  清除存储的sypara
     */
    DB_sypara *db_sypara=[[DB_sypara alloc]init];
    [db_sypara fn_delete_all_sypara_data];
    db_sypara=nil;
    //清除图表数据
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    [db_chart fn_delete_all_chart_data];
    db_chart=nil;
    //清除whs log data
    DB_whs_config *db_whs=[[DB_whs_config alloc]init];
    [db_whs fn_delete_all_wharehouse_log];
    db_whs=nil;
    //清楚order数据
    DB_order *db_order=[[DB_order alloc]init];
    [db_order fn_delete_all_order_list];
    db_order=nil;
    [self fn_present_loginView];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:@"isLogin"];
    [userDefaults synchronize];
    [[Timer_bg_upload_data fn_shareInstance]fn_stop_upload_GPS];
    [[Timer_bg_upload_data fn_shareInstance]fn_stop_upload_records];
}

#pragma mark UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [alist_menu count];
}
// 一个collectionView中的分区数
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Cell_menu_item *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_menu_item" forIndexPath:indexPath];
    NSInteger  li_item=[indexPath item];
    menu_item=[alist_menu objectAtIndex:li_item];
    cell.il_title.text=menu_item.is_label;
    [cell.ibtn_image setImage:[UIImage imageNamed:menu_item.is_image] forState:UIControlStateNormal];
    cell.ibtn_image.tag=indexPath.item;
    return cell;
}
#pragma mark – UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(15, 0, 0, 0);
}
@end
