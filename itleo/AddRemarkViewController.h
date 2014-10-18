//
//  AddRemarkViewController.h
//  itleo
//
//  Created by itdept on 14-9-26.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBack_remark)(NSString *remark);
@interface AddRemarkViewController : UIViewController

@property (strong,nonatomic)callBack_remark callback;
@property (copy,nonatomic) NSString *remarked;
@property (weak, nonatomic) IBOutlet UILabel *ilb_title;
@property (weak, nonatomic) IBOutlet UITextView *itv_input_remark;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_OK;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;

- (IBAction)fn_click_cancel:(id)sender;
- (IBAction)fn_click_ok:(id)sender;
@end
