//
//  Identifi_bridgeViewController.m
//  itleo
//
//  Created by itdept on 15/4/27.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "Identifi_bridgeViewController.h"
#import "Custom_BtnGraphicMixed.h"
#import "Signature_contrastViewController.h"
@interface Identifi_bridgeViewController ()

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *signature_bridgeLogo;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_next;
@property (weak, nonatomic) IBOutlet UILabel *lbl_isProceed_alert;

@end

@implementation Identifi_bridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fn_set_control_property];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_control_property{
    [_signature_bridgeLogo setTitle:MY_LocalizedString(@"lbl_isProceed_logo", nil) forState:UIControlStateNormal];
    [_signature_bridgeLogo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    
    [_ibtn_cancel setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
    
    _lbl_isProceed_alert.text=MY_LocalizedString(@"lbl_isProceed_alert", nil);
    
    [_ibtn_next setTitle:MY_LocalizedString(@"ibtn_next", nil) forState:UIControlStateNormal];
}
#pragma mark -event action
- (IBAction)fn_hiden_identifi_bridgeVC:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)fn_go_next_page:(id)sender {
    [self performSegueWithIdentifier:@"segue_signatureContrast" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"segue_signatureContrast"]) {
        Signature_contrastViewController *signatureVC=(Signature_contrastViewController*)[segue destinationViewController];
        signatureVC.verifyImage=_client_image;
        signatureVC.dic_order=_dic_order;
    }
    
}


@end
