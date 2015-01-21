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
#import "Web_whs_config.h"
#import "SelectHistoryDataViewController.h"
#import "PopViewManager.h"
#import "CheckNetWork.h"
#define FIXSPACE 15
#define TEXTFIELD_TAG 100
typedef NSDictionary* (^passValue)(NSInteger tag);

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
//存储选项
@property (strong, nonatomic)   NSMutableDictionary *dic_options;
@property (nonatomic,strong) passValue pass_Value;
@property (strong,nonatomic)UIDatePicker *idp_picker;
//id_startdate用来记录日期拾取器获取的日期
@property (copy,nonatomic)NSDate *id_startdate;

@end

@implementation BarCodeSysDetailViewController
@synthesize alist_group_nameAndnum;
@synthesize alist_filter_upload_cols;
@synthesize idic_textfield_value;
@synthesize lang_code;
@synthesize idp_picker;
@synthesize id_startdate;
@synthesize dic_options;

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
    [self fn_create_datePick];
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
    NSString *php_addr=[db_appConfig fn_get_field_content:kPhp_addr];
    NSString *company_code=[db_appConfig fn_get_field_content:kCompany_code];
    db_appConfig=nil;
    [idic_textfield_value setObject:company_code forKey:@"company_code"];
    [idic_textfield_value setObject:[_idic_maintform valueForKey:@"UPLOAD_TYPE"] forKey:@"type_code"];
    NSString *str_php_func_url=[_idic_maintform valueForKey:@"PHP_FUNC"];
    str_php_func_url=[php_addr stringByAppendingString:[NSString stringWithFormat:@"/%@",str_php_func_url]];
    [idic_textfield_value setObject:str_php_func_url forKey:@"php_func"];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    [idic_textfield_value setObject:auth.user_code forKey:@"usrname"];
    [idic_textfield_value setObject:auth.password forKey:@"usrpass"];
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
-(NSMutableDictionary*)fn_get_options:(NSString*)col_options{
    NSMutableDictionary *idic_options=[[NSMutableDictionary alloc]init];
    NSArray *arr_options=[col_options componentsSeparatedByString:@","];
    for (NSString *str_option in arr_options) {
        NSArray *arr_subOpitons=[str_option componentsSeparatedByString:@"/"];
        NSString *str_value=[arr_subOpitons objectAtIndex:0];
        NSString *str_key=[arr_subOpitons objectAtIndex:1];
        [idic_options setObject:str_value forKey:str_key];
        arr_subOpitons=nil;
        str_value=nil;
        str_key=nil;
        
    }
    return idic_options;
}
#pragma mark -event action
- (void)fn_save_whs_data{
    //用于标识刚输入的内容，是否已经保存过
    NSInteger flag_isSaved=1;
    if ([idic_textfield_value isEqual:_idic_value_copy]) {
        flag_isSaved=0;
    }
    //用于标识必填项，是否不为空
     NSInteger flag_can_saved=1;
    //用于存储必填项名
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
    
    //dic_parameters post到服务器的参数表
    NSMutableDictionary *dic_parameters=[NSMutableDictionary dictionaryWithDictionary:idic_textfield_value];
    [idic_textfield_value setObject:@"" forKey:@"result_message"];
    [idic_textfield_value setObject:@"" forKey:@"result_status"];
    for (NSString *str_key in idic_textfield_value.allKeys) {
        NSString *str_value=[idic_textfield_value valueForKey:str_key];
        if ([str_value length]==0) {
            [dic_parameters removeObjectForKey:str_key];
        }
        str_value=nil;
    }
   
    if (flag_isSaved==1 && flag_can_saved==1) {
        
        Web_whs_config *web_obj=[[Web_whs_config alloc]init];
        web_obj.str_url=[dic_parameters valueForKey:@"php_func"];
        [dic_parameters removeObjectForKey:@"php_func"];
        [dic_parameters removeObjectForKey:@"company_code"];
        
        DB_whs_config *db_whs=[[DB_whs_config alloc]init];
        CheckNetWork *check_obj=[[CheckNetWork alloc]init];
        if ([check_obj fn_isPopUp_alert]) {
            //status為2代表網絡連接失敗
            [idic_textfield_value setObject:@"2" forKey:@"result_status"];
            [db_whs fn_save_warehouse_log:[NSMutableDictionary dictionaryWithDictionary:idic_textfield_value]];
            _idic_value_copy=[NSMutableDictionary dictionaryWithDictionary:idic_textfield_value];
        }else{
            [SVProgressHUD showWithStatus:MY_LocalizedString(@"lbl_saving_alert", nil)];
            [dic_parameters setObject:lang_code forKey:@"lang_code"];
            [web_obj fn_post_multipart_formData_to_server:dic_parameters completionHandler:^(NSMutableDictionary* dic_result){
                NSDictionary *dic_operation=[[dic_result valueForKey:@"result"] valueForKey:@"operation"];
                NSString  *str_status=[dic_operation valueForKey:@"status"];
                NSString *str_msg=[dic_operation valueForKey:@"message_lang"];
                
                if ([str_status boolValue]) {
                    [SVProgressHUD dismissWithSuccess:MY_LocalizedString(@"lbl_save_success", nil) afterDelay:2.0];
                }else{
                    [SVProgressHUD dismissWithError:MY_LocalizedString(@"lbl_save_fail", nil) afterDelay:2.0];
                }
                [_idic_datas removeAllObjects];
                if ([str_msg length]==0) {
                    str_msg=@"";
                }
                [idic_textfield_value setObject:str_msg forKey:@"result_message"];
                [idic_textfield_value setObject:str_status forKey:@"result_status"];
                [db_whs fn_save_warehouse_log:[NSMutableDictionary dictionaryWithDictionary:idic_textfield_value]];
                _idic_value_copy=[NSMutableDictionary dictionaryWithDictionary:idic_textfield_value];
            }];
        }
        
    }else if (flag_can_saved==1 && flag_isSaved==0){
        [self fn_show_alert_info:MY_LocalizedString(@"lbl_has_saved", nil)];
        _idic_value_copy=[NSMutableDictionary dictionaryWithDictionary:idic_textfield_value];
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
        NSDictionary *idic_cols=_pass_Value(tag);
        NSString *col_field=[idic_cols valueForKey:@"col_field"];
        [idic_textfield_value setObject:str_code forKey:col_field];
        idic_cols=nil;
        self.skstableView.expandableCells=nil;
        [self.skstableView reloadData];
        [self.skstableView fn_expandall];
    };
    [self presentViewController:barCodeVC animated:YES completion:nil];
}
- (void)fn_click_checkBox:(id)sender {
    UIButton *ibtn=(UIButton*)sender;
    NSDictionary *idic_cols=_pass_Value(ibtn.tag);
    NSString *col_field=[idic_cols valueForKey:@"col_field"];
    NSString *is_selected=[idic_textfield_value valueForKey:col_field];
    BOOL selected=[is_selected boolValue];
    ibtn.selected=!ibtn.selected;
    NSString *selected_value=nil;
    if (ibtn.selected) {
        if (selected) {
            selected_value=@"0";
        }else{
            selected_value=@"1";
        }
    }else{
        if (selected) {
            selected_value=@"0";
        }else{
            selected_value=@"1";
        }
    }
    [idic_textfield_value setObject:selected_value forKey:col_field];
    [idic_textfield_value setObject:selected_value  forKey:col_field];
}

- (IBAction)fn_scan_log:(id)sender {
    DB_whs_config *db_whs=[[DB_whs_config alloc]init];
    NSString *unique_id=[_idic_maintform valueForKey:@"unique_id"];
    NSMutableArray *arr_upload_cols=[db_whs fn_get_upload_col_data:unique_id];
    WhsLogs_ViewController *whs_VC=(WhsLogs_ViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"WhsLogs_ViewController"];
    whs_VC.str_upload_type=[_idic_maintform valueForKey:@"UPLOAD_TYPE"];
    whs_VC.alist_cols=arr_upload_cols;
    whs_VC.lang_code=lang_code;
    [self presentViewController:whs_VC animated:YES completion:nil];
}
#pragma mark -show alert
- (void)fn_show_alert_info:(NSString*)str_alert{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str_alert delegate:nil cancelButtonTitle:MY_LocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==[alertView cancelButtonIndex]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSDictionary *idic_cols=_pass_Value(textField.tag);
    NSString *col_field=[idic_cols valueForKey:@"col_field"];
    NSString *col_option=[idic_cols valueForKey:@"col_option"];
    NSString *col_type=[idic_cols valueForKey:@"col_type"];
    if ([col_type isEqualToString:@"choice"]) {
        SelectHistoryDataViewController *selectVC=(SelectHistoryDataViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectHistoryDataViewController"];
        selectVC.flag_type=2;
        dic_options=[self fn_get_options:col_option];
        selectVC.alist_sys_code=[[dic_options allKeys]mutableCopy];
        selectVC.callback_str=^(NSString *str_key){
            NSString *str_value=[dic_options valueForKey:str_key];
            [idic_textfield_value setObject:str_value forKey:col_field];
            str_value=nil;
            self.skstableView.expandableCells=nil;
            [self.skstableView reloadData];
            [self.skstableView fn_expandall];
        };
        PopViewManager *pop_obj=[[PopViewManager alloc]init];
        [pop_obj fn_PopupView:selectVC Size:CGSizeMake(230, 300) uponView:self];
        return NO;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.checkText=(Custom_textField*)textField;
    [self.checkText fn_setLine_color:[UIColor blueColor]];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.checkText fn_setLine_color:[UIColor lightGrayColor]];
    NSDictionary *idic_cols=_pass_Value(textField.tag);
    NSString *col_field=[idic_cols valueForKey:@"col_field"];
    if (textField.text!=nil) {
        [idic_textfield_value setObject:textField.text forKey:col_field];
        [_idic_datas setObject:textField.text forKey:col_field];
    }
    col_field=nil;
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
    __block BarCodeSysDetailViewController * blockSelf=self;
    _pass_Value=^NSDictionary*(NSInteger tag){
        NSInteger i=tag/TEXTFIELD_TAG;
        NSInteger j=tag-i*TEXTFIELD_TAG-1;
        return blockSelf->alist_filter_upload_cols[i][j];
    };
    NSString *col_type=[dic valueForKey:@"col_type"];
    NSInteger is_mandatory=[[dic valueForKey:@"is_mandatory"]integerValue];
    NSString *col_field=[dic valueForKey:@"col_field"];
    NSString *language_type=[self fn_get_col_label_field];
    
    if ([col_type isEqualToString:@"checkbox"]) {
        static NSString *cellIdentifer=@"cell_checkBox";
        UITableViewCell *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIdentifer];
        UILabel *ilb_alert=(UILabel*)[cell.contentView viewWithTag:55];
        ilb_alert.text=[dic valueForKey:language_type];
        
        UIButton *ibtn_select=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
        [ibtn_select addTarget:self action:@selector(fn_click_checkBox:) forControlEvents:UIControlEventTouchUpInside];
        ibtn_select.tag=TEXTFIELD_TAG*indexPath.row+indexPath.subRow;
        NSString *is_selected=[idic_textfield_value valueForKey:col_field];
        if ([is_selected length]==0) {
            is_selected=@"0";
        }
        if ([is_selected isEqualToString:@"0"]) {
            [ibtn_select setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
            [ibtn_select setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        }
        if ([is_selected isEqualToString:@"1"]) {
            [ibtn_select setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            [ibtn_select setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateSelected];
        }
        cell.accessoryView=ibtn_select;
        ibtn_select=nil;
        return cell;
    }
    
    
    static NSString *cellIndentifer=@"Cell_whs_config";
    Cell_advance_search *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifer];
    cell.accessoryView=nil;
    cell.itf_inputdata.tag=TEXTFIELD_TAG*indexPath.row+indexPath.subRow;
    cell.itf_inputdata.delegate=self;

    cell.itf_inputdata.text=[idic_textfield_value valueForKey:col_field];
    cell.flag_enable=0;
    cell.keyboardType=kDefault_keyboard;
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
        cell.itf_inputdata.inputView=nil;
        ibtn_barCode=nil;
    }else if([col_type isEqualToString:@"string"]){
        cell.itf_inputdata.inputView=nil;
    }else if ([col_type isEqualToString:@"date"]){

        cell.itf_inputdata.inputView=idp_picker;
        cell.itf_inputdata.inputAccessoryView=[self fn_create_toolbar];
        cell.itf_inputdata.text=[Conversion_helper fn_DateToStringDate:id_startdate];
       
    }else if ([col_type isEqualToString:@"int"]){
        cell.keyboardType=kNum_keyboard;
    }else if ([col_type isEqualToString:@"numeric"]){
        cell.keyboardType=kDecimal_keyboard;
    }else if ([col_type isEqualToString:@"choice"]){
        cell.itf_inputdata.inputView=nil;
        NSString *str_value=[idic_textfield_value valueForKey:col_field];
        NSString *key=@"";
        for (NSString *str_key in dic_options) {
            NSString *value=[dic_options objectForKey:str_key];
            if ([value isEqualToString:str_value]) {
                key=str_key;
                break;
            }
            value=nil;
        }
        cell.itf_inputdata.text=key;
        key=nil;
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
    NSMutableDictionary *dic=alist_filter_upload_cols[indexPath.row][indexPath.subRow-1];
    NSString *col_type=[dic valueForKey:@"col_type"];
    if ([col_type isEqualToString:@"checkbox"]) {
        return 44;
    }
    return 80;
}

#pragma mark UIDatePick
-(void)fn_create_datePick{
    //初始化UIDatePicker
    idp_picker=[[UIDatePicker alloc]init];
    [idp_picker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:[Conversion_helper fn_get_lang_code]]];
    [idp_picker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    //设置UIDatePicker的显示模式
    [idp_picker setDatePickerMode:UIDatePickerModeDate];
    id_startdate=[idp_picker date];
    //当值发生改变的时候调用的方法
    [idp_picker addTarget:self action:@selector(fn_change_date) forControlEvents:UIControlEventValueChanged];
    
}
-(void)fn_change_date{
    //获得当前UIPickerDate所在的日期
    id_startdate=[idp_picker date];
    
}
#pragma mark create toolbar
-(UIToolbar*)fn_create_toolbar{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(fn_Click_done:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    return toolbar;
}
-(void)fn_Click_done:(id)sender{
    [self.skstableView reloadData];
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
