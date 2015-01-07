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

@property (strong, nonatomic) NSMutableDictionary *idic_maintform;
@property (copy, nonatomic) NSString *lang_code;

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_whs_logo;

- (IBAction)fn_scan_log:(id)sender;

@end
