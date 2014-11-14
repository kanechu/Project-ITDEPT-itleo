//
//  DashboardGrpViewController.m
//  itleo
//
//  Created by itdept on 14-11-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DashboardGrp1ViewController.h"
#import "DB_Chart.h"
#import "PieChart.h"
#define HEIGHT  200
#define WIDTH   320
@interface DashboardGrp1ViewController ()
@property(nonatomic,strong)DB_Chart *db_chart;
@property(nonatomic,strong)NSMutableArray *alist_DtlResult;
@end

@implementation DashboardGrp1ViewController
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
    NSMutableArray *alist_pie_data;
    for (NSMutableDictionary *dic in alist_DtlResult) {
        NSString *chart_type=[dic valueForKey:@"chart_type"];
        NSString *unique_id=[dic valueForKey:@"unique_id"];
        if ([chart_type isEqualToString:@"PIE"]) {
            alist_pie_data=[db_chart fn_get_data:unique_id];
        }
    }
    
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
