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
#import "Web_get_permit.h"
#import "Web_get_chart_data.h"
#import "Timer_bg_upload_data.h"
#import "DB_LoginInfo.h"
#import "DB_single_field.h"
#import "DB_RespAppConfig.h"
#import "DB_Location.h"
#import "DB_ePod.h"
#import "DB_sypara.h"
#import "DB_Chart.h"
#import "DB_whs_config.h"
@interface MainHomeViewController ()
@property(strong,nonatomic)NSMutableArray *alist_menu;
@property(strong,nonatomic)Menu_home *menu_item;
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
    [self fn_set_nav_left_item];
    [self fn_create_menu];
    [self fn_show_different_language];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark show different languge
-(void) fn_show_different_language{

    [_ibtn_logout setTitle:MY_LocalizedString(@"lbl_logout", nil)];
    [_ibtn_logout setTintColor:[UIColor darkGrayColor]];
}
#pragma mark creat menu item
-(void) fn_create_menu{
    alist_menu=[[NSMutableArray alloc]init];
    Web_get_permit *web_obj=[[Web_get_permit alloc]init];
    NSMutableArray *alist_fuction=[web_obj fn_get_function_module];
    for (NSMutableDictionary *dic in alist_fuction) {
        NSString *module_code=[dic valueForKey:@"module_code"];
        NSString *f_exec=[dic valueForKey:@"f_exec"];
        if ([module_code isEqualToString:@"AIR_LOAD_PLAN"]&& [f_exec isEqualToString:@"1"]) {
            [alist_menu addObject:[Menu_home fn_create_item:MY_LocalizedString(@"module_air_Load_Plan", nil) image:@"ic_airloadplan" segue:@"segue_aejob_browse"]];
        }
        
        if ([module_code isEqualToString:@"EPOD"] && [f_exec isEqualToString:@"1"]) {
            [alist_menu addObject:[Menu_home fn_create_item:MY_LocalizedString(@"module_eop", nil) image:@"delivery" segue:@"segue_epod"]];
        }
#warning -neet fix
        if ([module_code isEqualToString:@"Chart"] && [f_exec isEqualToString:@"1"]) {
            [alist_menu addObject:[Menu_home fn_create_item:MY_LocalizedString(@"module_charts", nil) image:@"ic_summary" segue:@"segue_chart"]];
            [[Web_get_chart_data fn_shareInstance]fn_asyn_get_all_charts];
        }
        if ([module_code isEqualToString:@"CFSRECV"] && [f_exec isEqualToString:@"1"]) {
            [alist_menu addObject:[Menu_home fn_create_item:MY_LocalizedString(@"module_warehouse", nil) image:@"ic_itdept_logo" segue:@"segue_warehouse"]];
        }
        
    }
#warning -neet fix
    [alist_menu addObject:[Menu_home fn_create_item:@"BarCodeSys" image:@"barcode" segue:@"segue_barCodeSysHome"]];
    [alist_menu addObject:[Menu_home fn_create_item:MY_LocalizedString(@"module_eop", nil) image:@"delivery" segue:@"segue_epod"]];
    self.icollectionView.delegate=self;
    self.icollectionView.dataSource=self;
    [self.icollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell_menu"];
}
-(void)fn_set_nav_left_item{
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:MY_LocalizedString(@"lbl_home", nil)
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:nil
                                                                          action:nil];
    [self.navigationItem setHidesBackButton:YES];
    [_ibtn_home_logo setTitle:MY_LocalizedString(@"lbl_home", nil) forState:UIControlStateNormal];
    [_ibtn_home_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
}
/**
 *  判断用户是否登录，如果没有登录，则弹出登录界面
 */
-(void)fn_users_isLogin{
    LEOLoginViewController *VC=(LEOLoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LEOLoginViewController"];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSInteger login_flag=[userDefaults integerForKey:@"isLogin"];
    if (login_flag==0) {
        [self presentViewController:VC animated:NO completion:^(){}];
    }else{
        NSString *lang=[Conversion_helper fn_get_lang_code];
        [[MY_LocalizedString getshareInstance]fn_setLanguage_type:lang];
    }
    
}

- (IBAction)fn_logout_itleo:(id)sender {
    DB_ePod *db_epod=[[DB_ePod alloc]init];
    DB_Location *db_location=[[DB_Location alloc]init];
    NSInteger epod_count=[[db_epod fn_select_all_ePod_data] count];
    NSInteger location_count=[[db_location fn_get_location_data:@"0"] count];
    if (epod_count!=0 || location_count!=0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:MY_LocalizedString(@"logout_alert", nil) delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_ok", nil) otherButtonTitles:MY_LocalizedString(@"lbl_cancel", nil), nil];
        [alert show];
    }else{
        [self fn_clear_the_cache];
    }
    
    
}

- (IBAction)fn_click_menu:(id)sender {
    UIButton *ibtn=(UIButton*)sender;
    menu_item=[alist_menu objectAtIndex:ibtn.tag];
    [self performSegueWithIdentifier:menu_item.is_segue sender:self];
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==[alertView cancelButtonIndex]) {
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
    //获取定时器
    NSTimer *GPS_timer=[[Timer_bg_upload_data fn_shareInstance]fn_get_GPS_timer];
    LEOLoginViewController *VC=(LEOLoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LEOLoginViewController"];
    VC.refresh=^(){
        [self viewDidLoad];
        [self.icollectionView reloadData];
        //开启定时器
        [GPS_timer setFireDate:[NSDate distantPast]];
    };
    [self presentViewController:VC animated:YES completion:^(){}];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:@"isLogin"];
    [userDefaults synchronize];
    
     //关闭定时器
    [GPS_timer setFireDate:[NSDate distantFuture]];

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
