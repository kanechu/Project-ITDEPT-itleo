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
    PieChart *_pieChart_view=[[PieChart alloc]init];
    
    [_pieChart_view setOptions:alist_options];
    [_pieChart_view setTitleValues:alist_values];
    [_pieChart_view setSideValue_Bar:kSideValueBar_Show];
    [_pieChart_view setSegment_Selection:kSegmentSelection_Off];
    _pieChart_view.frame=CGRectMake(0, 0, self.iv_chart.frame.size.width, self.iv_chart.frame.size.height);
    [self.iv_chart addSubview:_pieChart_view];
}
-(void)fn_create_barChart{
    BarChart  *_barChart_view=[[BarChart alloc]init];
    _barChart_view.backgroundColor=[UIColor clearColor];
    [_barChart_view setColorArray:alist_colors];
    [_barChart_view setValues:alist_values];
    
    [_barChart_view setGroupOrBarTitles:alist_options];
    _barChart_view.frame=CGRectMake(0, 0, self.iv_chart.frame.size.width, self.iv_chart.frame.size.height);
    [self.iv_chart addSubview:_barChart_view];
    
}
-(void)fn_create_lineChart{
    
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
