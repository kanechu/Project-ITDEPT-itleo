//
//  Record_LoadPlanViewController.h
//  itleo
//
//  Created by itdept on 14-12-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_BtnGraphicMixed.h"
@interface Record_LoadPlanViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_itleo_logo;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_delete;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_save;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_clear;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;

- (IBAction)fn_delete_data:(id)sender;
- (IBAction)fn_save_data:(id)sender;
- (IBAction)fn_clear_input_data:(id)sender;
- (IBAction)fn_cancel_input_data:(id)sender;

@end
