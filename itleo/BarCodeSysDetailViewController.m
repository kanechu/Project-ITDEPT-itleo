//
//  BarCodeSysHomeViewController.m
//  itleo
//
//  Created by itdept on 14-12-22.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "BarCodeSysDetailViewController.h"
#import "WhsLogs_ViewController.h"
#import "SKSTableView.h"
#import "DB_whs_config.h"
#import "DB_LoginInfo.h"
#import "DB_RespAppConfig.h"
#import "Warehouse_log.h"
#import "Cell_advance_search.h"
#import "SKSTableViewCell.h"
#import "BarCodeViewController.h"

#define FIXSPACE 15
#define TEXTFIELD_TAG 100
typedef NSString* (^passValue)(NSInteger tag);

@interface BarCodeSysDetailViewController ()<SKSTableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_scan_log;

@property (strong, nonatomic) Custom_textField *checkText;
//存储组标题信息
@property (strong, nonatomic) NSMutableArray *alist_group_nameAndnum;
@property (strong, nonatomic) NSMutableArray *alist_filter_upload_cols;
//存储已经输入的数据
@property (strong, nonatomic) NSMutableDictionary *idic_textfield_value;
//存储已经输入的数据的副本
@property (strong, nonatomic) NSMutableDictionary *idic_value_copy;
//存储必须输入数据的项
@property (strong, nonatomic) NSMutableDictionary *idic_is_mandatory;
@property (strong, nonatomic) NSMutableDictionary *idic_datas;

@property (nonatomic,strong) passValue pass_Value;

@end

@implementation BarCodeSysDetailViewController
@synthesize alist_group_nameAndnum;
@synthesize alist_filter_upload_cols;
@synthesize idic_textfield_value;
@synthesize lang_code;

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
  
    [self fn_set_property];
    [self fn_add_right_items];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_property{
    NSString *_logo_title=[_idic_maintform valueForKey:lang_code];
    [_ibtn_whs_logo setTitle:_logo_title forState:UIControlStateNormal];
    [_ibtn_whs_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    _logo_title=nil;
    
    _ibtn_scan_log.layer.cornerRadius=5;
    [_ibtn_scan_log setTitle:MY_LocalizedString(@"lbl_scan_log", nil) forState:UIControlStateNormal];
    
    DB_whs_config *db_whs=[[DB_whs_config alloc]init];
    NSString *unique_id=[_idic_maintform valueForKey:@"unique_id"];
    alist_group_nameAndnum=[db_whs fn_get_cols_group_nameAndnum:unique_id];
    NSMutableArray *arr_upload_cols=[db_whs fn_get_upload_col_data:unique_id];
    unique_id=nil;
    
    alist_filter_upload_cols=[[NSMutableArray alloc]init];
    for (NSMutableDictionary *dic_group_data in alist_group_nameAndnum) {
        NSString *group_name=[dic_group_data valueForKey:@"group_name_en"];
        NSArray *arr_filtered=[arr_upload_cols filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(group_name_en==%@)",group_name]];
        [alist_filter_upload_cols addObject:arr_filtered];
        group_name=nil;
        arr_filtered=nil;
    }
    arr_upload_cols=nil;
    db_whs=nil;
    
    self.skstableView.SKSTableViewDelegate=self;
    [self.skstableView fn_expandall];
    //初始化字典，用于存储输入的数据
    Warehouse_log *whs_obj=[[Warehouse_log alloc]init];
    idic_textfield_value=[[NSDictionary dictionaryWithPropertiesOfObject:whs_obj]mutableCopy];
    _idic_is_mandatory=[[NSMutableDictionary alloc]initWithCapacity:1];
    DB_RespAppConfig *db_appConfig=[[DB_RespAppConfig alloc]init];
    NSMutableArray *alist_appconfig=[db_appConfig fn_get_all_RespAppConfig_data];
    NSString *php_addr;
    NSString *company_code=[db_appConfig fn_get_company_code];
    if ([alist_appconfig count]!=0) {
        NSMutableDictionary *idic_appconfig=[alist_appconfig objectAtIndex:0];
        php_addr=[idic_appconfig valueForKey:@"php_addr"];
        idic_appconfig=nil;
    }
    db_appConfig=nil;
    [idic_textfield_value setObject:company_code forKey:@"company_code"];
    [idic_textfield_value setObject:[_idic_maintform valueForKey:@"UPLOAD_TYPE"] forKey:@"upload_type"];
    NSString *str_php_func_url=[_idic_maintform valueForKey:@"PHP_FUNC"];
    str_php_func_url=[php_addr stringByAppendingString:str_php_func_url];
    [idic_textfield_value setObject:str_php_func_url forKey:@"php_func"];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    NSMutableArray *arr_login=[db_login fn_get_all_LoginInfoData];
    if ([arr_login count]!=0) {
        NSString *str_user_code=[[arr_login objectAtIndex:0] valueForKey:@"user_code"];
        [idic_textfield_value setObject:str_user_code forKey:@"user_code"];
    }
    db_login=nil;
    
    _idic_datas=[[NSMutableDictionary alloc]init];
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
}
-(NSString *)fn_get_group_name_field{
       NSString *filed_name=@"";
    if ([lang_code isEqualToString:@"EN"]) {
        filed_name=@"group_name_en";
    }else if ([lang_code isEqualToString:@"CN"]){
        filed_name=@"group_name_cn";
    }else if ([lang_code isEqualToString:@"TCN"]){
        filed_name=@"group_name_tcn";
    }
    return filed_name;
}
-(NSString *)fn_get_col_label_field{
    NSString *filed_name=@"";
    if ([lang_code isEqualToString:@"EN"]) {
        filed_name=@"col_label_en";
    }else if ([lang_code isEqualToString:@"CN"]){
        filed_name=@"col_label_cn";
    }else if ([lang_code isEqualToString:@"TCN"]){
        filed_name=@"col_label_tcn";
    }
    return filed_name;
}
-(void)fn_add_right_items{
    UIBarButtonItem *ibtn_save=[[UIBarButtonItem alloc]initWithTitle:MY_LocalizedString(@"ibtn_save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(fn_save_whs_data)];
    UIBarButtonItem *ibtn_space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ibtn_space.width=FIXSPACE;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,1.5,20)];
    view.backgroundColor=[UIColor lightGrayColor];
    UIBarButtonItem *ibtn_space1=[[UIBarButtonItem alloc]initWithCustomView:view];
    ibtn_space1.width=1.5;
    view=nil;
    UIBarButtonItem *ibtn_space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ibtn_space2.width=FIXSPACE;
    UIBarButtonItem *ibtn_cancel=[[UIBarButtonItem alloc]initWithTitle:MY_LocalizedString(@"lbl_cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(fn_cancel_operation)];
    NSArray *array=@[ibtn_save,ibtn_space,ibtn_space1,ibtn_space2,ibtn_cancel];
    self.navigationItem.rightBarButtonItems=array;
    array=nil;
}
#pragma mark -event action
- (void)fn_save_whs_data{
    NSInteger flag_can_saved=1;
    //用于标识必填项名
    NSString *str_mandatory=@"";
    for (NSString *str_key in [_idic_is_mandatory allKeys]) {
        NSString *str_value=[idic_textfield_value valueForKey:str_key];
        if ([str_value length]==0) {
            flag_can_saved=0;
            str_mandatory=[_idic_is_mandatory valueForKey:str_key];
            break;
        }
        str_value=nil;
    }
    if (![idic_textfield_value isEqual:_idic_value_copy] && flag_can_saved==1) {
        DB_whs_config *db_whs=[[DB_whs_config alloc]init];
        [db_whs fn_save_warehouse_log:[NSMutableDictionary dictionaryWithDictionary:idic_textfield_value]];
         _idic_value_copy=[NSMutableDictionary dictionaryWithDictionary:idic_textfield_value];
        
    }else if (flag_can_saved==1){
    
    }else{
        [self fn_show_alert_info:[NSString stringWithFormat:@"%@%@",str_mandatory, MY_LocalizedString(@"lbl_is_mandatory", nil)]];
    }
   
}
- (void)fn_cancel_operation{
    NSInteger flag_isExit=0;
    for (NSString *str_value in [_idic_datas allValues]) {
        if ([str_value length]!=0) {
            flag_isExit=1;
        }
    }
    if (flag_isExit==1) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:MY_LocalizedString(@"lbl_force_return", nil) delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_discard", nil) otherButtonTitles:MY_LocalizedString(@"ibtn_save",nil), nil];
        [alertView show];
    }else{
       [self.navigationController popViewControllerAnimated:YES]; 
    }
    
}

- (void)fn_scan_the_barcode:(id)sender{
    UIButton *ibtn=(UIButton*)sender;
    NSInteger tag=ibtn.tag;
    BarCodeViewController *barCodeVC=(BarCodeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BarCodeViewController"];
    barCodeVC.callback=^(NSString *str_code){
        NSString *os_column_key=_pass_Value(tag);
        [idic_textfield_value setObject:str_code forKey:os_column_key];
        
        self.skstableView.expandableCells=nil;
        [self.skstableView reloadData];
        [self.skstableView fn_expandall];
    };
    [self presentViewController:barCodeVC animated:YES completion:nil];
}
- (IBAction)fn_scan_log:(id)sender {
    WhsLogs_ViewController *whs_VC=(WhsLogs_ViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"WhsLogs_ViewController"];
    whs_VC.str_upload_type=[_idic_maintform valueForKey:@"UPLOAD_TYPE"];
    [self presentViewController:whs_VC animated:YES completion:nil];
}
#pragma mark -show alert
- (void)fn_show_alert_info:(NSString*)str_alert{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str_alert delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==[alertView cancelButtonIndex]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.checkText=(Custom_textField*)textField;
    [self.checkText fn_setLine_color:[UIColor blueColor]];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.checkText fn_setLine_color:[UIColor lightGrayColor]];
    NSString *os_column_key=_pass_Value(textField.tag);

    if ([textField.text length]!=0) {
        [idic_textfield_value setObject:textField.text forKey:os_column_key];
        [_idic_datas setObject:textField.text forKey:os_column_key];
    }
    os_column_key=nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -SKSTableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_group_nameAndnum count];
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numOfrow=[[alist_group_nameAndnum objectAtIndex:indexPath.row]valueForKey:@"num"];
    return [numOfrow integerValue];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取每组的字典
    NSDictionary *dic=[alist_group_nameAndnum objectAtIndex:indexPath.row];
    static NSString *cellIndentifier=@"SKSTableViewCell";
    SKSTableViewCell *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[SKSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.backgroundColor=COLOR_DARK_BLUE;
    cell.expandable=YES;
    NSString *language_type=[self fn_get_group_name_field];
    cell.textLabel.text=[dic valueForKey:language_type];
    cell.textLabel.textColor=[UIColor whiteColor];
    dic=nil;
    return cell;
}
-(UITableViewCell*)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=alist_filter_upload_cols[indexPath.row][indexPath.subRow-1];
    static NSString *cellIndentifer=@"Cell_whs_config";
    Cell_advance_search *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifer];
    
    cell.itf_inputdata.tag=TEXTFIELD_TAG*indexPath.row+indexPath.subRow;
    cell.itf_inputdata.delegate=self;
    
    __block BarCodeSysDetailViewController * blockSelf=self;
    _pass_Value=^NSString*(NSInteger tag){
        NSInteger i=tag/TEXTFIELD_TAG;
        NSInteger j=tag-i*TEXTFIELD_TAG-1;
        NSMutableDictionary *idic=blockSelf->alist_filter_upload_cols[i][j];
        NSString *col_field=[idic valueForKey:@"col_field"];
        return col_field;
    };
    NSString *col_type=[dic valueForKey:@"col_type"];
    NSInteger is_mandatory=[[dic valueForKey:@"is_mandatory"]integerValue];
    NSString *col_field=[dic valueForKey:@"col_field"];
    cell.itf_inputdata.text=[idic_textfield_value valueForKey:col_field];
    NSString *language_type=[self fn_get_col_label_field];
    if (is_mandatory==0) {
        cell.il_prompt.text=[NSString stringWithFormat:@"%@:",[dic valueForKey:language_type]];
        
    }else{
        NSString *str_prompt=[dic valueForKey:language_type];
        cell.il_prompt.text=[NSString stringWithFormat:@"%@:*",str_prompt];
        if (str_prompt!=nil) {
            [_idic_is_mandatory setObject:str_prompt forKey:col_field];
        }
    }
    
    if ([col_type isEqualToString:@"barcode"]) {
        UIButton *ibtn_barCode=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
        [ibtn_barCode setBackgroundImage:[UIImage imageNamed:@"barcode"] forState:UIControlStateNormal];
        [ibtn_barCode addTarget:self action:@selector(fn_scan_the_barcode:) forControlEvents:UIControlEventTouchUpInside];
        ibtn_barCode.tag=TEXTFIELD_TAG*indexPath.row+indexPath.subRow;
        cell.accessoryView=ibtn_barCode;
        ibtn_barCode=nil;
    }else{
        cell.accessoryView=nil;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
