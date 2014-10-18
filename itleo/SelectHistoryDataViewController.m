//
//  SelectHistoryDataViewController.m
//  itleo
//
//  Created by itdept on 14-8-28.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "SelectHistoryDataViewController.h"
#import "MZFormSheetController.h"
@interface SelectHistoryDataViewController ()

@end

@implementation SelectHistoryDataViewController
@synthesize alist_sys_code;
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
    _ilb_title.text=MY_LocalizedString(@"select_tilte", nil);
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
    ilb_sys_code.text=[[alist_sys_code objectAtIndex:indexPath.row]valueForKey:_field_name];
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *sys_code=[alist_sys_code objectAtIndex:indexPath.row];
    if (_callback) {
        _callback(sys_code);
    }
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formsheet){}];
}

- (IBAction)fn_cancel_select_data:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formsheet){}];
}
@end
