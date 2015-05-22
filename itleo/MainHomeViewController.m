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

@interface MainHomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ilb_version;
@property (strong, nonatomic) UIBarButtonItem *ibtn_logout;
@property (strong, nonatomic) UIBarButtonItem *ibtn_settings;
@property(strong,nonatomic)NSMutableArray *alist_menu;
@property(strong,nonatomic)Menu_home *menu_item;
@property(assign,nonatomic)NSInteger flag_launch_isLogin;

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
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    //启动的时候，没有登录，则弹出登录界面
    if (_flag_launch_isLogin==0) {
        [self fn_present_loginView];
    }
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
    _ilb_version.text=[NSString stringWithFormat:@"Version %@",ITLEO_VERSION];
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
    [self performSegueWithIdentifier:menu_item.is_segue sender:self];
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
