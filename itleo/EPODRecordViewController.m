//
//  EPODRecordViewController.m
//  itleo
//
//  Created by itdept on 14-9-16.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "EPODRecordViewController.h"
#import "Cell_ShowRecords.h"
#import "DB_ePod.h"
#import "Checkbox.h"
#import "Conversion_helper.h"
#import "EPODDetailViewController.h"
#import "CreateFootView.h"
@interface EPODRecordViewController ()
//存储全部记录数据
@property(nonatomic,strong)NSMutableArray *alist_epod;
//存储将要删除的数据
@property(nonatomic,strong)NSMutableDictionary *idic_delete;
//存储全部删除的数据
@property(nonatomic,strong)NSMutableArray *alist_delete;
//标识是否全选
@property(nonatomic,assign)NSInteger flag_isAll;
@end

@implementation EPODRecordViewController
@synthesize alist_epod;
@synthesize idic_delete;
@synthesize flag_isAll;

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
    [self fn_get_record_data];
   
	// Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.tableview setTableFooterView:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -get all records
-(void)fn_get_record_data{
    idic_delete=[[NSMutableDictionary alloc]initWithCapacity:10];
    flag_isAll=0;
    DB_ePod *db=[[DB_ePod alloc]init];
    alist_epod=[db fn_select_all_ePod_data];
    if ([alist_epod count]==0) {
        [self fn_show_alert];
    }
}
#pragma mark -set style
- (void)fn_set_control_pro{
    [_ibtn_record_logo setTitle:MY_LocalizedString(@"lbl_record",nil) forState:UIControlStateNormal];
    [_ibtn_record_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    
    [_ibtn_select setTitle:MY_LocalizedString(@"lbl_select", nil) forState:UIControlStateNormal];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
    _ibtn_OK.layer.cornerRadius=4;
    _ibtn_OK.layer.borderColor=[UIColor blueColor].CGColor;
    _ibtn_OK.layer.borderWidth=1;
    [_ibtn_OK setTitle:MY_LocalizedString(@"lbl_delete", nil) forState:UIControlStateNormal];
    [_ibtn_OK addTarget:self action:@selector(fn_OK:) forControlEvents:UIControlEventTouchUpInside];
    
    _ibtn_back.layer.cornerRadius=4;
    _ibtn_back.layer.borderColor=[UIColor blueColor].CGColor;
    _ibtn_back.layer.borderWidth=1;
    [_ibtn_back setTitle:MY_LocalizedString(@"lbl_back", nil) forState:UIControlStateNormal];
    [_ibtn_back addTarget:self action:@selector(fn_back:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -event action
- (IBAction)fn_select_all_records:(id)sender {
    _ibtn_select.selected=!_ibtn_select.selected;
    if (_ibtn_select.selected) {
        flag_isAll=1;
        _alist_delete=[[NSMutableArray alloc]init];
        [_alist_delete addObjectsFromArray:alist_epod];
    }else{
        /**
         *  取消全选的时候，flag_isAll=0,清空字典和数组中存储的那些即将删除的记录
         */
        flag_isAll=0;
        [_alist_delete removeAllObjects];
        [idic_delete removeAllObjects];
    }
    [self.tableview reloadData];
    
}

-(void)fn_OK:(id)sender{
    if ([self.idic_delete count]==0 && [_alist_delete count]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:MY_LocalizedString(@"delete_prompt", nil) delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:nil message:MY_LocalizedString(@"will_delete_prompt", nil) delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_cancel", nil) otherButtonTitles:MY_LocalizedString(@"lbl_ok", nil), nil];
        [alert1 show];
       
    }
}

-(void)fn_back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if ([_alist_delete count]!=0) {
            for (NSMutableDictionary *ldic_epod  in _alist_delete) {
                NSString *ls_unique_id=[ldic_epod valueForKey:@"unique_id"];
                int unique_id=[ls_unique_id intValue];
                DB_ePod *db=[[DB_ePod alloc]init];
                [db fn_delete_epod_data:unique_id];
                [alist_epod removeObject:ldic_epod];
                
            }
            [_alist_delete removeAllObjects];
            flag_isAll=0;
            _ibtn_select.selected=!_ibtn_select.selected;
            [idic_delete removeAllObjects];
            [_tableview reloadData];
            
        }else{
            NSMutableArray *alist_epod_cody=[alist_epod copy];
            [alist_epod removeObjectsInArray:[self.idic_delete allKeys]];
            [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithArray:[self.idic_delete allValues]] withRowAnimation:UITableViewRowAnimationFade];
            //得到词典中所有的value值
            NSEnumerator *enumeratorValue=[idic_delete objectEnumerator];
            //快速遍历所有的Value值
            for (NSObject *obj in enumeratorValue) {
                NSIndexPath *indexPath=(NSIndexPath*)obj;
                NSMutableDictionary *ldic_epod=[alist_epod_cody objectAtIndex:indexPath.row];
                NSString *ls_unique_id=[ldic_epod valueForKey:@"unique_id"];
                int unique_id=[ls_unique_id intValue];
                DB_ePod *db=[[DB_ePod alloc]init];
                [db fn_delete_epod_data:unique_id];
            }
            
            [self.idic_delete removeAllObjects];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"delete_success" object:nil];
    }
    if ([alist_epod count]==0) {
        [self fn_show_alert];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_epod count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_ShowRecords";
    Cell_ShowRecords *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }else{
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }
    
    NSMutableDictionary *dic=[alist_epod objectAtIndex:indexPath.row];
    cell.ilb_vehicle_no.text=[NSString stringWithFormat:@"%@:  %@",MY_LocalizedString(@"lbl_vehicle_no", nil),[dic valueForKey:@"vehicle_no"]];
    cell.ilb_order_no.text=[NSString stringWithFormat:@"%@:  %@",MY_LocalizedString(@"lbl_order_no", nil),[dic valueForKey:@"order_no"]];
    cell.ilb_status.text=[NSString stringWithFormat:@"%@:  %@",MY_LocalizedString(@"lbl_status_show", nil),[self fn_show_status:[dic valueForKey:@"status"]]];
    
    NSString *is_uploaded=[dic valueForKey:@"is_uploaded"];    NSString *str_date=@"";
    if ([is_uploaded isEqualToString:@"1"]) {
        cell.ilb_result.textColor=COLOR_DARK_GREEN1;
        str_date=[dic valueForKey:@"upload_date"];
    }else{
        cell.ilb_result.textColor=[UIColor redColor];
        str_date=[dic valueForKey:@"error_date"];
    }
    if ([str_date length]!=0) {
        cell.ilb_date.text=[NSString stringWithFormat:@"%@:  %@",MY_LocalizedString(@"lbl_date", nil),[self fn_get_date_from_millisecond:str_date]] ;
    }
    NSString *subresult=MY_LocalizedString(@"lbl_result", nil);
    NSString *result=[NSString stringWithFormat:@"%@:  %@",subresult,[self fn_get_detail_declare:[dic valueForKey:@"result"]]];
    NSRange range;
    range.location=0;
    range.length=[subresult length]+1;
    cell.ilb_result.attributedText=[self fn_different_fontcolor:result range:range];
    cell.ilb_delete.text=[NSString stringWithFormat:@"%@:",MY_LocalizedString(@"lbl_delete", nil)];
    [cell.ibox_Delete addTarget:self action:@selector(fn_checkBoxTapped:forEvent:) forControlEvents:UIControlEventValueChanged];
    if (flag_isAll==1) {
        cell.ibox_Delete.checked=YES;
    }else{
        cell.ibox_Delete.checked=NO;
    }
    return cell;
}
#pragma mark -UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

#pragma mark -Ms conversion date
-(NSString*)fn_get_date_from_millisecond:(NSString*)str_date{
    NSDate *date=[Conversion_helper fn_dateFromUnixTimestamp:str_date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
-(NSString*)fn_get_detail_declare:(NSString*)result{
    NSString *detail_result=result;
    if ([result isEqualToString:@"ION"]) {
        detail_result=MY_LocalizedString(@"lbl_order_error", nil);
    }
    if ([result isEqualToString:@"IVN"]) {
        detail_result=MY_LocalizedString(@"lbl_Vehicle_error", nil);
    }
    if ([result isEqualToString:@"isuccess"]) {
        detail_result=MY_LocalizedString(@"lbl_success", nil);
    }
    if ([result isEqualToString:@"ianomaly"]) {
        detail_result=MY_LocalizedString(@"lbl_Network_error", nil);
    }
    return detail_result;
}
-(NSString*)fn_show_status:(NSString*)status_flag{
    NSString *is_status=status_flag;
    if ([status_flag isEqualToString:@"pod1"]) {
        is_status=MY_LocalizedString(@"lbl_start", nil);
    }else if ([status_flag isEqualToString:@"pod2"]) {
        is_status=MY_LocalizedString(@"lbl_arrive", nil);
    }else if([status_flag isEqualToString:@"pod3"]){
        is_status=MY_LocalizedString(@"lbl_complete", nil);
    }else{
        is_status=status_flag;
    }
    return is_status;
}

#pragma mark 同一个Label显示不同颜色的文字方法
-(NSMutableAttributedString*)fn_different_fontcolor:(NSString*)_str range:(NSRange)_range{
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:_str];
    if (_range.length>0) {
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:_range];
    }
    return str;
}

#pragma mark -checkBox event action
- (void)fn_checkBoxTapped:(id)sender forEvent:(UIEvent*)event
{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableview];
    // Lookup the index path of the cell whose checkbox was modified.
	NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:currentTouchPosition];
	if (indexPath != nil)
	{
        if ([(Checkbox*)sender isChecked]) {
            [idic_delete setObject:indexPath forKey:[alist_epod objectAtIndex:indexPath.row]];
            if (flag_isAll==1) {
                [_alist_delete addObject:[alist_epod objectAtIndex:indexPath.row]];
            }
        }else{
            [idic_delete removeObjectForKey:[alist_epod objectAtIndex:indexPath.row]];
            [_alist_delete removeObject:[alist_epod objectAtIndex:indexPath.row]];
        }
	}
}
#pragma mark -NO Record Alert
-(void)fn_show_alert{
    UIView *bg_view=[CreateFootView fn_create_footView:MY_LocalizedString(@"no_record_alert", nil)];
    [self.tableview setTableFooterView:bg_view];
}
@end
