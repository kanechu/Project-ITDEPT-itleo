//
//  WarehouseHomeViewController.m
//  itleo
//
//  Created by itdept on 14-12-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "WarehouseHomeViewController.h"
#import "Record_LoadPlanViewController.h"
#import "Cell_S_O_general.h"
#import "Cell_show_totals.h"
#import "Cell_load_plan.h"
#import "SKSTableViewCell.h"
#import "Web_get_exso.h"
#import "Cal_lineHeight.h"
@interface WarehouseHomeViewController ()

@property (nonatomic,strong) NSMutableArray *alist_groupAndnum;
@property (nonatomic,strong) NSMutableArray *alist_resp_data;
@property (nonatomic,strong) Cal_lineHeight *cal_obj;

@end

@implementation WarehouseHomeViewController

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
    NSArray *arr_groupAndnum=@[@{@"name":MY_LocalizedString(@"lbl_general", nil),@"num":@"1"},@{@"name": MY_LocalizedString(@"lbl_booking", nil),@"num":@"1"},@{@"name": MY_LocalizedString(@"lbl_receive", nil),@"num":@"1"},@{@"name":MY_LocalizedString(@"lbl_loadPlan", nil),@"num":@"1"}];
    _alist_groupAndnum=[arr_groupAndnum mutableCopy];
    
    _skstableview.SKSTableViewDelegate=self;
     [_skstableview fn_expandall];
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
    _cal_obj=[[Cal_lineHeight alloc]init];
}

- (IBAction)fn_search_S_O_NO_data:(id)sender {
    [SVProgressHUD showWithStatus:MY_LocalizedString(@"lbl_search_so_alert", nil)];
    Web_get_exso *web_obj=[[Web_get_exso alloc]init];
    [web_obj fn_get_exso_data:_itf_so_no.text];
    web_obj.callBack_exso=^(NSMutableArray *arr_resp_result){
        _alist_resp_data=arr_resp_result;
        [self.skstableview reloadData];
        if ([_alist_resp_data count]!=0) {
            [SVProgressHUD dismiss];
        }else{
            NSString *str_promt=[NSString stringWithFormat:@"%@,%@",_itf_so_no.text,MY_LocalizedString(@"lbl_so_result", nil)];
            [SVProgressHUD dismissWithError:str_promt afterDelay:2.0f];
        }
       
    };
}

- (IBAction)fn_add_load_plan_row:(id)sender {
    Record_LoadPlanViewController *record_VC=(Record_LoadPlanViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Record_LoadPlanViewController"];
    record_VC.flag_isAdd=1;
    [self presentViewController:record_VC animated:YES completion:nil];
}
#pragma mark -UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
     [_itf_so_no fn_setLine_color:[UIColor blueColor]];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
     [_itf_so_no fn_setLine_color:[UIColor lightGrayColor]];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -SKSTableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.alist_groupAndnum count];
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numOfrow=[[self.alist_groupAndnum objectAtIndex:indexPath.row]valueForKey:@"num"];
    return [numOfrow integerValue];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取每组的字典
    NSDictionary *dic=[self.alist_groupAndnum objectAtIndex:indexPath.row];
    static NSString *cellIndentifier=@"SKSTableViewCell";
    SKSTableViewCell *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
       cell=[[SKSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.backgroundColor=COLOR_light_BLUE;
    cell.expandable=YES;
    cell.textLabel.text=[dic valueForKey:@"name"];
    return cell;
}
-(UITableViewCell*)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=nil;
    if ([_alist_resp_data count]!=0) {
        dic=[_alist_resp_data objectAtIndex:indexPath.subRow-1];
    }
    static NSString *cellIndentifer=@"Cell_show_totals";
    Cell_show_totals *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
    NSString *str_pkg=MY_LocalizedString(@"lbl_so_pkg", nil);
    ;
    NSString *str_kgs=MY_LocalizedString(@"lbl_rec_kgs", nil);
    NSString *str_cbm=MY_LocalizedString(@"lbl_so_cbm", nil);
    NSString *str_date=MY_LocalizedString(@"lbl_date", nil);
    NSString *str_remark=MY_LocalizedString(@"lbl_remark", nil);
    if (indexPath.row==1 && dic!=nil) {
        str_pkg=[str_pkg stringByAppendingFormat:@"%@(%@)",[dic valueForKey:@"book_pkg"],[dic valueForKey:@"pkg_unit_code"]];
        
        str_kgs=[str_kgs stringByAppendingFormat:@"%@",[dic valueForKey:@"book_kgs"]];
        str_cbm=[str_cbm stringByAppendingFormat:@"%@",[dic valueForKey:@"book_cbm"]];
        str_date=[str_date stringByAppendingFormat:@"%@",[dic valueForKey:@"booking_date"]];
        str_remark=[str_remark stringByAppendingFormat:@"%@",[dic valueForKey:@"remark"]];
    }
    if (indexPath.row==2 && dic!=nil) {
        str_pkg=[str_pkg stringByAppendingFormat:@"%@(%@)",[dic valueForKey:@"recv_pkg"],[dic valueForKey:@"pkg_unit_code"]];
        str_kgs=[str_kgs stringByAppendingFormat:@"%@",[dic valueForKey:@"recv_kgs"]];
        str_cbm=[str_cbm stringByAppendingFormat:@"%@",[dic valueForKey:@"recv_cbm"]];
        str_date=[str_date stringByAppendingFormat:@"%@",[dic valueForKey:@"received_date"]];
        str_remark=[str_remark stringByAppendingFormat:@"%@",[dic valueForKey:@"remark"]];
    }
    cell.ilb_pkg.text=str_pkg;
    cell.ilb_kgs.text=str_kgs;
    cell.ilb_cbm.text=str_cbm;
    cell.ilb_date.text=str_date;
    cell.ilb_remark.text=str_remark;
    
    if (indexPath.row==0) {
        static NSString *cellIndentifer=@"Cell_S_O_general";
        Cell_S_O_general *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
        cell.ilb_vsl_voy.text=[dic valueForKey:@"vsl_voy_name"];
        cell.ilb_shipper.text=[dic valueForKey:@"shpr_name"];
        cell.ilb_consignee.text=[dic valueForKey:@"cnee_name"];
        cell.ilb_loadPort.text=[dic valueForKey:@"load_name"];
        cell.ilb_dishPort.text=[dic valueForKey:@"dish_name"];
        cell.ilb_destination.text=[dic valueForKey:@"dest_name"];
        return cell;
    }
    if (indexPath.row==3) {
        static NSString *cellIndentifer=@"Cell_load_plan";
        Cell_load_plan *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
        NSString *str_rec_kgs=MY_LocalizedString(@"lbl_kgs_per_pkg", nil);
        NSString *str_rec_pkg=MY_LocalizedString(@"lbl_so_pkg", nil);
        NSString *str_rec_cbm=MY_LocalizedString(@"lbl_so_cbm", nil);
        NSString *str_rec_length=MY_LocalizedString(@"lbl_length", nil);
        NSString *str_rec_width=MY_LocalizedString(@"lbl_width", nil);
        NSString *str_rec_height=MY_LocalizedString(@"lbl_height", nil);
        NSString *str_remark=MY_LocalizedString(@"lbl_remark", nil);
        
        cell.ilb_kgs_per_pkg.text=str_rec_kgs;
        cell.ilb_pkg.text=str_rec_pkg;
        cell.ilb_cbm.text=str_rec_cbm;
        cell.ilb_length.text=str_rec_length;
        cell.ilb_width.text=str_rec_width;
        cell.ilb_height.text=str_rec_height;
        cell.ilb_remark.text=str_remark;
        return cell;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        NSMutableDictionary *dic=[_alist_resp_data objectAtIndex:indexPath.subRow-1];
        static NSString *cellIndentifer=@"Cell_S_O_general";
        Cell_S_O_general *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
        NSString *str_vsl_voy=[dic valueForKey:@"vsl_voy_name"];
        CGFloat vsl_height=[_cal_obj fn_heightWithString:str_vsl_voy font:cell.ilb_vsl_voy.font constrainedToWidth:cell.ilb_vsl_voy.frame.size.width];
        if (vsl_height<21) {
            vsl_height=21;
        }
        NSString *str_shipper=[dic valueForKey:@"shpr_name"];
        CGFloat shipper_height=[_cal_obj fn_heightWithString:str_shipper font:cell.ilb_shipper.font constrainedToWidth:cell.ilb_shipper.frame.size.width];
        if (shipper_height<21) {
            shipper_height=21;
        }
        NSString *str_consignee=[dic valueForKey:@"cnee_name"];
        CGFloat cnee_height=[_cal_obj fn_heightWithString:str_consignee font:cell.ilb_consignee.font constrainedToWidth:cell.ilb_consignee.frame.size.width];
        if (cnee_height<21) {
            cnee_height=21;
        }
        NSString *str_loadPort=[dic valueForKey:@"load_code"];
        CGFloat loadPort_height=[_cal_obj fn_heightWithString:str_loadPort font:cell.ilb_loadPort.font constrainedToWidth:cell.ilb_loadPort.frame.size.width];
        if (loadPort_height<21) {
            loadPort_height=21;
        }
        NSString *str_dishPort=[dic valueForKey:@"dish_code"];
        CGFloat dishPort_height=[_cal_obj fn_heightWithString:str_dishPort font:cell.ilb_dishPort.font constrainedToWidth:cell.ilb_dishPort.frame.size.width];
        if (dishPort_height<21) {
            dishPort_height=21;
        }
        NSString *str_destination=[dic valueForKey:@"dest_code"];
        CGFloat dest_height=[_cal_obj fn_heightWithString:str_destination font:cell.ilb_destination.font constrainedToWidth:cell.ilb_destination.frame.size.width];
        if (dest_height<21) {
            dest_height=21;
        }
        return vsl_height+shipper_height+cnee_height+loadPort_height+dishPort_height+dest_height+10;
    }
    if (indexPath.row==3) {
        static NSString *cellIndentifer=@"Cell_load_plan";
        Cell_load_plan *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
        NSString *str_load_remark=@"";
        CGFloat load_remark_h=[_cal_obj fn_heightWithString:str_load_remark font:cell.ilb_remark.font constrainedToWidth:cell.ilb_remark.frame.size.height];
        if (load_remark_h<21) {
            load_remark_h=21;
        }
        return 117+load_remark_h;
    }
    static NSString *cellIndentifer=@"Cell_show_totals";
    Cell_show_totals *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
     NSMutableDictionary *idic=[_alist_resp_data objectAtIndex:indexPath.subRow-1];
    NSString *str_remark=[idic valueForKey:@"remark"];
    CGFloat remark_heigth=[_cal_obj fn_heightWithString:str_remark font:cell.ilb_remark.font constrainedToWidth:cell.ilb_remark.frame.size.width];
    if (remark_heigth<21) {
        remark_heigth=21;
    }
    return 79+remark_heigth;
}
-(void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        Record_LoadPlanViewController *record_VC=(Record_LoadPlanViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Record_LoadPlanViewController"];
        [self presentViewController:record_VC animated:YES completion:nil];
    }
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
