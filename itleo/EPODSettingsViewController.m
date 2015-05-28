//
//  EPODSettingsViewController.m
//  itleo
//
//  Created by itdept on 14-10-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "EPODSettingsViewController.h"
#import "RangeSelectViewController.h"
#import "DB_sypara.h"
#import "settings_dataModel.h"
#define TABLE_HEADER_HEIGHT 40
#define DEFAULT_TAG 100
@interface EPODSettingsViewController ()
@property (strong,nonatomic)NSMutableArray *alist_settings;

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_setting_logo;

@property (weak, nonatomic) IBOutlet UIButton *ibtn_back;

@property (assign,nonatomic)kRange_type range_type;

@property (copy, nonatomic)NSString *str_select_range;

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
    [self fn_setExtraCellLineHidden];
    [self fn_init_settings];
    //[self fn_isUsed_GPS_function];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"selected_range" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_range:) name:@"selected_range" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fn_set_control_pro{
    [_ibtn_setting_logo setTitle:MY_LocalizedString(@"ibtn_settings",nil) forState:UIControlStateNormal];
    [_ibtn_setting_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    [_ibtn_back setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
    [_ibtn_back addTarget:self action:@selector(fn_back_previous_page:)  forControlEvents:UIControlEventTouchUpInside];
  
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:MY_LocalizedString(@"ibtn_settings", nil)
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:nil
                                                                          action:nil];
    [self.navigationItem setHidesBackButton:YES];
    
}
- (void)fn_init_settings{
    
    NSMutableArray *alist_epod_settings=[NSMutableArray array];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *date_key=[userDefaults objectForKey:SETTINGS_DATE_RANGE];
    if ([date_key length]==0) {
        date_key=@"lbl_day";
        [userDefaults setObject:date_key forKey:SETTINGS_DATE_RANGE];
    }
    [alist_epod_settings addObject:[settings_dataModel fn_get_settings_dataModel:MY_LocalizedString(@"lbl_date_range", nil) interval:MY_LocalizedString(date_key, nil) type:SELECT_INTERVAL switch_isOn:NO]];
    date_key=nil;
    
    NSString *interval_key=[userDefaults objectForKey:SETTINGS_ORDER_INTERVAL];
    if ([interval_key length]==0) {
        interval_key=@"lbl_minute";
        [userDefaults setObject:interval_key forKey:SETTINGS_ORDER_INTERVAL];
    }
    [alist_epod_settings addObject:[settings_dataModel fn_get_settings_dataModel:MY_LocalizedString(@"lbl_interval", nil) interval:MY_LocalizedString(interval_key, nil) type:SELECT_INTERVAL switch_isOn:NO]];
    interval_key=nil;
    
    NSString *gps_interval_key=[userDefaults objectForKey:SETTINGS_GPS_INTERVAL];
    if ([gps_interval_key length]==0) {
        gps_interval_key=@"lbl_minute";
        [userDefaults setObject:gps_interval_key forKey:SETTINGS_GPS_INTERVAL];
    }
    [alist_epod_settings addObject:[settings_dataModel fn_get_settings_dataModel:MY_LocalizedString(@"lbl_gps_interval", nil) interval:MY_LocalizedString(gps_interval_key, nil) type:SELECT_INTERVAL switch_isOn:NO]];
    gps_interval_key=nil;
    
    NSInteger _flag_transfer_record= [userDefaults integerForKey:SETTINGS_AUTO_UPLOAD_RECORD];
    BOOL switch_isOn=YES;
    if (_flag_transfer_record==0) {
        switch_isOn=NO;
    }
    [alist_epod_settings addObject:[settings_dataModel fn_get_settings_dataModel:MY_LocalizedString(@"lbl_transfer_records", nil) interval:nil type:SWITCH_FUNCTION switch_isOn:switch_isOn]];
    
    NSInteger _flag_transfer_GPS=[userDefaults integerForKey:SETTINGS_AUTO_UPLOAD_GPS];
    BOOL gps_switch_isOn=YES;
    if (_flag_transfer_GPS==0) {
        gps_switch_isOn=NO;
    }
    [alist_epod_settings addObject:[settings_dataModel fn_get_settings_dataModel:MY_LocalizedString(@"lbl_record_andUpload_GPS", nil) interval:nil type:SWITCH_FUNCTION switch_isOn:gps_switch_isOn]];
    
    _alist_settings=[NSMutableArray arrayWithObject:alist_epod_settings];
    
    NSMutableArray  *alist_warehouse_settings=[NSMutableArray array];
    NSString *whs_interval_key=[userDefaults objectForKey:SETTINGS_WHS_INTERVAL];
    if ([whs_interval_key length]==0) {
        whs_interval_key=@"lbl_minute";
        [userDefaults setObject:whs_interval_key forKey:SETTINGS_WHS_INTERVAL];
    }
    [alist_warehouse_settings addObject:[settings_dataModel fn_get_settings_dataModel:MY_LocalizedString(@"lbl_upload_warehouse_interval", nil) interval:MY_LocalizedString(whs_interval_key, nil) type:SELECT_INTERVAL switch_isOn:NO]];
    whs_interval_key=nil;
    [self.alist_settings addObject:alist_warehouse_settings];
    
}

#pragma mark -event action

- (IBAction)fn_back_previous_page:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fn_isAuto_transfer_data:(id)sender{
    UISwitch *switchObj=(UISwitch*)sender;
    NSInteger switch_tag=switchObj.tag-DEFAULT_TAG;
    NSString *flag_result;
    if (switchObj.on) {
        flag_result=@"1";
    }else{
        flag_result=@"0";
    }
    if (switch_tag==2) {
        [self fn_define_userDefaults:flag_result key:SETTINGS_AUTO_UPLOAD_RECORD];
        [[NSNotificationCenter defaultCenter]postNotificationName:SETTINGS_AUTO_UPLOAD_RECORD object:flag_result];
    }
    if (switch_tag==3) {
        [self fn_define_userDefaults:flag_result key:SETTINGS_AUTO_UPLOAD_GPS];
        [[NSNotificationCenter defaultCenter]postNotificationName:SETTINGS_AUTO_UPLOAD_GPS object:flag_result];
    }
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
    return [_alist_settings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_alist_settings objectAtIndex:section]count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer=@"cell_settings";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    NSMutableArray *alist_settings=[_alist_settings objectAtIndex:indexPath.section];
    settings_dataModel *obj=[alist_settings objectAtIndex:indexPath.row];
    cell.textLabel.text=obj.promptStr;
    cell.detailTextLabel.text=obj.intervalStr;
    NSInteger flag_type=obj.flag_settings_type;
    if (flag_type==SWITCH_FUNCTION) {
        UISwitch *switchObj=[[UISwitch alloc]init];
        [switchObj addTarget:self action:@selector(fn_isAuto_transfer_data:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=switchObj;
        switchObj.tag=DEFAULT_TAG+indexPath.row;
        switchObj.on=obj.switch_isOn;
    }
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return MY_LocalizedString(@"module_epod", nil);
    }else if (section==1){
       return MY_LocalizedString(@"module_warehouse", nil);
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return TABLE_HEADER_HEIGHT;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *alist_settings=[_alist_settings objectAtIndex:indexPath.section];
    settings_dataModel *dataModel_obj=[alist_settings objectAtIndex:indexPath.row];
    if (dataModel_obj.flag_settings_type==SELECT_INTERVAL) {
        if ([dataModel_obj.promptStr isEqualToString:MY_LocalizedString(@"lbl_date_range", nil)]) {
            _range_type=kDate_range;
            _str_select_range=[userDefaults objectForKey:SETTINGS_DATE_RANGE];
        }
        if ([dataModel_obj.promptStr isEqualToString:MY_LocalizedString(@"lbl_interval", nil)]) {
            _range_type=kOrder_interval_range;
            _str_select_range=[userDefaults objectForKey:SETTINGS_ORDER_INTERVAL];
        }
        if ([dataModel_obj.promptStr isEqualToString:MY_LocalizedString(@"lbl_gps_interval", nil)]) {
            _range_type=kGPS_interval_range;
            _str_select_range=[userDefaults objectForKey:SETTINGS_GPS_INTERVAL];
        }
        if ([dataModel_obj.promptStr isEqualToString:MY_LocalizedString(@"lbl_upload_warehouse_interval", nil)]) {
            _range_type=kWhs_interval_range;
            _str_select_range=[userDefaults objectForKey:SETTINGS_WHS_INTERVAL];
        }
        [self performSegueWithIdentifier:@"Segue_RangeSelecte" sender:nil];
    }
}
-(void)fn_setExtraCellLineHidden{
    UIView *view=[[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor=[UIColor clearColor];
    [self.tableView setTableFooterView:view];
    view=nil;
}

-(void)fn_update_range:(NSNotification*)notification{
    NSString *key_obj=(NSString*)[notification object];
    if (_range_type==kDate_range) {
        
        [self fn_define_userDefaults:key_obj key:SETTINGS_DATE_RANGE];
        
    }else if(_range_type==kOrder_interval_range){
        
        [self fn_define_userDefaults:key_obj key:SETTINGS_ORDER_INTERVAL];
        
    }else if (_range_type==kGPS_interval_range){
        
        [self fn_define_userDefaults:key_obj key:SETTINGS_GPS_INTERVAL];
    }else if(_range_type==kWhs_interval_range){
        
        [self fn_define_userDefaults:key_obj key:SETTINGS_WHS_INTERVAL];
    }
    
    [self fn_init_settings];
    [self.tableView reloadData];
}
#pragma mark - push must action method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    RangeSelectViewController *VC=(RangeSelectViewController*)[segue destinationViewController];
    VC.str_range=_str_select_range;
    VC.range_type=_range_type;
}

@end
