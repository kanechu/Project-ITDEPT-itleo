//
//  WarehouseHomeViewController.h
//  itleo
//
//  Created by itdept on 14-12-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "Custom_textField.h"
@interface WarehouseHomeViewController : UIViewController<SKSTableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet SKSTableView *skstableview;

@property (weak, nonatomic) IBOutlet UILabel *ilb_so_no;
@property (weak, nonatomic) IBOutlet Custom_textField *itf_so_no;
- (IBAction)fn_search_S_O_NO_data:(id)sender;

- (IBAction)fn_add_load_plan_row:(id)sender;

@end
