//
//  EPODSettingsViewController.m
//  itleo
//
//  Created by itdept on 14-10-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "EPODSettingsViewController.h"

@interface EPODSettingsViewController ()

@end

@implementation EPODSettingsViewController

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
    [super viewDidLoad];
    [self fn_set_control_pro];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_control_pro{
    [_ibtn_setting_logo setTitle:MY_LocalizedString(@"ibtn_settings",nil) forState:UIControlStateNormal];
    [_ibtn_setting_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    
    _ibtn_save.layer.cornerRadius=4;
    _ibtn_save.layer.borderColor=[UIColor blueColor].CGColor;
    _ibtn_save.layer.borderWidth=1;
    [_ibtn_save setTitle:MY_LocalizedString(@"ibtn_settings", nil) forState:UIControlStateNormal];
    [_ibtn_save addTarget:self action:@selector(fn_save_settings:) forControlEvents:UIControlEventTouchUpInside];
    
    _ibtn_back.layer.cornerRadius=4;
    _ibtn_back.layer.borderColor=[UIColor blueColor].CGColor;
    _ibtn_back.layer.borderWidth=1;
    [_ibtn_back setTitle:MY_LocalizedString(@"lbl_back", nil) forState:UIControlStateNormal];
    [_ibtn_back addTarget:self action:@selector(fn_back_previous_page:)  forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark -event action
-(void)fn_save_settings:(id)sender{
    
}
-(void)fn_back_previous_page:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
