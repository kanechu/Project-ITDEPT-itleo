//
//  EPODRecordViewController.h
//  itleo
//
//  Created by itdept on 14-9-16.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_BtnGraphicMixed.h"
@interface EPODRecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_record_logo;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_select;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *ibtn_OK;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_back;

- (IBAction)fn_select_all_records:(id)sender;

@end
