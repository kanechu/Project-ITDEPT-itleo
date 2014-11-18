//
//  DashboardGrp2ViewController.m
//  itleo
//
//  Created by itdept on 14-11-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DashboardGrp2ViewController.h"
#import "DtlChartViewController.h"
#import "ChartData_handler.h"
#import "Conversion_helper.h"
#import "ChartView_frame.h"
#import "DB_Chart.h"
#define CHART_SPACE 10
#define HEIGHT  300
#define WIDTH   300
@interface DashboardGrp2ViewController ()
@property(nonatomic, strong) DB_Chart *db_chart;
@property(nonatomic, strong) NSMutableArray *alist_DtlResult;
@property(nonatomic, strong) NSMutableDictionary *idic_result;
@end

@implementation DashboardGrp2ViewController
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
    [_iscrollView setContentSize:CGSizeMake(WIDTH, HEIGHT*([alist_DtlResult count]))];
    [self fn_create_chartView];
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
    alist_DtlResult=[Conversion_helper fn_sort_the_array:alist_DtlResult key:@"unique_id"];
}
-(void)fn_create_chartView{
    NSInteger i=0;
  
    for (NSMutableDictionary *dic in alist_DtlResult) {
        NSString *_chart_type=[dic valueForKey:@"chart_type"];
        NSString *unique_id=[dic valueForKey:@"unique_id"];
        NSString *chart_title=@"";
        if ([_language isEqualToString:@"EN"]) {
            chart_title=[dic valueForKey:@"chart_title_en"];
        }
        if ([_language isEqualToString:@"CN"]) {
            chart_title=[dic valueForKey:@"chart_title_cn"];
        }
        ChartView_frame *chartView=[ChartView_frame fn_shareInstance];
        chartView.chart_type=_chart_type;
        chartView.ilb_chartTitle.text=chart_title;
        if ([_chart_type isEqualToString:@"PIE"] || [_chart_type isEqualToString:@"GRID"]) {
            chartView.alist_values=[ChartData_handler fn_get_chartData_value:unique_id type:kChartDataSerieValues];
            chartView.alist_options=[ChartData_handler fn_get_chartData_value:unique_id type:kChartDataYoptions];
            chartView.alist_colors=[ChartData_handler fn_get_chartData_value:unique_id type:kChartDataColors];
        }else{
            chartView.alist_values=[ChartData_handler fn_get_arr_value:unique_id type:kChartDataXvalues];
            chartView.alist_options=[ChartData_handler fn_get_arr_value:unique_id type:kChartDataYoptions];
            chartView.alist_colors=[ChartData_handler fn_get_arr_value:unique_id type:kChartDataColors];
        }
        chartView.alist_remarks=[ChartData_handler fn_get_arr_value:unique_id type:3];
        chartView.frame=CGRectMake(CHART_SPACE, i*HEIGHT, WIDTH, HEIGHT);
        UITapGestureRecognizer *gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_tapped_ChartView:)];
        [chartView addGestureRecognizer:gestureRecognizer];
        [self.iscrollView addSubview:chartView];
        i++;
    }
}
-(void)fn_tapped_ChartView:(UITapGestureRecognizer*)gesture{
    ChartView_frame *chartView=(ChartView_frame*)gesture.view;
    _idic_result=[[NSMutableDictionary alloc]initWithCapacity:1];
    NSArray *alist_options=chartView.alist_options;
    if (alist_options!=nil) {
        [_idic_result setObject:alist_options forKey:@"y"];
    }
    NSArray *alist_remarks=chartView.alist_remarks;
    if (alist_remarks!=nil) {
        [_idic_result setObject:alist_remarks forKey:@"remark"];
    }
    NSString *chart_type=chartView.chart_type;
    if (chart_type!=nil) {
        [_idic_result setObject:chart_type forKey:@"type"];
    }
    NSArray *alist_values=chartView.alist_values;
    if (alist_values!=nil) {
        [_idic_result setObject:alist_values forKey:@"x"];
    }
    NSString *chartTitle=chartView.ilb_chartTitle.text;
    if (chartTitle!=nil) {
        [_idic_result setObject:chartTitle forKey:@"title"];
    }
    NSArray *alist_colors=chartView.alist_colors;
    if (alist_colors!=nil) {
        [_idic_result setObject:alist_colors forKey:@"colors"];
    }
    [self performSegueWithIdentifier:@"grp2_dtl" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    
    DtlChartViewController *dtlVC=(DtlChartViewController*)[segue destinationViewController];
    dtlVC.alist_options=[_idic_result valueForKey:@"y"];
    dtlVC.alist_values=[_idic_result valueForKey:@"x"];
    dtlVC.chart_type=[_idic_result valueForKey:@"type"];
    dtlVC.alist_colors=[_idic_result valueForKey:@"colors"];
    dtlVC.alist_remarks=[_idic_result valueForKey:@"remark"];
    dtlVC.chartTitle=[_idic_result valueForKey:@"title"];
    
    // Pass the selected object to the new view controller.
}

@end
