//
//  EPODSettingsViewController.m
//  itleo
//
//  Created by itdept on 14-10-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "EPODSettingsViewController.h"
#import "RangeSelectViewController.h"

@interface EPODSettingsViewController ()
@property (strong,nonatomic)NSMutableArray *alist_variate;
@property (assign,nonatomic)NSInteger flag_transfer_record;
@property (assign,nonatomic)NSInteger flag_transfer_GPS;
@property (assign,nonatomic)NSInteger flag_record_GPS;
@property (assign,nonatomic)NSInteger flag_range_type;
@property (copy, nonatomic)NSString *str_date_range;
@property (copy, nonatomic)NSString *str_interval_range;
@end

@implementation EPODSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_set_control_pro];
    [self fn_assignment_flag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_assignment_flag{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    _flag_transfer_record= [userDefaults integerForKey:@"transfer_record"];
    _flag_transfer_GPS=[userDefaults integerForKey:@"transfer_GPS"];
    _flag_record_GPS=[userDefaults integerForKey:@"record_GPS"];
    NSString *date_key=[userDefaults objectForKey:@"date_range"];
    if ([date_key length]!=0) {
        _ilb_date_range.text=MY_LocalizedString(date_key, nil);
        _str_date_range=date_key;
    }else{
        _str_date_range=@"lbl_day";
        _ilb_date_range.text=MY_LocalizedString(_str_date_range, nil);
    }
    NSString *interval_key=[userDefaults objectForKey:@"interval_range"];
    if ([interval_key length]!=0) {
        _ilb_interval.text=MY_LocalizedString(interval_key, nil);
        _str_interval_range=interval_key;
        
    }else{
        _str_interval_range=@"lbl_seconds";
        _ilb_interval.text=MY_LocalizedString(_str_interval_range, nil);
    }
}
-(void)fn_set_control_pro{
    [_ibtn_setting_logo setTitle:MY_LocalizedString(@"ibtn_settings",nil) forState:UIControlStateNormal];
    [_ibtn_setting_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    _ilb_search_range.text=MY_LocalizedString(@"lbl_date_range", nil);
 _ilb_auto_range.text=MY_LocalizedString(@"lbl_interval", nil);
    _ilb_transfer.text=MY_LocalizedString(@"lbl_transfer_records", nil);
    _ilb_transfer_GPS.text=MY_LocalizedString(@"lbl_transfer_GPS", nil);
    _ilb_record_GPS.text=MY_LocalizedString(@"lbl_record_GPS", nil);
    
    _ibtn_back.layer.cornerRadius=4;
    _ibtn_back.layer.borderColor=COLOR_light_BLUE.CGColor;
    _ibtn_back.layer.borderWidth=1.5;
    [_ibtn_back setTitle:MY_LocalizedString(@"lbl_back", nil) forState:UIControlStateNormal];
    [_ibtn_back addTarget:self action:@selector(fn_back_previous_page:)  forControlEvents:UIControlEventTouchUpInside];
    
    [_is_switch addTarget:self action:@selector(fn_isAuto_transfer_data) forControlEvents:UIControlEventValueChanged];
   
    [_is_switch1 addTarget:self action:@selector(fn_isAuto_transfer_GPS) forControlEvents:UIControlEventValueChanged];
    [_is_switch2 addTarget:self action:@selector(fn_isRecord_GPS) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:MY_LocalizedString(@"ibtn_settings", nil)
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:nil
                                                                          action:nil];
    [self.navigationItem setHidesBackButton:YES];
    
}
#pragma mark -event action
-(void)fn_back_previous_page:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)fn_isAuto_transfer_data{
    NSString *flag_result;
    if (_is_switch.on) {
        flag_result=@"1";
    }else{
        flag_result=@"0";
    }
    [self fn_define_userDefaults:flag_result key:@"transfer_record"];
    
}
-(void)fn_isAuto_transfer_GPS{
    NSString* flag_result;
    if (_is_switch.on) {
        flag_result=@"1";
    }else{
        flag_result=@"0";
    }
    [self fn_define_userDefaults:flag_result key:@"transfer_GPS"];
}
-(void)fn_isRecord_GPS{
    NSString *flag_result;
    if (_is_switch.on) {
        flag_result=@"1";
    }else{
        flag_result=@"0";
    }
    [self fn_define_userDefaults:flag_result key:@"record_GPS"];
}

-(void)fn_define_userDefaults:(NSString*)result key:(NSString*)key{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:result forKey:key];
    [userDefaults synchronize];
}
-(void)fn_PopUp_alert:(NSString*)str_alert{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str_alert delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_cancel", nil)otherButtonTitles:MY_LocalizedString(@"lbl_delete", nil) , nil];
    [alert show];
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return 2;
    }
    if (section==1) {
        return 3;
    }
    if (section==2) {
        return 1;
    }
    return 0;
}
#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        _flag_range_type=indexPath.row;
        [self performSegueWithIdentifier:@"Segue_RangeSelecte" sender:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_range:) name:@"selected_range" object:nil];
        
    }
}
-(void)fn_update_range:(NSNotification*)notification{
    NSString *key_obj=(NSString*)[notification object];
    if (_flag_range_type==0) {
        _ilb_date_range.text=MY_LocalizedString(key_obj, nil);
        [self fn_define_userDefaults:key_obj key:@"date_range"];
        _str_date_range=key_obj;
    }else if(_flag_range_type==1){
        _ilb_interval.text=MY_LocalizedString(key_obj, nil);
        [self fn_define_userDefaults:key_obj key:@"interval_range"];
        _str_interval_range=key_obj;
    }
}
#pragma mark - push must action method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RangeSelectViewController *VC=(RangeSelectViewController*)[segue destinationViewController];
    if (_flag_range_type==0) {
        VC.str_range=_str_date_range;
    }else{
        VC.str_range=_str_interval_range;
    }
    VC.flag_range_type=_flag_range_type;
}

@end