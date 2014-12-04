//
//  WarehouseHomeViewController.m
//  itleo
//
//  Created by itdept on 14-12-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "WarehouseHomeViewController.h"
#import "Record_LoadPlanViewController.h"
#import "Cell_S_O_general.h"
#import "Cell_show_totals.h"
#import "Cell_load_plan.h"
#import "SKSTableViewCell.h"

@interface WarehouseHomeViewController ()

@property (nonatomic,strong) NSMutableArray *alist_groupAndnum;
@property (nonatomic,strong) NSMutableArray *alist_filtered_data;

@end

@implementation WarehouseHomeViewController

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
    _skstableview.SKSTableViewDelegate=self;
    _alist_groupAndnum=[@[@{@"name": @"General",@"num":@"1"},@{@"name": @"Booking",@"num":@"1"},@{@"name": @"Received",@"num":@"1"},@{@"name": @"Load Plan/Container",@"num":@"1"}]mutableCopy];
    
     [_skstableview fn_expandall];
    _itf_so_no.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)fn_search_S_O_NO_data:(id)sender {
}

- (IBAction)fn_add_load_plan_row:(id)sender {
    Record_LoadPlanViewController *record_VC=(Record_LoadPlanViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Record_LoadPlanViewController"];
    [self presentViewController:record_VC animated:YES completion:nil];
}
#pragma mark -UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
     [_itf_so_no fn_setLine_color:[UIColor blueColor]];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
     [_itf_so_no fn_setLine_color:[UIColor lightGrayColor]];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -SKSTableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.alist_groupAndnum count];
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numOfrow=[[self.alist_groupAndnum objectAtIndex:indexPath.row]valueForKey:@"num"];
    return [numOfrow integerValue];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取每组的字典
    NSDictionary *dic=[self.alist_groupAndnum objectAtIndex:indexPath.row];
    static NSString *cellIndentifier=@"SKSTableViewCell";
    SKSTableViewCell *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
       cell=[[SKSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
         //cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifier];
    }
    cell.backgroundColor=[UIColor grayColor];
    cell.expandable=YES;
    cell.textLabel.text=[dic valueForKey:@"name"];
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}
-(UITableViewCell*)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifer=@"Cell_show_totals";
    Cell_show_totals *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
    cell.ilb_pkg.text=@"PKG:xxxxxx";
    cell.ilb_kgs.text=@"KGS:xxxxxx";
    cell.ilb_cbm.text=@"CBM:xxxxxx";
    cell.ilb_date.text=@"Date:xxxx-xx-xx";
    if (indexPath.row==0) {
        static NSString *cellIndentifer=@"Cell_S_O_general";
        Cell_S_O_general *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
        cell.ilb_vsl_voy.text=@"xxxxxxxxxx";
        cell.ilb_shipper.text=@"xxxxxxxxxx";
        cell.ilb_consignee.text=@"xxxxxxxxxx";
        cell.ilb_loadPort.text=@"xxxxxxxxxx";
        cell.ilb_dishPort.text=@"xxxxxxxxxx";
        cell.ilb_destination.text=@"xxxxxxxxxx";
        return cell;
    }
    if (indexPath.row==3) {
        static NSString *cellIndentifer=@"Cell_load_plan";
        Cell_load_plan *cell=[self.skstableview dequeueReusableCellWithIdentifier:cellIndentifer];
        cell.ilb_kgs_per_pkg.text=@"KGS per PKG:xxx";
        cell.ilb_pkg.text=@"PKG:xxx";
        cell.ilb_cbm.text=@"CBM:xxx";
        cell.ilb_length.text=@"Length(cm):xxx";
        cell.ilb_width.text=@"Width(cm):xxx";
        cell.ilb_height.text=@"Height(cm):xxx";
        cell.ilb_remark.text=@"Hello,nice to meet you!";
        return cell;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 140;
    }
    if (indexPath.row==3) {
        return 100;
    }
    return 60;
}
-(void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3) {
        Record_LoadPlanViewController *record_VC=(Record_LoadPlanViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Record_LoadPlanViewController"];
        [self presentViewController:record_VC animated:YES completion:nil];
    }
}

@end
