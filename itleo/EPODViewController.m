//
//  EPODViewController.m
//  itleo
//
//  Created by itdept on 14-9-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "EPODViewController.h"
#import "EPODDetailViewController.h"
#import "EPODRecordViewController.h"
#import "SelectHistoryDataViewController.h"
#import "OrderListViewController.h"
#import "DB_ePod.h"
#import "DB_single_field.h"
#import "DB_Location.h"
#import "Timer_bg_upload_data.h"
#import "PopViewManager.h"
#import "LocationManager.h"
#import "IsAuto_upload_data.h"
#import "Web_order_list.h"
#import "DB_sypara.h"

@interface EPODViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *ilb_epod_tilte;
@property (nonatomic,assign)NSInteger flag_opened_record_thread;
@property (nonatomic,assign)NSInteger flag_opened_gps_thread;

@end

@implementation EPODViewController

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
    [self fn_set_control_pro];
    [self fn_isOpen_GPS];
    [self fn_custom_gesture];
    [self fn_add_notificaiton];
    [self fn_show_unUpload_Msg_nums];
   	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_textfield_textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_control_pro{
    self.title=MY_LocalizedString(@"lbl_epod_title", nil);
    _ilb_epod_tilte.text=MY_LocalizedString(@"lbl_epod_detail", nil);
    _ilb_vehicle_no.text=[NSString stringWithFormat:@"%@:",MY_LocalizedString(@"lbl_vehicle_no", nil)];
    
    [_ibtn_lookUp setTitle:MY_LocalizedString(@"ibtn_lookup", nil) forState:UIControlStateNormal];
    [_ibtn_lookUp addTarget:self action:@selector(fn_lookUp_vehicle_no) forControlEvents:UIControlEventTouchUpInside];
    
    _ibtn_checkRecord.left_icon=[UIImage imageNamed:@"ibtn_search"];
    [_ibtn_checkRecord setTitle:MY_LocalizedString(@"ibtn_check_record", nil) forState:UIControlStateNormal];
    
    _ibtn_receive.left_icon=[UIImage imageNamed:@"ibtn_add"];
    [_ibtn_receive setTitle:MY_LocalizedString(@"ibtn_sign_photo", nil) forState:UIControlStateNormal];
    
    _ibtn_orderList.left_icon=[UIImage imageNamed:@"ibtn_add"];
    [_ibtn_orderList setTitle:MY_LocalizedString(@"ibtn_order_list", nil) forState:UIControlStateNormal];
    
    _itf_bus_no.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _itf_bus_no.layer.borderWidth=1;
    _itf_bus_no.layer.cornerRadius=4;
    _itf_bus_no.delegate=self;
    
    DB_sypara *db_syparaObj=[[DB_sypara alloc]init];
    if ([db_syparaObj fn_isExist_sypara_data:PARA_CODE_ORDERLIST data1:PARA_DATA1]) {
        _ibtn_receive.hidden=YES;
    }else{
        _ibtn_orderList.hidden=YES;
    }
}
/**
 *  sypara 的para_code如果為MOB_REC_GPS gps必須是打開狀態
 */
- (void)fn_isOpen_GPS{
    DB_sypara *db_sypara_obj=[[DB_sypara alloc]init];
    if ([db_sypara_obj fn_isMust_open_the_GPS:PARA_CODE_GPS data2:PARA_DATA2]) {
        LocationManager *location_obj=[LocationManager fn_shareManager];
        if (![location_obj fn_isLocationServiceOn] ||   ![location_obj fn_isCurrentAppLocatonServiceOn]) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:MY_LocalizedString(@"open_gps_alert_title", nil) message:MY_LocalizedString(@"open_gps_alert_content", nil) delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_ok",nil) otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            [self fn_isRecord_GPS_coordinates];
        }
    }
}
-(void)fn_isRecord_GPS_coordinates{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSInteger _flag_record_GPS= [userDefault integerForKey:SETTINGS_AUTO_UPLOAD_GPS];
    if (_flag_record_GPS==1) {
        //gps开始记录坐标
        LocationManager *location_obj=[LocationManager fn_shareManager];
        [location_obj fn_startUpdating];
        location_obj.call_value=^(NSString *longitude,NSString *latitude){
            DB_Location *db=[[DB_Location alloc]init];
            [db fn_save_loaction_data:longitude latitude:latitude car_no:_itf_bus_no.text];
        };
    }
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ( buttonIndex==[alertView cancelButtonIndex] ) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -addObserver notificaiton
-(void)fn_add_notificaiton{
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_show_unUpload_Msg_nums) name:@"upload_success" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_show_unUpload_Msg_nums) name:@"upload_fail" object:nil];
}

#pragma mark -Jump will execute method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier]isEqualToString:@"segue_detail_epod"]) {
        EPODDetailViewController *VC=(EPODDetailViewController*)[segue destinationViewController];
        VC.vehicle_no=_itf_bus_no.text;
    }
    if ( [[segue identifier]isEqualToString:@"segue_order_list"] ) {
        OrderListViewController *orderlistVC=(OrderListViewController*)[segue destinationViewController];
        orderlistVC.vehicle_no=_itf_bus_no.text;
    }
    
}
#pragma mark -UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self fn_show_unUpload_Msg_nums];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_itf_bus_no resignFirstResponder];
    return YES;
}
/**
 *  填车牌的时候，即使trim掉所有空白格，把所有英文字母变大写
 */
- (void)fn_textfield_textDidChange{
    NSString *original_str=_itf_bus_no.text;
    if ([original_str length]!=0) {
        //把英文字母变大写
        original_str=[original_str uppercaseString];
        _itf_bus_no.text=[original_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    original_str=nil;
}
/**
 *  底部显示没有上次的order数量
 */
-(void)fn_show_unUpload_Msg_nums{
    DB_ePod *db=[[DB_ePod alloc]init];
    NSMutableArray *arr_epod=[db fn_select_unUpload_truck_order_data:@"0" isUploade2:@"2"];
    if ([arr_epod count]!=0) {
        NSString *title=[NSString stringWithFormat:@"%@: %@",MY_LocalizedString(@"show_unUpload_msg", nil),@(arr_epod.count)] ;
        
        [_ibtn_showMsg setTitle:title forState:UIControlStateNormal];
    }else{
        [_ibtn_showMsg setTitle:@"" forState:UIControlStateNormal];
    }
    
}
#pragma mark -add TapGestureRecognizer
- (void)fn_custom_gesture{
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_hidden_keyboard:)];
    [self.view addGestureRecognizer:gesture];
}
- (void)fn_hidden_keyboard:(UITapGestureRecognizer*)gesture{
    [_itf_bus_no resignFirstResponder];
}
#pragma mark -event action
- (void)fn_lookUp_vehicle_no{
    DB_single_field *db=[[DB_single_field alloc]init];
    NSMutableArray *alist_vehicle_no=[db fn_get_data:@"vehicle_no"];
    if ([alist_vehicle_no count]==0) {
        [self fn_Pop_up_alertView:MY_LocalizedString(@"no_history_data", nil)];
    }else{
        [self fn_popup_history_vehicle_no_listView:alist_vehicle_no];
    }
}
- (IBAction)fn_fignature_photograph:(id)sender {
    IsAuto_upload_data *obj=[[IsAuto_upload_data alloc]init];
    [obj fn_Auto_upload_GPS];
    if ([_itf_bus_no.text length]!=0) {
        [self performSegueWithIdentifier:@"segue_detail_epod" sender:self];
        [self fn_save_vehicle_no];
    }else{
        [self fn_Pop_up_alertView:MY_LocalizedString(@"vehicle_empty", nil)];
    }
}

- (IBAction)fn_check_record:(id)sender {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_show_unUpload_Msg_nums) name:@"delete_success" object:nil];
}

- (IBAction)fn_check_order_list:(id)sender {
    if ([_itf_bus_no.text length]!=0) {
        [SVProgressHUD showWithStatus:MY_LocalizedString(@"load_order_alert", nil)];
        Web_order_list *web_obj=[[Web_order_list alloc]init];
        NSSet *arr_uid=[NSSet setWithObject:@""];
        web_obj.vehicle_no=_itf_bus_no.text;
        [web_obj fn_handle_order_list_data:arr_uid type:kGet_order_list];
        web_obj.callback=^(NSMutableArray* alist_result){
            [self performSegueWithIdentifier:@"segue_order_list" sender:self];
            [self fn_save_vehicle_no];
            [SVProgressHUD dismiss];
        };
    
    }else{
        [self fn_Pop_up_alertView:MY_LocalizedString(@"vehicle_empty", nil)];
    }
}

-(void)fn_Pop_up_alertView:(NSString*)str_prompt{
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:str_prompt delegate:nil cancelButtonTitle:MY_LocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
    [alertview show];
}
#pragma mark -popup vehicle_no list
-(void)fn_popup_history_vehicle_no_listView:(NSMutableArray*)alist_sys{
    SelectHistoryDataViewController *VC=(SelectHistoryDataViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectHistoryDataViewController"];
    VC.alist_sys_code=alist_sys;
    VC.field_name=@"vehicle_no";
    VC.callback=^(NSMutableDictionary *idic){
        _itf_bus_no.text=[idic valueForKey:@"vehicle_no"];
    };
    PopViewManager *pop_obj=[[PopViewManager alloc]init];
    [pop_obj fn_PopupView:VC Size:CGSizeMake(230, 300) uponView:self];
}
#pragma mark -save vehicle_no
-(void)fn_save_vehicle_no{
    DB_single_field *db=[[DB_single_field alloc]init];
    [db fn_save_data:@"vehicle_no" table_field:@"vehicle_no" field_value:_itf_bus_no.text];
}
@end
