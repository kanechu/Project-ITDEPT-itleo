//
//  RangeSelectViewController.m
//  itleo
//
//  Created by itdept on 14-10-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "RangeSelectViewController.h"

@interface RangeSelectViewController ()
//用于标识上次选中的行的索引路径
@property (nonatomic,strong)NSIndexPath *lastIndexPath;
//数据源
@property (nonatomic,strong)NSMutableArray *alist_range_data;

@end

@implementation RangeSelectViewController
@synthesize alist_range_data;
@synthesize lastIndexPath;
@synthesize str_range;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_init_alist_range_data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_init_alist_range_data{
    if (_range_type==kDate_range) {
        alist_range_data=[[NSMutableArray alloc]initWithObjects:@"lbl_day",@"lbl_2days",@"lbl_3days",@"lbl_7days",@"lbl_15days",@"lbl_30days",@"lbl_all",nil];
        self.title=MY_LocalizedString(@"lbl_dateRange_title", nil);
    }else if(_range_type==kOrder_interval_range || _range_type==kWhs_interval_range || _range_type==kGPS_interval_range){
        alist_range_data=[[NSMutableArray alloc]initWithObjects:@"lbl_minute",@"lbl_2minutes",@"lbl_3minutes",@"lbl_5minutes",@"lbl_10minutes",@"lbl_30minutes",@"lbl_hour",nil];
        self.title=MY_LocalizedString(@"lbl_interval_title", nil);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [alist_range_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell_range_data";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *key=[alist_range_data objectAtIndex:indexPath.row];
    cell.textLabel.text=MY_LocalizedString(key, nil);
    if ([str_range isEqualToString:key]) {
        lastIndexPath=indexPath;
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    
    return cell;
}
#pragma mark - Table view Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    str_range=[alist_range_data objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selected_range" object:str_range];
}

@end
