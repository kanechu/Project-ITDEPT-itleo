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
#import "Cal_lineHeight.h"
#import "Resp_exso.h"
#import "Resp_CTexcfsdimResult.h"
#import "Resp_ExsoBrowseResult.h"

#import "Resp_upd_excfsdim.h"
#import "Resp_uploadTran.h"
@interface WarehouseHomeViewController ()

@property (nonatomic,strong) NSMutableArray *alist_groupAndnum;
@property (nonatomic,strong) Cal_lineHeight *cal_obj;
@property (nonatomic, strong) NSMutableArray *alist_exsoBrowse;
@property (nonatomic, strong) NSMutableArray *alist_cfsdimBrowse;
@end

@implementation WarehouseHomeViewController
@synthesize alist_exsoBrowse;
@synthesize alist_cfsdimBrowse;
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

    [self fn_set_property];
    
    _skstableview.SKSTableViewDelegate=self;
     [_skstableview fn_expandall];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fn_set_property{
    _ilb_so_no.text=MY_LocalizedString(@"lbl_so_no", nil);
    _itf_so_no.text=_str_so_no;
    _cal_obj=[[Cal_lineHeight alloc]init];
    
    NSArray *arr_groupAndnum=@[@{@"name":MY_LocalizedString(@"lbl_general", nil),@"num":@"1"},@{@"name": MY_LocalizedString(@"lbl_booking", nil),@"num":@"1"},@{@"name": MY_LocalizedString(@"lbl_receive", nil),@"num":@"1"}];
    _alist_groupAndnum=[arr_groupAndnum mutableCopy];
    if ([_alist_exso_data count]!=0) {
        Resp_exso *exso_obj=[_alist_exso_data objectAtIndex:0];
        NSSet *set_exsoBrowse=exso_obj.ITLEOExsoBrowseResult;
        NSSet *set_cfsdimBrowse=exso_obj.CTexcfsdimResult;
        alist_exsoBrowse=[[set_exsoBrowse allObjects]mutableCopy];
        alist_cfsdimBrowse=[[set_cfsdimBrowse allObjects]mutableCopy];
        NSString *str_num=[NSString stringWithFormat:@"%d",[set_cfsdimBrowse count]];
        if ([set_cfsdimBrowse count]==0) {
            str_num=@"1";
        }
        [_alist_groupAndnum addObject:@{@"name": MY_LocalizedString(@"lbl_loadPlan", nil),@"num":str_num}];
        exso_obj=nil;
        set_cfsdimBrowse=nil;
        set_exsoBrowse=nil;
        str_num=nil;
    }
}

-(void)fn_update_skstableView{
    
    NSString *str_num=[NSString stringWithFormat:@"%d",[alist_cfsdimBrowse count]];
    if ([alist_cfsdimBrowse count]==0) {
        str_num=@"1";
    }
    NSMutableDictionary *dic=[[_alist_groupAndnum lastObject]mutableCopy];
    [dic setObject:str_num forKey:@"num"];
    [_alist_groupAndnum removeLastObject];
    [_alist_groupAndnum addObject:dic];
    self.skstableview.expandableCells=nil;
    [self.skstableview reloadData];
    [self.skstableview fn_expandall];
    str_num=nil;
    dic=nil;
}
-(Resp_CTexcfsdimResult*)fn_get_cfsdimResult:(NSMutableArray*)alist_result{
    
    Resp_upd_excfsdim *upd_excfsdim=[alist_result objectAtIndex:0];
    Resp_uploadTran *uploadTran_obj=upd_excfsdim.UploadTran;
    NSSet *set_cfsdim=uploadTran_obj.upload_response;
    NSArray *arr_cfsdim=[set_cfsdim allObjects];
    Resp_CTexcfsdimResult *cfsdim_obj=nil;
    if ([arr_cfsdim count]!=0) {
        cfsdim_obj= [arr_cfsdim firstObject];
    }
    upd_excfsdim=nil;
    uploadTran_obj=nil;
    set_cfsdim=nil;
    arr_cfsdim=nil;
    
    return cfsdim_obj;
}
-(void)fn_handle_Operation_data:(NSMutableArray* )alist_result operation:(KWarehouse_Operation)op{
    
    if (op==kWarehouse_del) {
        Resp_CTexcfsdimResult *cfsdim_obj=[self fn_get_cfsdimResult:alist_result];
        NSMutableArray *arr_cfsdimBrowse=[alist_cfsdimBrowse copy];
        for (Resp_CTexcfsdimResult *cfsdimResult in arr_cfsdimBrowse) {
            if ([cfsdimResult.unique_id isEqualToString:cfsdim_obj.unique_id]) {
                [alist_cfsdimBrowse removeObject:cfsdimResult];
            }
        }
        cfsdim_obj=nil;
        arr_cfsdimBrowse=nil;
    }
    
    if (op==kWarehouse_add) {
        [alist_cfsdimBrowse addObject:[self fn_get_cfsdimResult:alist_result]];
    }
    if (op==kWarehouse_edit) {
        Resp_CTexcfsdimResult *cfsdim_obj=[self fn_get_cfsdimResult:alist_result];
        NSMutableArray *arr_cfsdimBrowse=[alist_cfsdimBrowse copy];
        NSInteger i=0;
        for (Resp_CTexcfsdimResult *cfsdimResult in arr_cfsdimBrowse) {
            if ([cfsdimResult.unique_id isEqualToString:cfsdim_obj.unique_id]) {
                [alist_cfsdimBrowse removeObject:cfsdimResult];
                [alist_cfsdimBrowse insertObject:cfsdim_obj atIndex:i];
            }
            i++;
        }
        cfsdim_obj=nil;
        arr_cfsdimBrowse=nil;
    }
    [self fn_update_skstableView];
}

- (IBAction)fn_add_load_plan_row:(id)sender {
    Resp_ExsoBrowseResult *resp_obj=nil;
    if ([alist_exsoBrowse count]!=0) {
        resp_obj=[alist_exsoBrowse objectAtIndex:0];
    }
    Record_LoadPlanViewController *record_VC=(Record_LoadPlanViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Record_LoadPlanViewController"];
    record_VC.flag_isAdd=1;
    record_VC.idic_exsoBrowse=[[NSDictionary dictionaryWithPropertiesOfObject:resp_obj]mutableCopy];
    record_VC.callback=^(NSMutableArray *alist_result,KWarehouse_Operation op){
        if ([alist_result count]!=0) {
            [self fn_handle_Operation_data:alist_result operation:op];
        }
        
    };
    resp_obj=nil;
    [self presentViewController:record_VC animated:YES completion:nil];
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
    cell.backgroundColor=COLOR_DARK_BLUE;
    cell.expandable=YES;
    cell.textLabel.text=[dic valueForKey:@"name"];
    cell.textLabel.textColor=[UIColor whiteColor];
    dic=nil;
    return cell;
}
-(UITableViewCell*)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=nil;
    if ([alist_exsoBrowse count]!=0 && indexPath.row!=3) {
        dic=[alist_exsoBrowse objectAtIndex:indexPath.subRow-1];
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
    str_pkg=nil;
    str_kgs=nil;
    str_cbm=nil;
    str_date=nil;
    str_remark=nil;
    
    if (indexPath.row==0) {
        static NSString *cellIndentifer=@"Cell_S_O_general";
        Cell_S_O_general *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
        if (dic!=nil) {
            cell.ilb_vsl_voy.text=[dic valueForKey:@"vsl_voy_name"];
            cell.ilb_shipper.text=[dic valueForKey:@"shpr_name"];
            cell.ilb_consignee.text=[dic valueForKey:@"cnee_name"];
            cell.ilb_loadPort.text=[NSString stringWithFormat:@"%@(%@)",[dic valueForKey:@"load_name"],[dic valueForKey:@"load_code"]];
            cell.ilb_dishPort.text=[NSString stringWithFormat:@"%@(%@)",[dic valueForKey:@"dish_name"],[dic valueForKey:@"dish_code"]];
            cell.ilb_destination.text=[NSString stringWithFormat:@"%@(%@)",[dic valueForKey:@"dest_name"],[dic valueForKey:@"dest_code"]];
        }
        
        return cell;
    }
    dic=nil;
    
    if (indexPath.row==3) {
        Resp_CTexcfsdimResult *resp_cfsdim=nil;
        if ([alist_cfsdimBrowse count]!=0) {
            resp_cfsdim=[alist_cfsdimBrowse objectAtIndex:indexPath.subRow-1];
        }else{
            static NSString *cell_Indentifer=@"cell_no_record_view";
            UITableViewCell *cell=[self.skstableview dequeueReusableCellWithIdentifier:cell_Indentifer];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_Indentifer];
            }
            UILabel *ilb_alert=(UILabel*)[cell.contentView viewWithTag:88];
            ilb_alert.text=MY_LocalizedString(@"no_record_alert", nil);
            return cell;
        
        }
        static NSString *cellIndentifer=@"Cell_load_plan";
        Cell_load_plan *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
        if ((indexPath.subRow-1)%2==0) {
            cell.backgroundColor=COLOR_LIGHT_GRAY;
        }else{
            cell.backgroundColor=COLOR_LIGHT_BLUE;
        }
        
        NSString *str_rec_kgs=MY_LocalizedString(@"lbl_kgs_per_pkg", nil);
        NSString *str_rec_pkg=MY_LocalizedString(@"lbl_so_pkg", nil);
        NSString *str_rec_cbm=MY_LocalizedString(@"lbl_so_cbm", nil);
        NSString *str_rec_length=MY_LocalizedString(@"lbl_length", nil);
        NSString *str_rec_width=MY_LocalizedString(@"lbl_width", nil);
        NSString *str_rec_height=MY_LocalizedString(@"lbl_height", nil);
        NSString *str_remark=MY_LocalizedString(@"lbl_remark", nil);
        
        cell.ilb_kgs_per_pkg.text=[str_rec_kgs stringByAppendingFormat:@"%@",resp_cfsdim.kgs];
        cell.ilb_pkg.text=[str_rec_pkg stringByAppendingFormat:@"%@",resp_cfsdim.pkg];
        cell.ilb_cbm.text=[str_rec_cbm stringByAppendingFormat:@"%@",resp_cfsdim.cbm];
        cell.ilb_length.text=[str_rec_length stringByAppendingFormat:@"%@",resp_cfsdim.length];
        cell.ilb_width.text=[str_rec_width stringByAppendingFormat:@"%@",resp_cfsdim.width];
        cell.ilb_height.text=[str_rec_height stringByAppendingFormat:@"%@",resp_cfsdim.height];
        cell.ilb_remark.text=[str_remark stringByAppendingFormat:@"%@",resp_cfsdim.remark];
        resp_cfsdim=nil;
        str_rec_kgs=nil;
        str_rec_pkg=nil;
        str_rec_cbm=nil;
        str_rec_length=nil;
        str_rec_width=nil;
        str_rec_height=nil;
        str_remark=nil;
        
        return cell;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        static NSString *cellIndentifer=@"Cell_load_plan";
        Cell_load_plan *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
        Resp_CTexcfsdimResult *resp_cfsdim=nil;
        if ([alist_cfsdimBrowse count]!=0) {
            resp_cfsdim=[alist_cfsdimBrowse objectAtIndex:indexPath.subRow-1];
        }else{
            return 60;
        }
        NSString *str_load_remark=resp_cfsdim.remark;
        CGFloat load_remark_h=[_cal_obj fn_heightWithString:str_load_remark font:cell.ilb_remark.font constrainedToWidth:cell.ilb_remark.frame.size.width];
        if (load_remark_h<21) {
            load_remark_h=21;
        }
        resp_cfsdim=nil;
        str_load_remark=nil;
        cell=nil;
        return 117+load_remark_h;
    }
    NSMutableDictionary *dic=[alist_exsoBrowse objectAtIndex:indexPath.subRow-1];
    if (indexPath.row==0) {
        static NSString *cellIndentifer=@"Cell_S_O_general";
        Cell_S_O_general *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
        NSString *str_vsl_voy=[dic valueForKey:@"vsl_voy_name"];
        CGFloat vsl_height=[_cal_obj fn_heightWithString:str_vsl_voy font:cell.ilb_vsl_voy.font constrainedToWidth:cell.ilb_vsl_voy.frame.size.width];
        if (vsl_height<21) {
            vsl_height=21;
        }
        str_vsl_voy=nil;
        NSString *str_shipper=[dic valueForKey:@"shpr_name"];
        CGFloat shipper_height=[_cal_obj fn_heightWithString:str_shipper font:cell.ilb_shipper.font constrainedToWidth:cell.ilb_shipper.frame.size.width];
        if (shipper_height<21) {
            shipper_height=21;
        }
        str_shipper=nil;
        NSString *str_consignee=[dic valueForKey:@"cnee_name"];
        CGFloat cnee_height=[_cal_obj fn_heightWithString:str_consignee font:cell.ilb_consignee.font constrainedToWidth:cell.ilb_consignee.frame.size.width];
        if (cnee_height<21) {
            cnee_height=21;
        }
        str_consignee=nil;
        NSString *str_loadPort=[NSString stringWithFormat:@"%@(%@)",[dic valueForKey:@"load_name"],[dic valueForKey:@"load_code"]];
        CGFloat loadPort_height=[_cal_obj fn_heightWithString:str_loadPort font:cell.ilb_loadPort.font constrainedToWidth:cell.ilb_loadPort.frame.size.width];
        if (loadPort_height<21) {
            loadPort_height=21;
        }
        str_loadPort=nil;
        NSString *str_dishPort=[NSString stringWithFormat:@"%@(%@)",[dic valueForKey:@"dish_name"],[dic valueForKey:@"dish_code"]];
        CGFloat dishPort_height=[_cal_obj fn_heightWithString:str_dishPort font:cell.ilb_dishPort.font constrainedToWidth:cell.ilb_dishPort.frame.size.width];
        if (dishPort_height<21) {
            dishPort_height=21;
        }
        str_dishPort=nil;
        NSString *str_destination=[NSString stringWithFormat:@"%@(%@)",[dic valueForKey:@"dest_name"],[dic valueForKey:@"dest_code"]];
        CGFloat dest_height=[_cal_obj fn_heightWithString:str_destination font:cell.ilb_destination.font constrainedToWidth:cell.ilb_destination.frame.size.width];
        if (dest_height<21) {
            dest_height=21;
        }
        str_destination=nil;
        cell=nil;
        return vsl_height+shipper_height+cnee_height+loadPort_height+dishPort_height+dest_height+10;
    }
    
    
    static NSString *cellIndentifer=@"Cell_show_totals";
    Cell_show_totals *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
    NSString *str_remark=[dic valueForKey:@"remark"];
    CGFloat remark_heigth=[_cal_obj fn_heightWithString:str_remark font:cell.ilb_remark.font constrainedToWidth:cell.ilb_remark.frame.size.width];
    if (remark_heigth<21) {
        remark_heigth=21;
    }
    str_remark=nil;
    cell=nil;
    dic=nil;
    return 79+remark_heigth;
}
-(void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        NSMutableDictionary *idic_cfsdim=nil;
        if ([alist_cfsdimBrowse count]!=0) {
            idic_cfsdim=[alist_cfsdimBrowse objectAtIndex:indexPath.subRow-1];
        }
        Record_LoadPlanViewController *record_VC=(Record_LoadPlanViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Record_LoadPlanViewController"];
        record_VC.idic_received_log=idic_cfsdim;
        record_VC.callback=^(NSMutableArray *alist_result,KWarehouse_Operation op){
            if ([alist_result count]!=0) {
                [self fn_handle_Operation_data:alist_result operation:op];
            }
        };
        idic_cfsdim=nil;
        if ([alist_cfsdimBrowse count]!=0) {
            [self presentViewController:record_VC animated:YES completion:nil];
        }
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
