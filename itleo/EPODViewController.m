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
#import "DB_ePod.h"
#import "DB_single_field.h"
#import "DB_Location.h"
#import "IsAuto_upload_data.h"
#import "SelectHistoryDataViewController.h"
#import "PopViewManager.h"
#import "LocationManager.h"
#import "IsAuto_upload_data.h"

#define  TIMEINTERVAL 60.0f

@interface EPODViewController ()

@property(nonatomic,strong)NSTimer *record_timer;
@property(nonatomic,strong)NSTimer *GPS_timer;
@property(nonatomic,strong)NSTimer *record_GPS_timer;

@end

@implementation EPODViewController
@synthesize record_timer;
@synthesize GPS_timer;
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
    [self fn_custom_gesture];
    [self fn_add_notificaiton];
    [self fn_show_unUpload_Msg_nums];
    [self fn_isStart_open_thread];
   	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_control_pro{
    self.title=MY_LocalizedString(@"lbl_epod_title", nil);
    _ilb_vehicle_no.text=[NSString stringWithFormat:@"%@:",MY_LocalizedString(@"lbl_vehicle_no", nil)];
    
    [_ibtn_lookUp setTitle:MY_LocalizedString(@"ibtn_lookup", nil) forState:UIControlStateNormal];
    [_ibtn_lookUp addTarget:self action:@selector(fn_lookUp_vehicle_no) forControlEvents:UIControlEventTouchUpInside];
    
    _ibtn_checkRecord.left_icon=[UIImage imageNamed:@"ibtn_search"];
    [_ibtn_checkRecord setTitle:MY_LocalizedString(@"ibtn_check_record", nil) forState:UIControlStateNormal];
    
    _ibtn_receive.left_icon=[UIImage imageNamed:@"ibtn_add"];
    [_ibtn_receive setTitle:MY_LocalizedString(@"ibtn_sign_photo", nil) forState:UIControlStateNormal];
    
    _ibtn_settings.left_icon=[UIImage imageNamed:@"ic_settings"];
    [_ibtn_settings setTitle:MY_LocalizedString(@"ibtn_settings", nil) forState:UIControlStateNormal];
    
    _itf_bus_no.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _itf_bus_no.layer.borderWidth=1;
    _itf_bus_no.layer.cornerRadius=4;
    _itf_bus_no.delegate=self;
}
-(void)fn_isStart_open_thread{
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSInteger _flag_transfer_record= [userDefault integerForKey:@"transfer_record"];
    if (_flag_transfer_record==1) {
        [self fn_open_upload_records_thread];
    }
     NSInteger _flag_transfer_GPS= [userDefault integerForKey:@"transfer_GPS"];
    if (_flag_transfer_GPS==1) {
        [self fn_open_upload_GPS_thread];
    }
    NSInteger _flag_record_GPS=[userDefault integerForKey:@"record_GPS"];
    if (_flag_record_GPS==1) {
        [self fn_open_record_GPS_thread];
    }
}
#pragma mark -addObserver notificaiton
-(void)fn_add_notificaiton{
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_show_unUpload_Msg_nums) name:@"upload_success" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_show_unUpload_Msg_nums) name:@"upload_fail" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_isAuto_transfer_record) name:@"transfer_record" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_isAuto_transmission_GPS) name:@"transfer_GPS" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_isRecord_GPS_coordinates) name:@"record_GPS" object:nil];
}

#pragma mark -Jump will execute method
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier]isEqualToString:@"segue_detail_epod"]) {
        EPODDetailViewController *VC=(EPODDetailViewController*)[segue destinationViewController];
        VC.vehicle_no=_itf_bus_no.text;
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
-(void)fn_show_unUpload_Msg_nums{
    DB_ePod *db=[[DB_ePod alloc]init];
    NSMutableArray *arr_epod=[db fn_select_unUpload_truck_order_data:@"0" isUploade2:@"2"];
    if ([arr_epod count]!=0) {
        NSString *title=[NSString stringWithFormat:@"%@: %d",MY_LocalizedString(@"show_unUpload_msg", nil),[arr_epod count]] ;
        
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

- (IBAction)fn_manually_settings:(id)sender {
    
}

-(void)fn_Pop_up_alertView:(NSString*)str_prompt{
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:str_prompt delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
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
#pragma mark -open a thread
-(void)fn_isAuto_transfer_record{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSInteger _flag_transfer_record= [userDefault integerForKey:@"transfer_record"];
    if (_flag_transfer_record==1) {
        //开启定时器
        [record_timer setFireDate:[NSDate distantPast]];
        [self fn_open_upload_records_thread];
    }else{
        //关闭定时器
        [record_timer setFireDate:[NSDate distantFuture]];
    }

}
-(void)fn_isAuto_transmission_GPS{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSInteger _flag_transfer_GPS= [userDefault integerForKey:@"transfer_GPS"];
    if (_flag_transfer_GPS==1) {
        //开启定时器
        [GPS_timer setFireDate:[NSDate distantPast]];
        [self fn_open_upload_GPS_thread];
    }else{
        //关闭定时器
        [GPS_timer setFireDate:[NSDate distantFuture]];
    }
}
-(void)fn_isRecord_GPS_coordinates{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSInteger _flag_record_GPS= [userDefault integerForKey:@"record_GPS"];
    if (_flag_record_GPS==1) {
        [self fn_open_upload_GPS_thread];
        //开启定时器
        [_record_GPS_timer setFireDate:[NSDate distantPast]];
    }else{
        //关闭定时器
        [_record_GPS_timer setFireDate:[NSDate distantFuture]];
    }
}

-(void)fn_open_upload_records_thread{
    IsAuto_upload_data *obj=[[IsAuto_upload_data alloc]init];
    //获取全局的并发队列
    dispatch_queue_t my_Queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(my_Queue, ^{
        record_timer=[NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:obj selector:@selector(fn_Automatically_upload_data) userInfo:nil repeats:YES];
        //定时器要加入runloop中才能执行
        [[NSRunLoop currentRunLoop]run];
    });
}
-(void)fn_open_upload_GPS_thread{
    IsAuto_upload_data *obj=[[IsAuto_upload_data alloc]init];
    dispatch_queue_t my_Queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(my_Queue, ^{
        GPS_timer=[NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:obj selector:@selector(fn_Auto_upload_GPS) userInfo:nil repeats:YES];
        //定时器要加入runloop中才能执行
        [[NSRunLoop currentRunLoop]run];
    });
}
-(void)fn_open_record_GPS_thread{
    dispatch_queue_t my_Queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(my_Queue, ^{
        _record_GPS_timer=[NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(fn_record_GPS_coordinates) userInfo:nil repeats:YES];
        //定时器要加入runloop中才能执行
        [[NSRunLoop currentRunLoop]run];
    });
    
}
-(void)fn_record_GPS_coordinates{
   __block LocationManager *location_obj=[LocationManager fn_shareManager];
    [location_obj fn_startUpdating];
    location_obj.call_value=^(NSString *longitude,NSString *latitude){
        DB_Location *db=[[DB_Location alloc]init];
        [db fn_save_loaction_data:longitude latitude:latitude car_no:_itf_bus_no.text];
    };
    
}

@end
