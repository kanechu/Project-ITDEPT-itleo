//
//  Signature_contrastViewController.m
//  itleo
//
//  Created by itdept on 15/4/27.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "Signature_contrastViewController.h"
#import "Custom_BtnGraphicMixed.h"

#define SECTION_NUM 2

@interface Signature_contrastViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *signature_contrastLogo;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_confirm;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_reject;

@end

@implementation Signature_contrastViewController

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
    NSString *str_logo=[NSString stringWithFormat:@"%@ - %@",MY_LocalizedString(@"lbl_signature_logo", nil),[_dic_order valueForKey:@"order_no"]];
    [_signature_contrastLogo setTitle:str_logo forState:UIControlStateNormal];
    [_signature_contrastLogo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    [_ibtn_confirm setTitle:MY_LocalizedString(@"ibtn_confirm", nil) forState:UIControlStateNormal];
    [_ibtn_reject setTitle:MY_LocalizedString(@"ibtn_reject", nil) forState:UIControlStateNormal];
    
    self.tableview.layer.borderWidth=1.5;
    self.tableview.layer.borderColor=COLOR_light_BLUE.CGColor;
    
}
#pragma mark -event action

- (IBAction)fn_confirm_signature:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"confirm_signature" object:_verifyImage userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)fn_reject_confirm_signature:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SECTION_NUM;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"cell_signature_confirm";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    UIImageView *imageView=(UIImageView*)[cell.contentView viewWithTag:101];
    if (indexPath.section==0) {
        NSString *str_image_base64=[_dic_order valueForKey:@"sign_path_base64"];
        imageView.image=[Conversion_helper fn_base64Str_convert_image:str_image_base64];
    }else{
        imageView.image=_verifyImage;
    }
  
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]init];
    headerView.frame=CGRectMake(0, 0, self.tableview.frame.size.width,35);
    headerView.backgroundColor=COLOR_DARK_BLUE;
    
    UILabel *lbl_header=[[UILabel alloc]init];
    lbl_header.frame=CGRectMake(10,5,headerView.frame.size.width, 21);
    lbl_header.backgroundColor=[UIColor clearColor];
    lbl_header.font=[UIFont systemFontOfSize:17.0];
    lbl_header.textColor=[UIColor whiteColor];
    [headerView addSubview:lbl_header];
    if (section==0) {
        lbl_header.text=MY_LocalizedString(@"lbl_original_signature", nil);
    }if (section==1) {
        lbl_header.text=MY_LocalizedString(@"lbl_Client_signature", nil);
    }
    return headerView;

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
