//
//  DtlChartViewController.m
//  itleo
//
//  Created by itdept on 14-11-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DtlChartViewController.h"
#import "ChartView_frame.h"
#define FULLSCREEN [[UIScreen mainScreen]bounds]
@interface DtlChartViewController ()

@end

@implementation DtlChartViewController

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
    
    ChartView_frame *chartView=[ChartView_frame fn_shareInstance];
    chartView.frame=CGRectMake(FULLSCREEN.origin.x, 64, FULLSCREEN.size.width, FULLSCREEN.size.height-64);
    chartView.alist_options=_alist_options;
    chartView.alist_values=_alist_values;
    chartView.alist_colors=_alist_colors;
    chartView.alist_remarks=_alist_remarks;
    chartView.chart_type=_chart_type;
    chartView.ilb_chartTitle.text=_chartTitle;
    [self.view addSubview:chartView];
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

@end
