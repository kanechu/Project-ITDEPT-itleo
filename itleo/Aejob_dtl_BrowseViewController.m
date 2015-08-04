//
//  Aejob_dtl_BrowseViewController.m
//  itleo
//
//  Created by itdept on 14-8-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Aejob_dtl_BrowseViewController.h"
#import "Web_base.h"
#import "RespAejob_dtl_browse.h"
#import "DB_RespAejob_dtl_browse.h"
#import "DB_LoginInfo.h"
#import "DB_RespAppConfig.h"
#import "Cell_aejob_dtl_browse.h"
#import "Cal_lineHeight.h"
#import "CreateFootView.h"
#import "CheckNetWork.h"
@interface Aejob_dtl_BrowseViewController ()

@property (nonatomic, strong) NSMutableArray *alist_aejob_dtl;
@property (nonatomic, strong) Cal_lineHeight *calculate;

@end

@implementation Aejob_dtl_BrowseViewController
@synthesize idic_aejob_browse;
@synthesize alist_aejob_dtl;
@synthesize calculate;
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
    [self fn_set_detail_view];
    [self fn_get_aejob_prepare];
    [self setExtraCellLineHidden];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    calculate=[[Cal_lineHeight alloc]init];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fn_set_detail_view{
    _iv_detailView.il_uld_type.text=[idic_aejob_browse valueForKey:@"uld_type"];
    _iv_detailView.il_uld_no.text=[idic_aejob_browse valueForKey:@"uld_no"];
    _iv_detailView.il_pkg.text=[idic_aejob_browse valueForKey:@"pkg"];
    _iv_detailView.il_kgs.text=[idic_aejob_browse valueForKey:@"kgs"];
    _iv_detailView.il_cbf.text=[idic_aejob_browse valueForKey:@"cbf"];
    NSString *str_flight=[NSString stringWithFormat:@"%@/%@/To:%@",[idic_aejob_browse valueForKey:@"flight_no"],[idic_aejob_browse valueForKey:@"flight_date"],[idic_aejob_browse valueForKey:@"dish_port"]];
    _iv_detailView.il_flight.text=str_flight;
    _iv_detailView.il_airline.text=[idic_aejob_browse valueForKey:@"carr_name"];
    _iv_detailView.il_job_no.text=[idic_aejob_browse valueForKey:@"job_no"];
}
- (void)setExtraCellLineHidden
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableview setTableFooterView:view];
}
#pragma mark 获取aejob 详细信息
-(void)fn_get_aejob_prepare{
    DB_RespAejob_dtl_browse *db_aejob=[[DB_RespAejob_dtl_browse alloc]init];
    [db_aejob fn_delete_aejob_browse_data];
    
    DB_RespAppConfig *db=[[DB_RespAppConfig alloc]init];
    NSString *base_url=[db fn_get_field_content:kWeb_addr];
    CheckNetWork *obj=[[CheckNetWork alloc]init];
    if ([obj fn_isPopUp_alert]==NO) {
        [self fn_get_aejob_dtl_browse_data:base_url];
        [self.tableview setScrollEnabled:YES];
    }else{
        [self.tableview setScrollEnabled:NO];
    }
    db_aejob=nil;
    db=nil;
}
-(void)fn_get_aejob_dtl_browse_data:(NSString*)base_url{
    [SVProgressHUD showWithStatus:@"Loading,please wait!"];
    RequestContract *req_form=[[RequestContract alloc]init];
    DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db fn_get_RequestAuth];
    req_form.Auth=auth;
    SearchFormContract *searchForm=[[SearchFormContract alloc]init];
    searchForm.os_column=@"pallet_id";
    searchForm.os_value=[idic_aejob_browse valueForKey:@"pallet_id"];
    req_form.SearchForm=[NSSet setWithObjects:searchForm, nil];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_AEJOB_DTL_BROWSE_URL;
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespAejob_dtl_browse class]];
    web_base.iresp_class=[RespAejob_dtl_browse class];
    web_base.callBack=^(NSMutableArray* arr_resp_result){
        if ([arr_resp_result count]==0) {
            [self fn_show_alert];
            [self.tableview setScrollEnabled:NO];
        }else{
            [self.tableview setScrollEnabled:YES];
        }
        [SVProgressHUD dismiss];
        DB_RespAejob_dtl_browse *db=[[DB_RespAejob_dtl_browse alloc]init];
        [db fn_save_aejob_dtl_browse_data:arr_resp_result];
        
        alist_aejob_dtl=[db fn_get_aejob_dtl_browse_data];
        db=nil;
        [self.tableview reloadData];
    };
    [web_base fn_get_data:req_form base_url:base_url];
    req_form=nil;
    db=nil;
    web_base=nil;
}
#pragma mark -no data alert
-(void)fn_show_alert{
    UIView *bg_view=[CreateFootView fn_create_footView:@"No HAWB details data!"];
    [self.tableview setTableFooterView:bg_view];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [alist_aejob_dtl count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_aejob_dtl_browse";
    Cell_aejob_dtl_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }else{
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }
    NSMutableDictionary *dic=[alist_aejob_dtl objectAtIndex:indexPath.row];
    cell.il_hawb.text=[NSString stringWithFormat:@"HAWB: %@",[dic valueForKey:@"hbl_no"]];
    cell.il_mawb.text=[NSString stringWithFormat:@"MAWB: %@",[dic valueForKey:@"cbl_no"]];
    cell.il_dish_port.text=[NSString stringWithFormat:@"(To:%@)",[dic valueForKey:@"dest_port"]];
    cell.il_shipper.text=[NSString stringWithFormat:@"Shipper: %@",[dic valueForKey:@"shpr_name"]];
    cell.il_consignee.text=[NSString stringWithFormat:@"Consignee: %@",[dic valueForKey:@"cnee_name"]];
    cell.il_pkg.text=[dic valueForKey:@"pkg"];
    cell.il_kgs.text=[dic valueForKey:@"kgs"];
    cell.il_cbf.text=[dic valueForKey:@"cbf"];
    CGFloat height_shipper=[calculate fn_heightWithString:cell.il_shipper.text font:cell.il_shipper.font constrainedToWidth:cell.il_shipper.frame.size.width];
    if (height_shipper<21) {
        height_shipper=21;
    }
    [cell.il_shipper setFrame:CGRectMake(cell.il_shipper.frame.origin.x, cell.il_shipper.frame.origin.y, cell.il_shipper.frame.size.width, height_shipper)];
    CGFloat height_cnee=[calculate fn_heightWithString:cell.il_consignee.text font:cell.il_consignee.font constrainedToWidth:cell.il_consignee.frame.size.width];
    if (height_cnee<21) {
        height_cnee=21;
    }
    [cell.il_consignee setFrame:CGRectMake(cell.il_consignee.frame.origin.x, cell.il_shipper.frame.origin.y+height_shipper, cell.il_consignee.frame.size.width, height_cnee)];
    return cell;
}
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_aejob_dtl_browse";
    Cell_aejob_dtl_browse *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    NSMutableDictionary *dic=[alist_aejob_dtl objectAtIndex:indexPath.row];
    NSString *str_shipper=[NSString stringWithFormat:@"Shipper: %@",[dic valueForKey:@"shpr_name"]];
    NSString *str_consignee=[NSString stringWithFormat:@"Consignee: %@",[dic valueForKey:@"cnee_name"]];
    CGFloat height_shipper=[calculate fn_heightWithString:str_shipper font:cell.il_shipper.font constrainedToWidth:cell.il_shipper.frame.size.width];
    CGFloat height_cnee=[calculate fn_heightWithString:str_consignee font:cell.il_consignee.font constrainedToWidth:cell.il_consignee.frame.size.width];
    if (height_shipper+height_cnee<42) {
        return 130;
    }else{
        return height_cnee+height_shipper+95;
    }
}

@end
