//
//  LEOLoginViewController.h
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
typedef void (^callBack_refresh)(void);
@interface LEOLoginViewController : UIViewController<UITextFieldDelegate,QRadioButtonDelegate>

@property (strong, nonatomic) callBack_refresh refresh;
@property (weak, nonatomic) IBOutlet UITextView *itv_title;

@property (weak, nonatomic) IBOutlet UITextField *itf_usercode;
@property (weak, nonatomic) IBOutlet UITextField *itf_password;
@property (weak, nonatomic) IBOutlet UITextField *itf_system;
@property (weak, nonatomic) IBOutlet UIView *iv_usercode_line;
@property (weak, nonatomic) IBOutlet UIView *iv_password_line;
@property (weak, nonatomic) IBOutlet UIView *iv_system_line;

@property (weak, nonatomic) IBOutlet UIButton *ibtn_history;

@property (weak, nonatomic) IBOutlet UILabel *ilb_showPass;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_showPassword;

@property (weak, nonatomic) IBOutlet UIButton *ibtn_login;
@property (weak, nonatomic) IBOutlet QRadioButton *ibtn_EN;
@property (weak, nonatomic) IBOutlet QRadioButton *ibtn_CN;
@property (weak, nonatomic) IBOutlet QRadioButton *ibtn_TCN;

- (IBAction)fn_find_history_input_data:(id)sender;
- (IBAction)fn_isShowPassword:(id)sender;
- (IBAction)fn_login_itleo:(id)sender;

- (IBAction)fn_userName_textField_DidEndOnExit:(id)sender;
- (IBAction)fn_pass_textField_DidEndOnExit:(id)sender;
- (IBAction)fn_sys_textField_DidEndOnExit:(id)sender;

@end
