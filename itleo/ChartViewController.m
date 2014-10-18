//
//  ChartViewController.m
//  itleo
//
//  Created by itdept on 14-9-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "ChartViewController.h"
#import "TWRChart.h"
@interface ChartViewController ()
@property(strong, nonatomic) TWRChartView *chartView;
@property(strong, nonatomic) TWRChartView *chartview1;
- (void)switchChart:(UISegmentedControl *)sender;
@end

@implementation ChartViewController

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
    // Segmented Control
    [_segment addTarget:self action:@selector(switchChart:) forControlEvents:UIControlEventValueChanged];
    _chartView = [[TWRChartView alloc] initWithFrame:CGRectMake(0, 64, 320, 200)];
    _chartView.backgroundColor=[UIColor clearColor];
    
    _chartview1=[[TWRChartView alloc]initWithFrame:CGRectMake(0, 264, 320, 240)];
    _chartview1.backgroundColor=[UIColor clearColor];
    //[self.view addSubview:_chartview1];

     [self.view addSubview:_chartView];
    // User interaction is disabled by default. You can enable it again if you want
    _chartView.userInteractionEnabled = YES;
    _chartview1.userInteractionEnabled=YES;
    // Load chart by using a ChartJS javascript file
    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"js"];
    [_chartView setChartJsFilePath:jsFilePath];
   // [_chartview1 setChartJsFilePath:jsFilePath];
    [_chartView loadLineChart: [self loadLineChart]];
    [_chartView loadBarChart:[self loadBarChart]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (TWRBarChart*)loadBarChart {
    // Build chart data
    TWRDataSet *dataSet1 = [[TWRDataSet alloc] initWithDataPoints:@[@10, @15, @5, @15, @5]
                                                        fillColor:[[UIColor orangeColor] colorWithAlphaComponent:0.5]
                                                      strokeColor:[UIColor orangeColor]];
    
    TWRDataSet *dataSet2 = [[TWRDataSet alloc] initWithDataPoints:@[@5, @10, @5, @15, @10]
                                                        fillColor:[[UIColor redColor] colorWithAlphaComponent:0.5]
                                                      strokeColor:[UIColor redColor]];
    
    NSArray *labels = @[@"深圳", @"香港", @"北京", @"广州", @"上海"];
    TWRBarChart *bar = [[TWRBarChart alloc] initWithLabels:labels
                                                  dataSets:@[dataSet1, dataSet2]
                                                  animated:YES];
    return bar;
   
}

/**
 *  Loads a line chart using native code
 */
- (TWRLineChart*)loadLineChart {
    // Build chart data
    TWRDataSet *dataSet1 = [[TWRDataSet alloc] initWithDataPoints:@[@10, @50, @5, @15, @45] fillColor:[UIColor clearColor] strokeColor:[UIColor redColor]];
    TWRDataSet *dataSet2 = [[TWRDataSet alloc] initWithDataPoints:@[@5, @100, @5, @55, @60] fillColor:[UIColor clearColor] strokeColor:[UIColor yellowColor]];
    TWRDataSet *dataSet3 = [[TWRDataSet alloc] initWithDataPoints:@[@30, @50, @15, @15, @35] fillColor:[UIColor clearColor] strokeColor:[UIColor blueColor]];
    TWRDataSet *dataSet4 = [[TWRDataSet alloc] initWithDataPoints:@[@25, @60, @45, @55, @60] fillColor:[UIColor clearColor] strokeColor:[UIColor orangeColor]];
    
    NSArray *labels = @[@"2011", @"2012", @"2013", @"2014", @"2015"];
    
    TWRLineChart *line = [[TWRLineChart alloc] initWithLabels:labels
                                                     dataSets:@[dataSet1, dataSet2,dataSet3,dataSet4]
                                                     animated:NO];
    // Load data
    return line;
    
}

/**
 *  Loads a pie / doughnut chart using native code
 */
- (TWRCircularChart*)loadPieChart {
    // Values
    NSArray *values = @[@20, @30, @15, @5];
    
    // Colors
    UIColor *color1 = [UIColor colorWithHue:0.5 saturation:0.6 brightness:0.6 alpha:1.0];
    UIColor *color2 = [UIColor colorWithHue:0.6 saturation:0.6 brightness:0.6 alpha:1.0];
    UIColor *color3 = [UIColor colorWithHue:0.7 saturation:0.6 brightness:0.6 alpha:1.0];
    UIColor *color4 = [UIColor colorWithHue:0.8 saturation:0.6 brightness:0.6 alpha:1.0];
    NSArray *colors = @[color1, color2, color3, color4];
    
    // Doughnut Chart
    TWRCircularChart *pieChart = [[TWRCircularChart alloc] initWithValues:values
                                                                   colors:colors
                                                                     type:TWRCircularChartTypePie
                                                                 animated:YES];
    return pieChart;
    
    // You can even leverage callbacks when chart animation ends!
    [_chartView loadCircularChart:pieChart withCompletionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"Animation finished!!!");
        }
    }];
}

- (void)switchChart:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
            //Line
        case 0: {
            [_chartView loadLineChart:[self loadLineChart]];            // Load data
            [_chartview1 loadBarChart:[self loadBarChart]];

            ;
        }
            break;
            
            //Bar
        case 1: {
            [_chartView loadBarChart:[self loadBarChart]];
            [_chartview1 loadCircularChart:[self loadPieChart] withCompletionHandler:^(BOOL finished) {
                if (finished) {
                    NSLog(@"Animation finished!!!");
                }
            }];

            
        }
            break;
            
            //Pie
        case 2: {
            [_chartView loadCircularChart:[self loadPieChart] withCompletionHandler:^(BOOL finished) {
                if (finished) {
                    NSLog(@"Animation finished!!!");
                }
            }];
            [_chartview1 loadLineChart:[self loadLineChart]];

        }
            break;
            
        default:
            break;
    }
}

@end
