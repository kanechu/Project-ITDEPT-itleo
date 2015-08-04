//
//  Order_InfoViewController.m
//  itleo
//
//  Created by itdept on 14-10-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Order_InfoViewController.h"
#import "DB_LoginInfo.h"
#import "Web_update_epod.h"
#import "Resp_order_info.h"
#import "Cal_lineHeight.h"
#import "CheckNetWork.h"
#import "CreateFootView.h"
@interface Order_InfoViewController ()

@property (nonatomic, strong)NSMutableArray *arr_order_info;
@property (nonatomic, strong)NSMutableArray *arr_prompt;
@property (nonatomic, strong)Cal_lineHeight *cal_obj;

@end

@implementation Order_InfoViewController
@synthesize cal_obj;

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
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    _ilb_order_title.text=MY_LocalizedString(@"lbl_info_title", nil);
    [_ibtn_back setTitle:MY_LocalizedString(@"lbl_ok", nil) forState:UIControlStateNormal];
    
    cal_obj=[[Cal_lineHeight alloc]init];
    [self fn_get_order_info];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_get_order_info{
    CheckNetWork *obj=[[CheckNetWork alloc]init];
    if ([obj fn_check_isNetworking]) {
        [SVProgressHUD showWithStatus:MY_LocalizedString(@"load_order_alert", nil)];
        DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
        AuthContract *auth=[db fn_get_RequestAuth];
        SearchFormContract *searchform1=[[SearchFormContract alloc]init];
        searchform1.os_column=@"car_no";
        searchform1.os_value=_car_no;
        SearchFormContract *searchform2=[[SearchFormContract alloc]init];
        searchform2.os_column=@"driver_code";
        searchform2.os_value=auth.user_code;
        SearchFormContract *searchform3=[[SearchFormContract alloc]init];
        searchform3.os_column=@"order_no";
        searchform3.os_value=_order_no;
        NSMutableArray *arr_searchform1=[[NSMutableArray alloc]initWithObjects:searchform1,searchform2,searchform3, nil];
        Web_update_epod *web_epod=[[Web_update_epod alloc]init];
        [web_epod fn_get_order_info:arr_searchform1 back_result:^(NSMutableArray* arr_result){
            if ([arr_result count]!=0) {
                [self fn_set_arr_order_info:arr_result];
                [self.tableview reloadData];
            }else{
                [self fn_show_alert:MY_LocalizedString(@"no_order_alert", nil)];
            }
            [SVProgressHUD dismiss];
        }];
    }else{
        [self fn_show_alert:MY_LocalizedString(@"msg_network_fail", nil)];
        self.tableview.scrollEnabled=NO;
    }
}
-(void)fn_set_arr_order_info:(NSMutableArray*)arr_result{
    _arr_order_info=[NSMutableArray array];
    if ([arr_result count]!=0) {
        _arr_prompt=[NSMutableArray arrayWithObjects:MY_LocalizedString(@"lbl_cus", nil),MY_LocalizedString(@"lbl_pick_cus", nil),MY_LocalizedString(@"lbl_pick_addr", nil),MY_LocalizedString(@"lbl_dely_cus", nil),MY_LocalizedString(@"lbl_dely_addr", nil),MY_LocalizedString(@"lbl_dely_app_date", nil),MY_LocalizedString(@"lbl_dely_app_time", nil),MY_LocalizedString(@"lbl_goods", nil),MY_LocalizedString(@"lbl_pkg", nil),MY_LocalizedString(@"lbl_kgs", nil),MY_LocalizedString(@"lbl_cbm", nil), nil];
        
        Resp_order_info *order_info=[arr_result objectAtIndex:0];
        NSDictionary *dic=[NSDictionary dictionaryWithPropertiesOfObject:order_info];
        [_arr_order_info addObject:[dic valueForKey:@"cust_name"]];
        [_arr_order_info addObject:[dic valueForKey:@"pick_cust_name"]];
        [_arr_order_info addObject:[dic valueForKey:@"pick_addr"]];
        [_arr_order_info addObject:[dic valueForKey:@"dely_cust_name"]];
        [_arr_order_info addObject:[dic valueForKey:@"dely_addr"]];
        
        [_arr_order_info addObject:[self fn_get_date_from_millisecond:[dic valueForKey:@"dely_app_date"]]];
        [_arr_order_info addObject:[self fn_get_date_from_millisecond:[dic valueForKey:@"dely_app_time"]]];
        [_arr_order_info addObject:[dic valueForKey:@"item_desc"]];
        [_arr_order_info addObject:[NSString stringWithFormat:@"%@ %@",[dic valueForKey:@"load_pkg"],[dic valueForKey:@"load_pkg_unit"]]];
        [_arr_order_info addObject:[dic valueForKey:@"load_kgs"]];
        [_arr_order_info addObject:[dic valueForKey:@"load_cbm"]];
    }
}

- (IBAction)fn_back_previons_page:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSString*)fn_get_date_from_millisecond:(NSString*)str_date{
    if ([str_date length]==0) {
        return @"";
    }
    NSDate *date=[Conversion_helper fn_dateFromUnixTimestamp:str_date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arr_prompt count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetifier=@"cell_order_info";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndetifier];
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }else{
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }
    
    UILabel *ilb_prompt=(UILabel*)[cell.contentView viewWithTag:100];
    ilb_prompt.text=[_arr_prompt objectAtIndex:indexPath.row];
    UILabel *ilb_content=(UILabel*)[cell.contentView viewWithTag:200];
    if ([_arr_order_info count]!=0) {
        ilb_content.text=[_arr_order_info objectAtIndex:indexPath.row];
    }
    CGFloat height=[cal_obj fn_heightWithString:ilb_content.text font:ilb_content.font constrainedToWidth:ilb_content.frame.size.width];
    if (height<21) {
        height=21;
    }
    [ilb_content setFrame:CGRectMake(ilb_content.frame.origin.x, ilb_content.frame.origin.y, ilb_content.frame.size.width, height)];
    return cell;
    
}
#pragma mark - UITalbleVeiwDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_arr_order_info count]!=0) {
        NSString *info=[_arr_order_info objectAtIndex:indexPath.row];
        CGFloat height=[cal_obj fn_heightWithString:info font:[UIFont systemFontOfSize:15] constrainedToWidth:220.0f];
        if (height<21) {
            height=21;
        }
        return height+23;
    }else{
        return 44;
    }
}

-(void)fn_show_alert:(NSString*)str_alert{
    UIView *bg_view=[CreateFootView fn_create_footView:str_alert];
    [self.tableview setTableFooterView:bg_view];
}


@end
