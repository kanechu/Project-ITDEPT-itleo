//
//  WarehouseSearchViewController.h
//  itleo
//
//  Created by itdept on 14-12-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_Button.h"
#import "Custom_textField.h"
@interface WarehouseSearchViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *ilb_so_no;

@property (weak, nonatomic) IBOutlet Custom_textField *itf_so_no;

@property (weak, nonatomic) IBOutlet Custom_Button *ibtn_search;

- (IBAction)fn_search_so_no_info:(id)sender;

- (IBAction)fn_get_soNo_byScanning:(id)sender;

@end
