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
#import "Cal_lineHeight.h"

#define LEGEND_HEIGHT 21
#define LEGEND_WIDTH 145
#define LEGEND_SPACE 10
#define LEGEND_BIG_WIDTH 300
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
        if ([alist_options count]!=0) {
            [self fn_create_lineChart];
        }
        [self fn_add_legend_item];
    }
    if ([self.chart_type isEqualToString:@"GRID"]) {
        [self fn_create_GRID_Chart];
    }
}

#pragma mark -add legend item
-(void)fn_add_legend_item{
    CGRect lastRect=CGRectZero;
    NSInteger flag_row=0;//标识单行或多行 0多行 1单行
    for (int i=0; i<[alist_remarks count]; i++) {
        LegendItem_view *legendView=[LegendItem_view fn_shareInstance];
        legendView.ilb_color.backgroundColor=[alist_colors objectAtIndex:i];
        legendView.ilb_remark.text=[alist_remarks objectAtIndex:i];
        Cal_lineHeight *cal_obj=[[Cal_lineHeight alloc]init];
        CGFloat real_height=0;
        CGFloat height=[cal_obj fn_heightWithString:legendView.ilb_remark.text font:[UIFont systemFontOfSize:14] constrainedToWidth:LEGEND_WIDTH-15];
        if (height>21) {
            real_height=[cal_obj fn_heightWithString:legendView.ilb_remark.text font:[UIFont systemFontOfSize:14] constrainedToWidth:LEGEND_BIG_WIDTH-15];
            real_height=real_height+5;
            flag_row=0;
        }else{
            real_height=21;
            flag_row=1;
        }
        if (i==0&&flag_row==0) {
            legendView.frame=CGRectMake(LEGEND_SPACE,0,LEGEND_BIG_WIDTH, real_height);
            
        }else if(i==0){
            legendView.frame=CGRectMake(10,0,LEGEND_WIDTH, real_height);
        }
        
        
        if (lastRect.size.width>LEGEND_WIDTH &&i!=0) {
            if (flag_row==0) {
                legendView.frame=CGRectMake(lastRect.origin.x, lastRect.origin.y+lastRect.size.height,LEGEND_BIG_WIDTH,real_height);
            }else{
                legendView.frame=CGRectMake(lastRect.origin.x, lastRect.origin.y+lastRect.size.height,LEGEND_WIDTH, real_height);
            }
            
        }else if(i!=0){
            if (flag_row==0) {
                legendView.frame=CGRectMake(LEGEND_SPACE, lastRect.origin.y+lastRect.size.height, LEGEND_BIG_WIDTH, real_height);
            }else{
                if (lastRect.origin.x>LEGEND_WIDTH) {
                    legendView.frame=CGRectMake(LEGEND_SPACE, lastRect.origin.y+lastRect.size.height, LEGEND_WIDTH, real_height);
                }else{
                    legendView.frame=CGRectMake(LEGEND_SPACE+lastRect.size.width, lastRect.origin.y, LEGEND_WIDTH, real_height);
                }
            }
        }
        lastRect=legendView.frame;
        [self.iv_legend addSubview:legendView];
        
    }
    [self.iv_legend setContentSize:CGSizeMake(CGRectGetWidth(self.iv_legend.frame), CGRectGetMaxY(lastRect))];
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
    //隐藏额外的空白行
    UIView *view=[[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor=[UIColor clearColor];
    [gridChart setTableFooterView:view];
    gridChart.backgroundColor=[UIColor clearColor];
    gridChart.delegate=self;
    gridChart.dataSource=self;
    gridChart.frame=CGRectMake(0, 0, self.iv_chart.frame.size.width, self.frame.size.height);
    [self.iv_chart addSubview:gridChart];
    [self.iv_chart setFrame:CGRectMake(self.iv_chart.frame.origin.x, self.iv_chart.frame.origin.y, self.iv_chart.frame.size.width, CGRectGetHeight(self.frame))];
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
