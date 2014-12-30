//
//  BarCodeSysHomeViewController.h
//  itleo
//
//  Created by itdept on 14-12-22.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_BtnGraphicMixed.h"
@interface BarCodeSysDetailViewController : UIViewController

@property (copy, nonatomic) NSString *unique_id;
@property (copy, nonatomic) NSString *lang_code;
@property (copy, nonatomic) NSString *logo_title;

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_whs_logo;

- (IBAction)fn_scan_log:(id)sender;

@end
