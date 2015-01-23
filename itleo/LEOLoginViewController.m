//
//  LEOLoginViewController.m
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "LEOLoginViewController.h"
#import "Web_base.h"
#import "DB_RespAppConfig.h"
#import "DB_LoginInfo.h"
#import "RespAppConfig.h"
#import "RespLogin.h"
#import "DB_single_field.h"
#import "MZFormSheetController.h"
#import "SelectHistoryDataViewController.h"
#import "PopViewManager.h"
#import "CheckNetWork.h"
#import "Web_get_sypara.h"
#import "Web_get_permit.h"
#import "Web_get_chart_data.h"
#import "Web_whs_config.h"

static NSInteger flag_first=1;//启动
static NSString  *is_language=@"";//标识语言类型
#define DEFAULT_USER_NAME @"anonymous"
#define DEFAULT_PASSWORD @"anonymous1"
#define DEFAULT_SYSTEM @"ITNEW"

@interface LEOLoginViewController ()
@property(nonatomic,strong)UITextField *checkText;
@property(nonatomic,copy)NSString *lang_code;
@property(nonatomic, assign) CGRect keyboardRect;
@end

@implementation LEOLoginViewController
@synthesize checkText;
@synthesize lang_code;
@synthesize keyboardRect;
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
    [self fn_set_controls_property];
    [self fn_show_different_language];
    [self fn_custom_gesture];
    [self fn_registKeyBoardNotification];
    _itf_password.delegate=self;
    _itf_system.delegate=self;
    _itf_usercode.delegate=self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    [self fn_removeKeyBoarNotificaton];
}
//监听键盘隐藏和显示事件
-(void)fn_registKeyBoardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//注销监听事件
-(void)fn_removeKeyBoarNotificaton{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification*)notification {
    
    if (nil == checkText) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect1 = [aValue CGRectValue];
    if (keyboardRect1.size.width!=0) {
        keyboardRect=keyboardRect1;
    }
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
    CGRect textFrame =[checkText convertRect:checkText.bounds toView:self.view];
    
    float textY = textFrame.origin.y + textFrame.size.height;//得到textfield下边框距离顶部的高度
    float bottomY = self.view.frame.size.height - textY;//得到下边框到底部的距离
    
    if(bottomY >=keyboardRect.size.height ){//键盘默认高度,如果大于此高度，则直接返回
        return;
        
    }
    float moveY = keyboardRect.size.height - bottomY+10;
    [self moveInputBarWithKeyboardHeight:moveY withDuration:animationDuration];
    
}
//键盘被隐藏的时候调用的方法
-(void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    
}
#pragma mark 移动view

-(void)moveInputBarWithKeyboardHeight:(float)_CGRectHeight withDuration:(NSTimeInterval)_NSTimeInterval{
    
    CGRect rect = self.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:_NSTimeInterval];
    
    rect.origin.y = -_CGRectHeight;//view往上移动
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

#pragma mark 自定义手势，点击空白处隐藏键盘
-(void)fn_custom_gesture{
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
   // tapgesture.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapgesture];
}
-(void)fn_keyboardHide:(UITapGestureRecognizer*)tap{
    [_itf_password resignFirstResponder];
    [_itf_system resignFirstResponder];
    [_itf_usercode resignFirstResponder];
}
#pragma mark 设置按钮
-(void)fn_set_controls_property{
    _ibtn_login.layer.cornerRadius=2;
    _ibtn_login.layer.borderWidth=0.5;
    _ibtn_login.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [_ibtn_showPassword setImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
    [_ibtn_showPassword setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
    _ibtn_EN.delegate=self;
    _ibtn_CN.delegate=self;
    _ibtn_TCN.delegate=self;
    if (flag_first==1) {
        NSString *current_language=[[MY_LocalizedString getshareInstance]getCurrentLanguage];
        is_language=current_language;
        flag_first++;
    }
    if ([is_language isEqualToString:@"en"]) {
        [_ibtn_EN setChecked:YES];
        lang_code=@"EN";
    }
    if ([is_language isEqualToString:@"zh-Hans"]) {
        [_ibtn_CN setChecked:YES];
        lang_code=@"CN";
    }
    if ([is_language isEqualToString:@"zh-Hant"]) {
        [_ibtn_TCN setChecked:YES];
        lang_code=@"TCN";
    }
    [[MY_LocalizedString getshareInstance]fn_setLanguage_type:is_language];
    _itf_usercode.returnKeyType=UIReturnKeyNext;
    _itf_password.returnKeyType=UIReturnKeyNext;
    _itf_system.returnKeyType=UIReturnKeyDone;

}
#pragma mark -language change
-(void)fn_show_different_language{
    _itf_usercode.placeholder=MY_LocalizedString(@"lbl_username", nil);
    _itf_password.placeholder=MY_LocalizedString(@"lbl_pwd", nil);
    _itf_system.placeholder=MY_LocalizedString(@"lbl_system", nil);
    [_ibtn_login setTitle:MY_LocalizedString(@"lbl_login", nil) forState:UIControlStateNormal];
    [_ibtn_history setTitle:MY_LocalizedString(@"lbl_history", nil) forState:UIControlStateNormal];
    _ilb_showPass.text=MY_LocalizedString(@"lbl_show_pwd", nil);
    _itv_title.text=MY_LocalizedString(@"app_name", nil);
    _itv_title.font=[UIFont systemFontOfSize:24.0f];
    _itv_title.textColor=[UIColor darkGrayColor];
}

#pragma mark 从我们公司的服务器中取客户的数据库
- (void)fn_get_app_config_RespData{
    [SVProgressHUD showWithStatus:MY_LocalizedString(@"login_prompt", nil)];
    RequestContract *req_form=[[RequestContract alloc]init];
    AuthContract *auth=[[AuthContract alloc]init];
    auth.user_code=DEFAULT_USER_NAME;
    auth.password=DEFAULT_PASSWORD;
    auth.system=DEFAULT_SYSTEM;
    auth.version=VERSION;
    auth.com_sys_code=_itf_system.text;//用户输入的
    auth.app_code=APP_CODE;
    req_form.Auth=auth;
    
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_APP_CONFIG_URL;
    web_base.iresp_class=[RespAppConfig class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespAppConfig class]];
    web_base.callBack=^(NSMutableArray *arr_resp_result){
        DB_RespAppConfig *db=[[DB_RespAppConfig alloc]init];
        [db fn_save_RespAppConfig_data:arr_resp_result];
        NSString *web_addr;
        NSString *sys_name;
        if ([arr_resp_result count]!=0) {
            web_addr=[[arr_resp_result objectAtIndex:0]valueForKey:@"web_addr"];
            sys_name=[[arr_resp_result objectAtIndex:0]valueForKey:@"sys_name"];
            
        }
        [self fn_get_login_RespData:web_addr sys_name:sys_name];
    };
    [web_base fn_get_data:req_form base_url:STR_BASE_URL];
}
#pragma mark 验证该用户名是否存在客户的数据库中
- (void)fn_get_login_RespData:(NSString*)web_addr sys_name:(NSString*)sys_name{
    if (web_addr!=nil&&sys_name!=nil) {
        RequestContract *req_form=[[RequestContract alloc]init];
        AuthContract *auth=[[AuthContract alloc]init];
        auth.user_code=_itf_usercode.text;
        auth.password=_itf_password.text;
        auth.system=sys_name;
        auth.version=VERSION;
        auth.encrypted=IS_ENCRYPTED;
        req_form.Auth=auth;
        Web_base *web_base=[[Web_base alloc]init];
        web_base.il_url=STR_LOGIN_URL;
        web_base.iresp_class=[RespLogin class];
        web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespLogin class]];
        web_base.callBack=^(NSMutableArray *arr_resp_result){
            NSString *user_logo=@"";
            NSString *pass=@"";
            if ( [arr_resp_result count]!=0) {
                user_logo=[[arr_resp_result objectAtIndex:0]valueForKey:@"user_logo"];
                pass=[[arr_resp_result objectAtIndex:0]valueForKey:@"pass"];
            }
            if ([pass isEqualToString:@"true"]) {
                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                [userDefaults setInteger:1 forKey:@"isLogin"];
                [userDefaults synchronize];
                DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
                [db fn_save_LoginInfo_data:_itf_usercode.text password:_itf_password.text system:sys_name user_logo:user_logo lang_code:lang_code];
                DB_single_field *db_sys=[[DB_single_field alloc]init];
                [db_sys fn_save_data:@"com_sys_code" table_field:@"sys_code" field_value:_itf_system.text];
                /**
                 *  登录成功后，请求sypara
                 */
                Web_get_sypara *web_obj=[[Web_get_sypara alloc]init];
                [web_obj fn_get_sypara_data:web_addr];
                /**
                 *  登录成功后，请求permit
                 */
                Web_get_permit *web_permit_obj=[[Web_get_permit alloc]init];
                [web_permit_obj fn_get_permit_data:web_addr callBack:^(BOOL isScuccee){
                    if (isScuccee==YES) {
                        if (_refresh) {
                            _refresh();
                        }
                        [self dismissViewControllerAnimated:YES completion:^(){}];
                        [SVProgressHUD dismiss];
                    }
                }];
                [web_permit_obj fn_get_epod_status_data:web_addr];
                Web_whs_config *web_whs=[[Web_whs_config alloc]init];
                [web_whs fn_get_whs_config_data:web_addr];
                web_whs=nil;
                Web_get_chart_data *web_chart=[Web_get_chart_data fn_shareInstance];
                [web_chart fn_get_chart_data:web_addr uid:nil type:kRequestAll];
                web_chart.callBack=^(){
                     [[Web_get_chart_data fn_shareInstance]fn_asyn_get_all_charts];
                };
                              
            }else{
                [self fn_popUp_alert:MY_LocalizedString(@"login_failed_prompt", nil)];
                [SVProgressHUD dismiss];
            }
            
        };
        [web_base fn_get_data:req_form base_url:web_addr ];
    }else{
        [self fn_popUp_alert:MY_LocalizedString(@"login_failed_prompt", nil)];
        [SVProgressHUD dismiss];
    }
}
#pragma mark -Event action
- (IBAction)fn_find_history_input_data:(id)sender {
    DB_single_field *db=[[DB_single_field alloc]init];
    NSMutableArray *alist_sys_code=[db fn_get_data:@"com_sys_code"];
    if ([alist_sys_code count]==0) {
        [self fn_popUp_alert:MY_LocalizedString(@"lbl_prompt_history", nil)];
    }else{
        [self fn_popup_history_listView:alist_sys_code];
    }
}

- (IBAction)fn_login_itleo:(id)sender {
    NSString *str_prompt=@"";
    if ([_itf_usercode.text length]==0) {
        str_prompt=MY_LocalizedString(@"empty_username_prompt", nil);
    }else if([_itf_password.text length]==0){
        str_prompt=MY_LocalizedString(@"empty_pass_prompt", nil);
    }else if ([_itf_system.text length]==0){
        str_prompt=MY_LocalizedString(@"empty_sys_prompt", nil);
    }else{
        CheckNetWork *obj=[[CheckNetWork alloc]init];
        if ([obj fn_isPopUp_alert]==NO) {
            [self fn_get_app_config_RespData];
        }
    }
    if ([str_prompt length]!=0) {
        [self fn_popUp_alert:str_prompt];
    }
}

- (IBAction)fn_userName_textField_DidEndOnExit:(id)sender {
    [self.itf_password becomeFirstResponder];
    [self keyboardWillShow:nil];
}

- (IBAction)fn_pass_textField_DidEndOnExit:(id)sender {
    
    [self.itf_system becomeFirstResponder];
    [self keyboardWillShow:nil];
}

- (IBAction)fn_sys_textField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];//隐藏键盘
}
- (IBAction)fn_isShowPassword:(id)sender {
    _ibtn_showPassword.selected=!_ibtn_showPassword.selected;
    if (_ibtn_showPassword.selected) {
        _itf_password.secureTextEntry=NO;
    }else{
        _itf_password.secureTextEntry=YES;
    }
}
#pragma mark -Pop-up alert
-(void)fn_popUp_alert:(NSString*)str_alert{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:str_alert delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    checkText=textField;
    if (_itf_usercode.editing) {
        _iv_usercode_line.backgroundColor=COLOR_DARK_GREEN;
    }else if(_itf_password.editing){
        _iv_password_line.backgroundColor=COLOR_DARK_GREEN;
    }else if(_itf_system.editing){
        _iv_system_line.backgroundColor=COLOR_DARK_GREEN;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _iv_system_line.backgroundColor=[UIColor lightGrayColor];
    _iv_password_line.backgroundColor=[UIColor lightGrayColor];
    _iv_usercode_line.backgroundColor=[UIColor lightGrayColor];
}
#pragma mark -popup history list
-(void)fn_popup_history_listView:(NSMutableArray*)alist_sys{
    SelectHistoryDataViewController *VC=(SelectHistoryDataViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectHistoryDataViewController"];
    VC.alist_sys_code=alist_sys;
    VC.field_name=@"sys_code";
    VC.callback=^(NSMutableDictionary *com_sys_code){
        _itf_system.text=[com_sys_code valueForKey:@"sys_code"];
    };
    PopViewManager *pop_obj=[[PopViewManager alloc]init];
    [pop_obj fn_PopupView:VC Size:CGSizeMake(230, 300) uponView:self];
}
#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    if ([radio.titleLabel.text isEqualToString:@"English"]) {
        is_language=@"en";
    }
    if ([radio.titleLabel.text isEqualToString:@"简体中文"]) {
        is_language=@"zh-Hans";
    }
    if ([radio.titleLabel.text isEqualToString:@"繁体中文"]) {
        is_language=@"zh-Hant";
    }
    [[MY_LocalizedString getshareInstance]fn_setLanguage_type:is_language];
    [self viewDidLoad];
}

@end
