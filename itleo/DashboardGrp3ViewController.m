//
//  DashboardGrp3ViewController.m
//  itleo
//
//  Created by itdept on 14-11-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DashboardGrp3ViewController.h"
#import "DB_Chart.h"
@interface DashboardGrp3ViewController ()
@property(nonatomic, strong) DB_Chart *db_chart;
@property(nonatomic, strong) NSMutableArray *alist_DtlResult;
@end

@implementation DashboardGrp3ViewController
@synthesize db_chart;
@synthesize alist_DtlResult;
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
    [self fn_get_DtlResult_data];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_get_DtlResult_data{
    db_chart=[[DB_Chart alloc]init];
    alist_DtlResult=[db_chart fn_get_DashboardDtlResult:_unique_id];
    NSLog(@"%@",alist_DtlResult);
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

@end
