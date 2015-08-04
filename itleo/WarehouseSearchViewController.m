//
//  WarehouseSearchViewController.m
//  itleo
//
//  Created by itdept on 14-12-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "WarehouseSearchViewController.h"
#import "WarehouseHomeViewController.h"
#import "BarCodeViewController.h"
#import "Web_get_exso.h"
#import "CheckNetWork.h"
@interface WarehouseSearchViewController ()

@property (nonatomic, strong) NSMutableArray *alist_resp_exso;

@end

@implementation WarehouseSearchViewController

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
-(void)fn_set_control_pro{
    _ilb_so_no.text=MY_LocalizedString(@"lbl_so_no", nil);
    _itf_so_no.delegate=self;
    _itf_so_no.returnKeyType=UIReturnKeyDone;
    
    _ibtn_search.left_icon=[UIImage imageNamed:@"ibtn_search"];
    [_ibtn_search setTitle:MY_LocalizedString(@"ibtn_search", nil) forState:UIControlStateNormal];
    _ibtn_search.backgroundColor=COLOR_light_BLUE;
    _ibtn_search.layer.backgroundColor=[UIColor lightGrayColor].CGColor;
    
    _ibtn_barCode.layer.cornerRadius=7;
    _ibtn_barCode.layer.borderColor=COLOR_light_BLUE.CGColor;
    _ibtn_barCode.layer.borderWidth=1.5;
}
#pragma mark -UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_itf_so_no fn_setLine_color:[UIColor blueColor]];
    _ibtn_search.layer.backgroundColor=COLOR_light_BLUE.CGColor;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_itf_so_no fn_setLine_color:[UIColor lightGrayColor]];
    if ([textField.text length]!=0) {
        _ibtn_search.enabled=YES;
        _ibtn_search.layer.backgroundColor=COLOR_light_BLUE.CGColor;
    }else{
        _ibtn_search.enabled=NO;
        _ibtn_search.layer.backgroundColor=[UIColor lightGrayColor].CGColor;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -event action

- (IBAction)fn_search_so_no_info:(id)sender {
    CheckNetWork *checkNet_obj=[[CheckNetWork alloc]init];
    if ([checkNet_obj fn_isPopUp_alert]==NO) {
        [SVProgressHUD showWithStatus:MY_LocalizedString(@"lbl_search_so_alert", nil)];
        Web_get_exso *web_obj=[[Web_get_exso alloc]init];
        [web_obj fn_get_exso_data:_itf_so_no.text];
        web_obj.callBack_exso=^(NSMutableArray *arr_resp_result){
            _alist_resp_exso=arr_resp_result;
            if ([arr_resp_result count]!=0) {
                [SVProgressHUD dismiss];
                [self performSegueWithIdentifier:@"segue_warehouseHome" sender:self];
            }else{
                NSString *str_promt=[NSString stringWithFormat:@"%@,%@",_itf_so_no.text,MY_LocalizedString(@"lbl_so_result", nil)];
                [SVProgressHUD dismissWithError:str_promt afterDelay:2.0f];
                str_promt=nil;
            }
            
        };
        web_obj=nil;
        
    }
    checkNet_obj=nil;
}

- (IBAction)fn_get_soNo_byScanning:(id)sender {
    BarCodeViewController *barCodeVC=(BarCodeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BarCodeViewController"];
    barCodeVC.callback=^(NSString *str_result){
        _itf_so_no.text=str_result;
    };
    [self presentViewController:barCodeVC animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WarehouseHomeViewController *VC=(WarehouseHomeViewController*)[segue destinationViewController];
    VC.str_so_no=_itf_so_no.text;
    VC.alist_exso_data=_alist_resp_exso;
    
}

@end
