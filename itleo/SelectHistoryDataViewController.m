//
//  SelectHistoryDataViewController.m
//  itleo
//
//  Created by itdept on 14-8-28.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "SelectHistoryDataViewController.h"
#import "MZFormSheetController.h"
#import "DB_single_field.h"
@interface SelectHistoryDataViewController ()

//用于标识上次选中的行的索引路径
@property (nonatomic,strong)NSIndexPath *lastIndexPath;
@property (copy,nonatomic) NSString *select_summary_type;

@end

@implementation SelectHistoryDataViewController
@synthesize alist_sys_code;
@synthesize lastIndexPath;
@synthesize select_summary_type;
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
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    self.tableview.layer.cornerRadius=1;
    [self fn_set_button_pro];
    if (_flag_type==1) {
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        
        select_summary_type=[userDefault valueForKey:@"chart_summary_type"];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_set_button_pro{
    _ibtn_cancel.layer.cornerRadius=2;
    _ibtn_cancel.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _ibtn_cancel.layer.borderWidth=0.5;
    [_ibtn_cancel setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
    _ilb_title.layer.cornerRadius=2;
    if (_flag_type==1) {
        _ilb_title.text=MY_LocalizedString(@"lbl_set_title", nil);
    }else{
        _ilb_title.text=MY_LocalizedString(@"select_tilte", nil);
    }
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_sys_code count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer=@"UITableViewCell";
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell) {
        cell=[[UITableViewCell alloc]init ];
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }else{
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }
    UILabel *ilb_sys_code=(UILabel*)[cell.contentView viewWithTag:200];
    if (_flag_type==1) {
        NSString *key=[alist_sys_code objectAtIndex:indexPath.row];
        ilb_sys_code.text=[alist_sys_code objectAtIndex:indexPath.row];
        if ([select_summary_type isEqualToString:key]) {
            lastIndexPath=indexPath;
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }else{
        ilb_sys_code.text=[[alist_sys_code objectAtIndex:indexPath.row]valueForKey:_field_name];
    }
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_flag_type==1) {
        NSInteger newRow=[indexPath row];
        if (lastIndexPath==nil) {
            lastIndexPath=indexPath;
        }
        NSInteger oldRow=[lastIndexPath row];
        if (newRow!=oldRow) {
            UITableViewCell *newCell=[tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType=UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell=[tableView cellForRowAtIndexPath:lastIndexPath];
            oldCell.accessoryType=UITableViewCellAccessoryNone;
            lastIndexPath=indexPath;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        select_summary_type=[alist_sys_code objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chart_summary_type" object:select_summary_type];
    }else{
        NSMutableDictionary *sys_code=[alist_sys_code objectAtIndex:indexPath.row];
        if (_callback) {
            _callback(sys_code);
        }
        
    }
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formsheet){}];
}
//Override to support conditional editing of the table view
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //Return NO if you do not want the specified item to be editable.
    if (_flag_type==1) {
        return NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self fn_delete_data_in_DB:[alist_sys_code objectAtIndex:indexPath.row]];
        [alist_sys_code removeObjectAtIndex:indexPath.row];
        //Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(void)fn_delete_data_in_DB:(NSMutableDictionary*)dic{
    DB_single_field *db=[[DB_single_field alloc]init];
    NSString *unique_id=[dic valueForKeyPath:@"unique_id"];
    if ([_field_name isEqualToString:@"vehicle_no"]) {
        [db fn_delete_data:@"vehicle_no" unique:unique_id];
        
    }else if ([_field_name isEqualToString:@"sys_code"]){
        [db fn_delete_data:@"com_sys_code" unique:unique_id];
    }
}
- (IBAction)fn_cancel_select_data:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formsheet){}];
}

@end
