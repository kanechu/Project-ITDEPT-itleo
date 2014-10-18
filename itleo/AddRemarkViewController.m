//
//  AddRemarkViewController.m
//  itleo
//
//  Created by itdept on 14-9-26.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "AddRemarkViewController.h"
#import "MZFormSheetController.h"
@interface AddRemarkViewController ()

@end

@implementation AddRemarkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self fn_set_control_pro];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_set_control_pro{
    _ilb_title.text=[NSString stringWithFormat:@"%@:",MY_LocalizedString(@"lbl_text_remark", nil)];
    _itv_input_remark.layer.cornerRadius=5;
    _itv_input_remark.layer.borderWidth=1.5;
    _itv_input_remark.layer.borderColor=[UIColor blueColor].CGColor;
    _itv_input_remark.text=_remarked;
    [_ibtn_OK setTitle:MY_LocalizedString(@"lbl_ok", nil) forState:UIControlStateNormal];
    [_ibtn_cancel setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
}

#pragma mark -event aciton
- (IBAction)fn_click_cancel:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *mzformsheet){}];
}

- (IBAction)fn_click_ok:(id)sender {
    if (_callback) {
        _callback(_itv_input_remark.text);
    }
     [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *mzformsheet){}];
}
@end
