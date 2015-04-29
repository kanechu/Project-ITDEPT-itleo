//
//  OrderListViewController.m
//  itleo
//
//  Created by itdept on 15/4/15.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderDetailViewController.h"
#import "Custom_BtnGraphicMixed.h"
#import "Custom_textField.h"
#import "Resp_order_list.h"
#import "Cell_order_list.h"
#import "DB_order.h"
#import "Web_order_list.h"
@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_orderList_logo;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;
@property (weak, nonatomic) IBOutlet UILabel *ilb_orderNo;
@property (weak, nonatomic) IBOutlet Custom_textField *itf_order_num;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *alist_orderObj;
@property (strong, nonatomic) NSMutableArray *alist_orderCells;//存储cell，用于计算高度
@property (strong, nonatomic) DB_order *db_order_obj;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fn_set_controls_property];
    [self fn_initData];
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fn_set_controls_property{
    [_ibtn_orderList_logo setTitle:MY_LocalizedString(@"ibtn_order_list", nil) forState:UIControlStateNormal];
    [_ibtn_orderList_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    [_ibtn_cancel setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
    _ilb_orderNo.text=MY_LocalizedString(@"lbl_list_order_no", nil);
    _itf_order_num.placeholder=MY_LocalizedString(@"lbl_order_placeholder", nil);
    _itf_order_num.returnKeyType=UIReturnKeySearch;
    _itf_order_num.delegate=self;
    self.tableview.backgroundColor=COLOR_LIGHT_GRAY;
}

#pragma mark -event action
- (IBAction)fn_goBack_previous_page:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -加载数据
- (void)fn_initData{
    self.db_order_obj=[[DB_order alloc]init];
    _alist_orderObj=[self.db_order_obj fn_get_order_list_data];
    _alist_orderCells=[NSMutableArray array];
    [_alist_orderObj enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        static NSString *cellIdentifer=@"Cell_order_list";
        Cell_order_list *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentifer];
        [_alist_orderCells addObject:cell];
    }];
}
#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _alist_orderObj=[self.db_order_obj fn_filter_order_list:textField.text];
    [self.tableview reloadData];
    [_itf_order_num resignFirstResponder];
    return YES;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _alist_orderObj.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifer=@"Cell_order_list";
    Cell_order_list *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentifer];
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }else{
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }
    NSMutableDictionary *dic_order_obj=_alist_orderObj[indexPath.row];
    cell.dic_order=dic_order_obj;
    return cell;
}
#pragma mark -UITableViewDelegate
//重新设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Cell_order_list * cell = _alist_orderCells[indexPath.row];
    cell.dic_order = _alist_orderObj[indexPath.row];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_order_detail" sender:self];
    NSDictionary *dic_order=_alist_orderObj[indexPath.row];
    NSString *isRead=dic_order[@"is_read"];
    
    if ([isRead integerValue]==0) {
        NSString *str_order_uid=dic_order[@"order_uid"];
        NSString *str_read_date=[Conversion_helper fn_Date_ToStringDateTime:[NSDate date]];
        NSString *str_join_uid=[NSString stringWithFormat:@"%@,%@",str_order_uid,str_read_date];
        
        Web_order_list *order_obj=[[Web_order_list alloc]init];
        [order_obj fn_handle_order_list_data:[NSSet setWithObject:str_join_uid] type:kCheck_order_list];
        order_obj=nil;
        
        [self.db_order_obj fn_update_order_isRead:@"1" read_date:str_read_date order_uid:str_order_uid];
        
        str_order_uid=nil;
    }
    
    isRead=nil;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_itf_order_num resignFirstResponder];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"segue_order_detail"]) {
        OrderDetailViewController *orderDetailVC=[segue destinationViewController];
        NSIndexPath *indexPath=[self.tableview indexPathForSelectedRow];
        orderDetailVC.dic_order=[_alist_orderObj objectAtIndex:indexPath.row];
        orderDetailVC.callback=^(){
            _alist_orderObj=[self.db_order_obj fn_get_order_list_data];
        };
    }
}


@end
