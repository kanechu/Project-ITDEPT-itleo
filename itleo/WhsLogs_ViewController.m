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
@interface WhsLogs_ViewController ()

@property (nonatomic,strong) NSMutableArray *alist_whs_logs;

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_logo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_cancel;

@end

@implementation WhsLogs_ViewController

@synthesize alist_whs_logs;

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
    alist_whs_logs=[db_whs fn_get_warehouse_record:_str_upload_type];
    
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
    [dic removeObjectsForKeys:@[@"unique_id",@"user_code",@"upload_type",@"company_code"]];
    for (NSString *str_key in [dic allKeys]) {
       NSString *str_value=[dic valueForKey:str_key];
        if ([str_value length]!=0) {
            str_whs=[str_whs stringByAppendingFormat:@"%@后一天",str_value];
        }
        str_value=nil;
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
    UITextView *textView=(UITextView*)[cell.contentView viewWithTag:25];
    textView.text=[self fn_get_whs_data:dic];
    textView.layer.borderWidth=1;
    textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ibtn_logo:(id)sender {
}
@end
