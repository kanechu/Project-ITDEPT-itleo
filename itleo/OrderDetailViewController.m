//
//  OrderDetailViewController.m
//  itleo
//
//  Created by itdept on 15/4/16.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "EPODDetailViewController.h"
#import "Custom_BtnGraphicMixed.h"
#import "Cell_order_detail_header.h"
#import "Cell_order_detail.h"
#import "Cell_order_detail_list.h"
#import "Resp_order_list.h"
#import "DB_order.h"
#define SECTION_NUM 2
@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *order_detail_logo;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_manage_order;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) NSMutableArray *alist_orderCells;
@property (nonatomic,strong) NSMutableArray *alist_orderListCells;
@property (nonatomic,strong) NSMutableArray *alist_orderObjs;

@end

@implementation OrderDetailViewController

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
    [_order_detail_logo setTitle:MY_LocalizedString(@"lbl_order_detail", nil) forState:UIControlStateNormal];
    [_order_detail_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    [_ibtn_cancel setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
    
    self.tableview.layer.borderWidth=1;
    self.tableview.layer.borderColor=[UIColor blueColor].CGColor;
}
#pragma mark -加载数据
- (void)fn_initData{
    _alist_orderCells=[NSMutableArray array];
    static NSString *cellIdentifer=@"Cell_order_detail";
    Cell_order_detail *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentifer];
    [_alist_orderCells addObject:cell];
    
    NSString *order_uid=[_dic_order valueForKey:@"order_uid"];
    DB_order *db_order_obj=[[DB_order alloc]init];
    _alist_orderListCells=[NSMutableArray array];
    _alist_orderObjs=[db_order_obj fn_get_order_dtl_list_data:order_uid];
    [_alist_orderObjs enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        static NSString *cellIdentifer=@"Cell_order_detail_list";
        Cell_order_detail_list *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentifer];
        [_alist_orderListCells addObject:cell];
    }];
}
#pragma mark -event aciton
- (IBAction)fn_goBack_previous_page:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)fn_manage_order:(id)sender {
   
    [self performSegueWithIdentifier:@"segue_order_manager" sender:self];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SECTION_NUM;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return _alist_orderObjs.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString *cellIdentifer=@"Cell_order_detail";
        Cell_order_detail *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentifer];
        cell.dic_order=_dic_order;
        return cell;
    }
    static NSString *cellIdentifer=@"Cell_order_detail_list";
    Cell_order_detail_list *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentifer];
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }else{
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }
    cell.dic_order_dtl=[_alist_orderObjs objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        Cell_order_detail * cell = _alist_orderCells[indexPath.row];
        cell.dic_order =_dic_order;
        return cell.height;
    }else{
        Cell_order_detail_list *cell=_alist_orderListCells[indexPath.row];
        cell.dic_order_dtl=_alist_orderObjs[indexPath.row];
        return cell.height;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *cellIdentifer=@"Cell_order_detail_header";
    Cell_order_detail_header *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIdentifer];
    if (section==0) {
        cell.imgView_order.image=[UIImage imageNamed:@"ic_order"];
        cell.lbl_order_type.text=MY_LocalizedString(@"lbl_order", nil);
        
        cell.ilb_orderNo.text=_dic_order[@"order_no"];
    }else{
        cell.imgView_order.image=[UIImage imageNamed:@"ic_order"];
        cell.lbl_order_type.text=MY_LocalizedString(@"lbl_order_detail", nil);
        
        cell.ilb_orderNo.text=[NSString stringWithFormat:@"(%@)",@(_alist_orderObjs.count)];
    }
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"segue_order_manager"]) {
        EPODDetailViewController *epodDtlVC=(EPODDetailViewController*)[segue destinationViewController];
        epodDtlVC.flag_isHave_order_list=1;
        epodDtlVC.dic_order=_dic_order;
    }
}


@end
