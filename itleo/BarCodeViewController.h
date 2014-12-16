//
//  BarCodeViewController.h
//  itleo
//
//  Created by itdept on 14-12-15.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef void (^callBack_value)(NSString *);

@interface BarCodeViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) callBack_value callback;

@property (weak, nonatomic) IBOutlet UILabel *ilb_alert_title;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_pickBg;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;
- (IBAction)fn_cancel_scanning:(id)sender;

@end
