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
@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_orderList_logo;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;
@property (weak, nonatomic) IBOutlet UILabel *ilb_orderNo;
@property (weak, nonatomic) IBOutlet Custom_textField *itf_order_num;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *alist_orderObj;
@property (strong, nonatomic) NSMutableArray *alist_orderCells;//存储cell，用于计算高度


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
}

#pragma mark -event action
- (IBAction)fn_goBack_previous_page:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -加载数据
- (void)fn_initData{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"orderList" ofType:@"plist"];
    NSArray *array=[[NSArray alloc]initWithContentsOfFile:path];
    _alist_orderObj=[[NSMutableArray alloc]init];
    _alist_orderCells=[NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        [_alist_orderObj addObject:[Resp_order_list fn_statusWithDictionary:obj]];
        static NSString *cellIdentifer=@"Cell_order_list";
        Cell_order_list *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentifer];
        [_alist_orderCells addObject:cell];
    }];
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
    Resp_order_list *order_obj=_alist_orderObj[indexPath.row];
    cell.order_obj=order_obj;
    return cell;
}
#pragma mark -UITableViewDelegate
//重新设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Cell_order_list * cell = _alist_orderCells[indexPath.row];
    cell.order_obj = _alist_orderObj[indexPath.row];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_order_detail" sender:self];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"segue_order_detail"]) {
        OrderDetailViewController *orderDetailVC=[segue destinationViewController];
        NSIndexPath *indexPath=[self.tableview indexPathForSelectedRow];
        orderDetailVC.orderObj=[_alist_orderObj objectAtIndex:indexPath.row];
    }
}


@end
