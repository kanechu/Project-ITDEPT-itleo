//
//  DashboardGrpViewController.m
//  itleo
//
//  Created by itdept on 14-11-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DashboardGrp1ViewController.h"
#import "DB_Chart.h"
#import "ChartView_frame.h"
#define CHART_SPACE 10
#define HEIGHT  300
#define WIDTH   300
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
    
    NSArray *alist_values1=@[@"2014-6",@"2013-10",@"2013-8",@"2013-4",@"2012-11",@"2012-10"];
    NSArray *alist_options1=@[@1,@1,@1,@1,@1,@11];
    ChartView_frame *pieChart=[ChartView_frame fn_shareInstance];
    pieChart.frame=CGRectMake(0, CHART_SPACE, WIDTH, HEIGHT);
    pieChart.alist_values=alist_values1;
    pieChart.alist_options=alist_options1;
    pieChart.chart_type=@"PIE";
    pieChart.ilb_chartTitle.text=@"PIE";
    [self.iscrollView addSubview:pieChart];
    
    
    NSArray *alist_values=@[@[@"50",@"150",@"30"],@[@"80",@"70",@"50"],@[@"30",@"100",@"106"],@[@"125",@"145",@"50"],@[@"40",@"106",@"115"]];
    NSArray *alist_options=@[@"香港",@"北京",@"上海",@"广州",@"深圳",@"杭州",@"四川",@"重庆",@"云南",@"海南岛",@"东莞",@"苏州",@"江西"];
    NSArray *arr_color=[[NSArray alloc]initWithObjects:[UIColor blueColor],[UIColor yellowColor],[UIColor greenColor], nil];
    ChartView_frame *barChart=[ChartView_frame fn_shareInstance];
    barChart.alist_values=alist_values;
    barChart.alist_options=alist_options;
    barChart.frame=CGRectMake(0, pieChart.frame.origin.y+pieChart.frame.size.height,WIDTH, HEIGHT);
    barChart.ilb_chartTitle.text=@"Bar";
    barChart.chart_type=@"BAR";
    
    barChart.alist_colors=arr_color;
    barChart.alist_remarks=@[@"income",@"outPUt",@"total"];
    
    [self.iscrollView addSubview:barChart];
    self.iscrollView.contentSize=CGSizeMake(self.iscrollView.frame.size.width,pieChart.frame.size.height+barChart.frame.size.height);
    
    
    //[self fn_get_DtlResult_data];
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
