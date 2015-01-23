//
//  WhsLogs_ViewController.m
//  itleo
//
//  Created by itdept on 15-1-2.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "WhsLogs_ViewController.h"
#import "DB_whs_config.h"
#import "Custom_BtnGraphicMixed.h"
#import "Cal_lineHeight.h"
#import "CreateFootView.h"

@interface WhsLogs_ViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *alist_whs_logs;
@property (nonatomic, assign) NSInteger flag_select_row;

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_logo;

@end

@implementation WhsLogs_ViewController

@synthesize alist_whs_logs;
@synthesize lang_code;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_property{
    DB_whs_config *db_whs=[[DB_whs_config alloc]init];
    alist_whs_logs=[db_whs fn_get_warehouse_log:_str_upload_type];
    db_whs=nil;
    
    [_ibtn_logo setTitle:MY_LocalizedString(@"lbl_scan_log", nil) forState:UIControlStateNormal];
    [_ibtn_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    
    if ([alist_whs_logs count]!=0) {
        self.tableview.tableFooterView=[[UIView alloc]init];
    }else{
        UIView *footView=[CreateFootView fn_create_footView:MY_LocalizedString(@"no_record_alert", nil)];
        self.tableview.tableFooterView=footView;
    }
    
}
#pragma mark -event action

- (IBAction)fn_cancel_the_browse:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*屏蔽 删除、添加
- (void)fn_longPress_event_action:(UILongPressGestureRecognizer*)GestureRecognizer{
    UITableViewCell *cell=(UITableViewCell*)[GestureRecognizer view];
    _flag_select_row=cell.tag;
    if (GestureRecognizer.state==UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_cancel", nil) destructiveButtonTitle:MY_LocalizedString(@"ibtn_delete_all", nil) otherButtonTitles:MY_LocalizedString(@"lbl_delete", nil),MY_LocalizedString(@"lbl_edit", nil), nil];
        [actionSheet showInView:self.view];
    }
}
 
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=[actionSheet cancelButtonIndex]) {
        DB_whs_config *db_whs=[[DB_whs_config alloc]init];
        NSMutableDictionary *dic=[alist_whs_logs objectAtIndex:_flag_select_row];
        NSString *uid=[dic valueForKey:@"unique_id"];
        BOOL ib_deleted=NO;
        if (buttonIndex==[actionSheet destructiveButtonIndex]) {
            ib_deleted=[db_whs fn_delete_partOf_wharehouse_log:_str_upload_type];
            if (ib_deleted) {
                [alist_whs_logs removeAllObjects];
            }
        }else if (buttonIndex==[actionSheet firstOtherButtonIndex]){
            ib_deleted=[db_whs fn_delete_wharehouse_log:uid];
            if (ib_deleted) {
                [alist_whs_logs removeObjectAtIndex:_flag_select_row];
            }
        }else if (buttonIndex==[actionSheet firstOtherButtonIndex]+1){
            [self dismissViewControllerAnimated:YES completion:nil];
            if (_callBack) {
                _callBack(dic);
            }
        }
       
        [self.tableview reloadData];
    }
    
}*/
-(NSString*)fn_get_show_options:(NSMutableDictionary*)dic_cols value:(NSString*)str_value{
    NSString *col_options=[dic_cols valueForKey:@"col_option"];
    NSMutableDictionary *idic_options=[[NSMutableDictionary alloc]init];
    NSArray *arr_options=[col_options componentsSeparatedByString:@","];
    for (NSString *str_option in arr_options) {
        NSArray *arr_subOpitons=[str_option componentsSeparatedByString:@"/"];
        NSString *str_value=[arr_subOpitons objectAtIndex:0];
        NSString *str_key=[arr_subOpitons objectAtIndex:1];
        [idic_options setObject:str_value forKey:str_key];
        arr_subOpitons=nil;
        str_value=nil;
        str_key=nil;
        
    }
    for (NSString *str_key in idic_options) {
        NSString *value=[idic_options valueForKey:str_key];
        if ([value isEqualToString:str_value]) {
            str_value=str_key;
            break;
        }
    }
    return str_value;
}
- (NSString*)fn_get_whs_data:(NSMutableDictionary*)dic{
    NSString *str_whs=@"";
    NSString *str_col_label;
    for (NSMutableDictionary *dic_cols in _alist_cols) {
        NSString *col_field=[dic_cols valueForKey:@"col_field"];
        str_col_label=[dic_cols valueForKey:[self fn_get_col_label_field]];
        if ([col_field isEqualToString:@"order"]) {
            col_field=@"order_no";
        }
        NSString *str_value=[dic valueForKey:col_field];
        NSString *col_type=[dic_cols valueForKey:@"col_type"];
        if ([col_type isEqualToString:@"choice"]) {
            str_value=[self fn_get_show_options:dic_cols value:str_value];
        }
        str_whs=[str_whs stringByAppendingFormat:@"%@:  %@\n",str_col_label,str_value];
        str_value=nil;
        col_field=nil;
    }
    return str_whs;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_whs_logs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=[alist_whs_logs objectAtIndex:indexPath.row];
    static NSString *cellIndentifer=@"cell_whs_log";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    cell.tag=indexPath.row;
   /* 屏蔽此手势操作
    UILongPressGestureRecognizer *gestureRecongnizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(fn_longPress_event_action:)];
    [cell addGestureRecognizer:gestureRecongnizer];*/
    NSString *str_log=[self fn_get_whs_data:dic];
    UILabel *ilb_log=(UILabel*)[cell.contentView viewWithTag:55];
    ilb_log.text=str_log;
    Cal_lineHeight *cal_obj=[[Cal_lineHeight alloc]init];
    CGFloat height=[cal_obj fn_heightWithString:str_log font:ilb_log.font constrainedToWidth:ilb_log.frame.size.width];
    if (height<21) {
        height=21;
    }
    [ilb_log setFrame:CGRectMake(ilb_log.frame.origin.x, ilb_log.frame.origin.y, ilb_log.frame.size.width,height)];
    
    UILabel *ilb_result=(UILabel*)[cell.contentView viewWithTag:65];
    NSString *str_status=[dic valueForKey:@"result_status"];
    if ([str_status isEqualToString:@"1"]) {
        ilb_result.textColor=COLOR_DARK_GREEN1;
    }else{
        ilb_result.textColor=COLOR_DARK_RED;
    }
    NSString *subStr_result=MY_LocalizedString(@"lbl_result", nil);
    NSString *result_message=[dic valueForKey:@"result_message"];
    if ([str_status isEqualToString:@"2"]) {
        result_message=MY_LocalizedString(@"lbl_Network_error", nil);
    }
    NSString *str_result=[NSString stringWithFormat:@"%@:  %@",subStr_result,result_message];
    result_message=nil;
    NSRange range;
    range.location=0;
    range.length=[subStr_result length]+1;
    ilb_result.attributedText=[Conversion_helper fn_different_fontcolor:str_result range:range];
    str_result=nil;
    subStr_result=nil;
    
    
    UILabel *ilb_date=(UILabel*)[cell.contentView viewWithTag:75];
    NSString *str_date=[dic valueForKey:@"excu_datetime"];
    ilb_date.text=[NSString stringWithFormat:@"%@  %@",MY_LocalizedString(@"lbl_date", nil),str_date];
    str_date=nil;
    
    return cell;
}
#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer=@"cell_whs_log";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifer];
    UILabel *ilb_log=(UILabel*)[cell.contentView viewWithTag:55];
    NSMutableDictionary *dic=[alist_whs_logs objectAtIndex:indexPath.row];
    NSString *str_log=[self fn_get_whs_data:dic];
    Cal_lineHeight *cal_obj=[[Cal_lineHeight alloc]init];
    CGFloat height=[cal_obj fn_heightWithString:str_log font:ilb_log.font constrainedToWidth:ilb_log.frame.size.width];
    if (height<21) {
        height=21;
    }
    if (SYSTEM_VERSION_GREATER_THAN_IOS8) {
        return height+42;
    }
    return height+20+42;

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
-(NSString *)fn_get_col_label_field{
    NSString *filed_name=@"";
    if ([lang_code isEqualToString:@"EN"]) {
        filed_name=@"col_label_en";
    }else if ([lang_code isEqualToString:@"CN"]){
        filed_name=@"col_label_cn";
    }else if ([lang_code isEqualToString:@"TCN"]){
        filed_name=@"col_label_tcn";
    }
    return filed_name;
}

@end
