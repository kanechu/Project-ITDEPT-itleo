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
#import "IsAuto_upload_data.h"
#import "SelectHistoryDataViewController.h"
#import "PopViewManager.h"
#import "LocationManager.h"
@interface EPODViewController ()

@property(nonatomic,strong)NSTimer *my_timer;
@property(nonatomic,assign)NSInteger flag_isOpened_GCD;

@end

@implementation EPODViewController
@synthesize my_timer;

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
    [[LocationManager fn_shareManager]fn_startUpdating];
    [self fn_set_control_pro];
    [self fn_custom_gesture];
    [self fn_add_notificaiton];
    [self fn_show_unUpload_Msg_nums];
    if (_is_switch.on) {
        [self fn_open_new_thread];
        _flag_isOpened_GCD=1;
    }
    
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
    
    _ilb_transfer.text=MY_LocalizedString(@"lbl_transfer", nil);
    
    [_is_switch addTarget:self action:@selector(fn_isAuto_transfer_data) forControlEvents:UIControlEventValueChanged];
    
    
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

-(void)fn_isAuto_transfer_data{
    if (_is_switch.on) {
        //开启定时器
        [my_timer setFireDate:[NSDate distantPast]];
        if (_flag_isOpened_GCD!=1) {
            [self fn_open_new_thread];
        }
    }else{
        //关闭定时器
        [my_timer setFireDate:[NSDate distantFuture]];
    }
}
-(void)fn_open_new_thread{
    IsAuto_upload_data *obj=[[IsAuto_upload_data alloc]init];
    dispatch_queue_t my_Queue= dispatch_queue_create("uploading", NULL);
    dispatch_async(my_Queue, ^{
        my_timer=[NSTimer scheduledTimerWithTimeInterval:10.0f target:obj selector:@selector(fn_Automatically_upload_data) userInfo:nil repeats:YES];
        //定时器要加入runloop中才能执行
        [[NSRunLoop currentRunLoop]run];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
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

@end
