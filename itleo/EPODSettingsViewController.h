//
//  EPODSettingsViewController.h
//  itleo
//
//  Created by itdept on 14-10-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_BtnGraphicMixed.h"

@interface EPODSettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_setting_logo;

@property (weak, nonatomic) IBOutlet UILabel *ilb_search_range;
@property (weak, nonatomic) IBOutlet UILabel *ilb_date_range;

@property (weak, nonatomic) IBOutlet UILabel *ilb_auto_range;
@property (weak, nonatomic) IBOutlet UILabel *ilb_interval;

@property (weak, nonatomic) IBOutlet UILabel *ilb_transfer;
@property (weak, nonatomic) IBOutlet UISwitch *is_switch;

@property (weak, nonatomic) IBOutlet UILabel *ilb_transfer_GPS;
@property (weak, nonatomic) IBOutlet UISwitch *is_switch1;

@property (weak, nonatomic) IBOutlet UILabel *ilb_record_GPS;
@property (weak, nonatomic) IBOutlet UISwitch *is_switch2;

@property (weak, nonatomic) IBOutlet UIButton *ibtn_back;

@end
