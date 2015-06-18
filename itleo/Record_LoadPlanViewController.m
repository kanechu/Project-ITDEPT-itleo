//
//  Record_LoadPlanViewController.m
//  itleo
//
//  Created by itdept on 14-12-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Record_LoadPlanViewController.h"
#import "Cell_advance_search.h"
#import "Warehouse_receive_data.h"
#import "Web_base.h"
#import "DB_LoginInfo.h"
#import "DB_RespAppConfig.h"
#import "Resp_upd_excfsdim.h"

#define TEXTFIELD_TAG 100
typedef NSString* (^passValue)(NSInteger tag);

@interface Record_LoadPlanViewController ()
//存储输入内容的提示
@property (nonatomic,strong) NSArray *alist_prompts;
@property (nonatomic,strong) NSArray *alist_columns;
@property (nonatomic,strong) NSMutableDictionary *idic_load_value;

@property (nonatomic,strong) Custom_textField *checkText;
@property (nonatomic,strong) passValue pass_Value;

@end

@implementation Record_LoadPlanViewController

@synthesize alist_prompts;
@synthesize alist_columns;
@synthesize idic_load_value;
@synthesize checkText;

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
    [self fn_init_arr_or_dic];
    [self fn_set_control_property];
    
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    [self fn_custom_gestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _callback=nil;
    _idic_received_log=nil;
    _idic_exsoBrowse=nil;
    alist_columns=nil;
    alist_prompts=nil;
    idic_load_value=nil;
    checkText=nil;
    _pass_Value=nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_init_arr_or_dic{
    alist_prompts=@[MY_LocalizedString(@"lbl_kgs_per_pkg", nil),MY_LocalizedString(@"lbl_so_pkg", nil),MY_LocalizedString(@"lbl_length", nil),MY_LocalizedString(@"lbl_width", nil),MY_LocalizedString(@"lbl_height", nil),MY_LocalizedString(@"lbl_so_cbm", nil),MY_LocalizedString(@"lbl_remark", nil)];
    alist_columns=@[@"kgs",@"pkg",@"length",@"width",@"height",@"cbm",@"remark"];
    NSArray *alist_load_columns=[NSArray arrayWithPropertiesOfObject:[Warehouse_receive_data class]];
    idic_load_value=[[NSMutableDictionary alloc]init];
    if (_idic_received_log!=nil) {
        for (NSString *str_key in alist_load_columns) {
            NSString *str_value=[_idic_received_log valueForKey:str_key];
            if ([str_value length]!=0) {
                [idic_load_value setObject:str_value forKey:str_key];
            }else{
                [idic_load_value setObject:@"" forKey:str_key];
            }
            str_value=nil;
        }
        
    }else{
        for (NSString *str_key in alist_load_columns) {
            [idic_load_value setObject:@"" forKey:str_key];
        }
        NSArray *alist_keys=@[@"uid",@"so_uid",@"unique_id",@"voided"];
        for (NSString *str_key in alist_keys) {
            NSString *str_value=[_idic_exsoBrowse valueForKey:str_key];
            if (str_value!=nil) {
                [idic_load_value setObject:str_value forKey:str_key];
            }
            str_value=nil;
        }
        alist_keys=nil;
    }
    alist_load_columns=nil;
}
- (void)fn_set_control_property{

    [_ibtn_itleo_logo setTitle:MY_LocalizedString(@"lbl_receive_logo", nil) forState:UIControlStateNormal];
    [_ibtn_itleo_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    [_ibtn_delete setTitle:MY_LocalizedString(@"lbl_delete", nil)];
    if (_flag_isAdd==1) {
        [_ibtn_delete setTitle:@""];
        _ibtn_delete.enabled=NO;
    }
    [self fn_set_button_layer:_ibtn_save];
    [self fn_set_button_layer:_ibtn_clear];
    [self fn_set_button_layer:_ibtn_cancel];
    [_ibtn_save setTitle:MY_LocalizedString(@"ibtn_save", nil) forState:UIControlStateNormal];
    [_ibtn_clear setTitle:MY_LocalizedString(@"ibtn_clear", nil) forState:UIControlStateNormal];
    [_ibtn_cancel setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
}
-(void)fn_set_button_layer:(id)sender{
    UIButton *ibtn=(UIButton*)sender;
    ibtn.layer.cornerRadius=2;
    ibtn.layer.borderWidth=0.5;
    ibtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
}
#pragma mark -custom gesture
-(void)fn_custom_gestureRecognizer{
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_hiden_keyboard:)];
    [self.view addGestureRecognizer:gesture];
}
-(void)fn_hiden_keyboard:(UITapGestureRecognizer*)tap{
    [self.tableview reloadData];
}
#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   
    checkText=(Custom_textField*)textField;
    [checkText fn_setLine_color:[UIColor blueColor]];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [checkText fn_setLine_color:[UIColor lightGrayColor]];
     NSString *os_column_key=_pass_Value(textField.tag);
    if ([textField.text length]!=0) {
        [idic_load_value setObject:textField.text forKey:os_column_key];
    }
    os_column_key=nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=[alertView cancelButtonIndex]) {
        NSNumber *voided_int=[NSNumber numberWithInt:-1];
        [idic_load_value setObject:voided_int forKey:@"voided"];
        [self fn_upload_received_data:kWarehouse_del];
        voided_int=nil;
    }
}
#pragma mark -event action
- (IBAction)fn_delete_data:(id)sender {
    [checkText resignFirstResponder];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:MY_LocalizedString(@"will_delete_prompt", nil) delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_cancel", nil) otherButtonTitles:MY_LocalizedString(@"lbl_delete", nil), nil];
    [alert show];
   
}
- (IBAction)fn_save_data:(id)sender {
    if (_flag_isAdd==1) {
        [idic_load_value setObject:@"1" forKey:@"voided"];
        [idic_load_value setObject:@"#" forKey:@"unique_id"];
        [self fn_upload_received_data:kWarehouse_add];
    }else{
        [idic_load_value setObject:@"1" forKey:@"voided"];
        [self fn_upload_received_data:kWarehouse_edit];
    }

}

- (IBAction)fn_clear_input_data:(id)sender {
    [idic_load_value removeAllObjects];
    [self.tableview reloadData];
}

- (IBAction)fn_cancel_input_data:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_prompts count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer=@"Cell_add_row";
    Cell_advance_search *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifer forIndexPath:indexPath];
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }else{
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }
    if (indexPath.row==[alist_prompts count]-1) {
        cell.itf_inputdata.keyboardType=UIKeyboardTypeDefault;
    }else{
        cell.itf_inputdata.keyboardType=UIKeyboardTypeDecimalPad;
    }
    __block Record_LoadPlanViewController * blockSelf=self;
    _pass_Value=^NSString*(NSInteger tag){
        return blockSelf->alist_columns[tag-TEXTFIELD_TAG];
    };
    cell.il_prompt.text=[alist_prompts objectAtIndex:indexPath.row];
    cell.itf_inputdata.delegate=self;
    cell.itf_inputdata.tag=TEXTFIELD_TAG+indexPath.row;
    NSString *os_column_key=[alist_columns objectAtIndex:indexPath.row];
    cell.itf_inputdata.text=[idic_load_value valueForKey:os_column_key];
    os_column_key=nil;
    return cell;
}
#pragma mark -UITableViewDelegate
#pragma mark -KVC 
//KVC会将字典所有的键值对（key_value)赋值给模型对象的属性。只有当字典的键值对个数跟模型的属性个数相等，并且属性名必须和字典的键值对一样时才可以使用kvc
- (Warehouse_receive_data*)fn_init_receiveDataModel_WithDict:(NSDictionary *)dict{
    Warehouse_receive_data *receive_obj=[[Warehouse_receive_data alloc]init];
    
    [receive_obj setValuesForKeysWithDictionary:dict];
    return receive_obj;
}
#pragma mark -upload data
- (void)fn_upload_received_data:(KWarehouse_Operation)op{
    NSString *str_prompt=nil;
    if (op==kWarehouse_del) {
        str_prompt=MY_LocalizedString(@"lbl_deleting_alert", nil);
    }else{
        str_prompt=MY_LocalizedString(@"lbl_saving_alert", nil);
        
    }
    [SVProgressHUD showWithStatus:str_prompt];
    UploadGPSContract *upload=[[UploadGPSContract alloc]init];
    
    Warehouse_receive_data *receive_obj=[self fn_init_receiveDataModel_WithDict:idic_load_value];
    upload.UpdateForm=[NSSet setWithObject:receive_obj];
    
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    upload.Auth=auth;
    
    Web_base *web_obj=[[Web_base alloc]init];
    web_obj.il_url=STR_UPD_EXCFSDIM_URL;
    web_obj.iresp_class=[Resp_upd_excfsdim class];
    
    NSMutableArray *alist_uploadTran=[[NSArray arrayWithPropertiesOfObject:[Resp_uploadTran class]]mutableCopy];
    [alist_uploadTran removeLastObject];
    web_obj.ilist_resp_mapping1=alist_uploadTran;
    web_obj.iresp_class1=[Resp_uploadTran class];
    
    web_obj.callBack=^(NSMutableArray* arr_resp_result){
        if (_callback) {
            _callback(arr_resp_result,op);
        }
        
        NSString *str_success_alert=nil;
        if (op==kWarehouse_del) {
            str_success_alert=MY_LocalizedString(@"lbl_delete_success", nil);
        }else{
            str_success_alert=MY_LocalizedString(@"lbl_save_success", nil);
        }
        [SVProgressHUD dismissWithSuccess:str_success_alert];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    DB_RespAppConfig *db_obj=[[DB_RespAppConfig alloc]init];
    NSString *str_base_url=[db_obj fn_get_field_content:kWeb_addr];
    [web_obj fn_uploaded_warehouse_receive_data:upload base_url:str_base_url];
    db_obj=nil;
    web_obj=nil;
}

@end
