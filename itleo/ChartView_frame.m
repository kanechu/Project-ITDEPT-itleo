//
//  ChartView_frame.m
//  itleo
//
//  Created by itdept on 14-11-14.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "ChartView_frame.h"
#import "LegendItem_view.h"
#import "PieChart.h"
#import "BarChart.h"
#import "LineChartExp.h"

#define LEGEND_HEIGHT 21
#define LEGEND_WIDTH 145
#define LEGEND_SPACE 10

@implementation ChartView_frame
@synthesize alist_colors;
@synthesize alist_remarks;
@synthesize alist_values;
@synthesize alist_options;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//如果你要加点什么东西，就重载initWithCoder
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        //you init
    }
    return self;
}
+(ChartView_frame*)fn_shareInstance{
    NSArray *nibView=[[NSBundle mainBundle]loadNibNamed:@"ChartView_frame" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
#pragma mark -重新布局
-(void)layoutSubviews{
    [super layoutSubviews];
    if ([self.chart_type isEqualToString:@"BAR"]) {
        [self fn_add_legend_item];
        [self fn_create_barChart];
        
    }
    if ([self.chart_type isEqualToString:@"PIE"]) {
        [self fn_create_pieChart];
    }
    
    if ([self.chart_type isEqualToString:@"LINE"]) {
        [self fn_create_lineChart];
        [self fn_add_legend_item];
    }
    if ([self.chart_type isEqualToString:@"GRID"]) {
        [self fn_create_GRID_Chart];
    }
}

#pragma mark -add legend item
-(void)fn_add_legend_item{
    for (int i=0; i<[alist_remarks count]; i++) {
        LegendItem_view *legendView=[LegendItem_view fn_shareInstance];
        legendView.ilb_color.backgroundColor=[alist_colors objectAtIndex:i];
        legendView.ilb_remark.text=[alist_remarks objectAtIndex:i];
        if (i%2==0) {
            legendView.frame=CGRectMake(LEGEND_SPACE,_iv_chart.frame.size.height+_iv_chart.frame.origin.y+(i/2)*LEGEND_HEIGHT, LEGEND_WIDTH, LEGEND_HEIGHT);
        }else{
            legendView.frame=CGRectMake(LEGEND_SPACE+LEGEND_WIDTH, _iv_chart.frame.size.height+_iv_chart.frame.origin.y+(i/2)*LEGEND_HEIGHT, LEGEND_WIDTH, LEGEND_HEIGHT);
        }
        [self addSubview:legendView];
        
    }
}
#pragma mark -create chart
-(void)fn_create_pieChart{
    //移除iv_chart上的所有子视图
    [self.iv_chart.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    PieChart *_pieChart_view=[[PieChart alloc]init];
    
    [_pieChart_view setOptions:alist_options];
    [_pieChart_view setTitleValues:alist_values];
    [_pieChart_view setSegmentColors:alist_colors];
    [_pieChart_view setSideValue_Bar:kSideValueBar_Show];
    [_pieChart_view setSegment_Selection:kSegmentSelection_Off];
    _pieChart_view.frame=CGRectMake(0, 0, self.iv_chart.frame.size.width, self.iv_chart.frame.size.height-50);
    [self.iv_chart addSubview:_pieChart_view];
}
-(void)fn_create_barChart{
    [self.iv_chart.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    BarChart  *_barChart_view=[[BarChart alloc]init];
    _barChart_view.backgroundColor=[UIColor clearColor];
    [_barChart_view setColorArray:alist_colors];
    [_barChart_view setValues:alist_options];
    
    [_barChart_view setGroupOrBarTitles:alist_values];
    _barChart_view.frame=CGRectMake(0, 0, self.iv_chart.frame.size.width, self.iv_chart.frame.size.height);
    [self.iv_chart addSubview:_barChart_view];
    
}
-(void)fn_create_lineChart{
    [self.iv_chart.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    LineChartExp *lineChart=[[LineChartExp alloc]init];
    lineChart.frame=CGRectMake(0, 0, self.iv_chart.frame.size.width, self.iv_chart.frame.size.height);
    [lineChart setOptions:alist_options];
    [lineChart setXAxisValues:alist_values];
    [lineChart setColorArray:alist_colors];
    lineChart.backgroundColor=[UIColor clearColor];
    [self.iv_chart addSubview:lineChart];
}
-(void)fn_create_GRID_Chart{
    [self.iv_chart.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UITableView *gridChart=[[UITableView alloc]init];
    gridChart.backgroundColor=[UIColor clearColor];
    gridChart.delegate=self;
    gridChart.dataSource=self;
    gridChart.frame=CGRectMake(0, 0, self.iv_chart.frame.size.width, self.iv_chart.frame.size.height);
    [self.iv_chart addSubview:gridChart];
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.alist_options count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer = @"GRID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIndentifer];
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[self.alist_values objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",[self.alist_options objectAtIndex:indexPath.row]];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
