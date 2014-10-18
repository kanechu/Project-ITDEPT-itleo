//
//  EPODViewController.h
//  itleo
//
//  Created by itdept on 14-9-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_Button.h"
@interface EPODViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ilb_vehicle_no;

@property (weak, nonatomic) IBOutlet UITextField *itf_bus_no;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_lookUp;

@property (weak, nonatomic) IBOutlet Custom_Button *ibtn_receive;
@property (weak, nonatomic) IBOutlet Custom_Button *ibtn_checkRecord;

@property (weak, nonatomic) IBOutlet UILabel *ilb_transfer;
@property (weak, nonatomic) IBOutlet UISwitch *is_switch;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_showMsg;

- (IBAction)fn_fignature_photograph:(id)sender;
- (IBAction)fn_check_record:(id)sender;

@end
