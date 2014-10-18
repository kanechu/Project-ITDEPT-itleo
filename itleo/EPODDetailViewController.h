//
//  EPODDetailViewController.h
//  itleo
//
//  Created by itdept on 14-9-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
#import "Custom_Button.h"
#import "Custom_BtnGraphicMixed.h"
@interface EPODDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,QRadioButtonDelegate,UITextFieldDelegate>

@property (copy, nonatomic) NSString *vehicle_no;

@property (weak, nonatomic) IBOutlet UILabel *ilb_order_no;
@property (weak, nonatomic) IBOutlet UITextField *itf_order_no;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *ilb_show_picture_nums;

@property (weak, nonatomic) IBOutlet UIButton *ibtn_check_info;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_manage;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_uploading;

- (IBAction)fn_check_info:(id)sender;
- (IBAction)fn_manage_picture:(id)sender;
- (IBAction)fn_uploading_epod:(id)sender;

@end
