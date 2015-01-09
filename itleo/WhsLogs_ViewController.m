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
@interface WhsLogs_ViewController ()

@property (nonatomic,strong) NSMutableArray *alist_whs_logs;

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_logo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_cancel;

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
    
    [_ibtn_logo setTitle:MY_LocalizedString(@"lbl_scan_log", nil) forState:UIControlStateNormal];
    [_ibtn_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
}
#pragma mark -event action
- (IBAction)fn_edit_whs_log:(id)sender {
}
- (IBAction)fn_delete_whs_log:(id)sender {
}
- (IBAction)fn_cancel_the_browse:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        str_whs=[str_whs stringByAppendingFormat:@"%@:%@\n",str_col_label,str_value];
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
    NSString *str_log=[self fn_get_whs_data:dic];
    UILabel *ilb_log=(UILabel*)[cell.contentView viewWithTag:55];
    ilb_log.text=str_log;
    ilb_log.layer.borderWidth=1;
    ilb_log.layer.borderColor=[UIColor lightGrayColor].CGColor;
    Cal_lineHeight *cal_obj=[[Cal_lineHeight alloc]init];
    CGFloat height=[cal_obj fn_heightWithString:str_log font:[UIFont systemFontOfSize:17.0] constrainedToWidth:244];
    if (height<100) {
        height=80;
    }
    [ilb_log setFrame:CGRectMake(ilb_log.frame.origin.x, ilb_log.frame.origin.y, ilb_log.frame.size.width,height)];
    
    UIButton *ibtn_edit=(UIButton*)[cell.contentView viewWithTag:35];
    [ibtn_edit setTitle:@"编辑" forState:UIControlStateNormal];
    ibtn_edit.tag=indexPath.row;
    ibtn_edit.layer.borderWidth=1;
    ibtn_edit.layer.borderColor=[UIColor lightGrayColor].CGColor;
    ibtn_edit.layer.cornerRadius=5;
    UIButton *ibtn_delete=(UIButton*)[cell.contentView viewWithTag:45];
    [ibtn_delete setTitle:MY_LocalizedString(@"lbl_delete", nil) forState:UIControlStateNormal];
    ibtn_delete.tag=indexPath.row;
    ibtn_delete.layer.borderWidth=1;
    ibtn_delete.layer.borderColor=[UIColor lightGrayColor].CGColor;
    ibtn_delete.layer.cornerRadius=5;
    return cell;
}
#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=[alist_whs_logs objectAtIndex:indexPath.row];
    NSString *str_log=[self fn_get_whs_data:dic];
    Cal_lineHeight *cal_obj=[[Cal_lineHeight alloc]init];
    CGFloat height=[cal_obj fn_heightWithString:str_log font:[UIFont systemFontOfSize:17.0] constrainedToWidth:244];
    if (height<21) {
        height=21;
    }
    if (height+20<100) {
        return 100;
    }
    return height+20;

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
