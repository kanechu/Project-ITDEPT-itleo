//
//  ChartData_handler.m
//  itleo
//
//  Created by itdept on 14-11-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "ChartData_handler.h"
#import "DB_Chart.h"
#import "Conversion_helper.h"
@implementation ChartData_handler

/**
 *  获取柱状图、折线图表相关数据
 *
 *  @param unique_id     用于获取图表数据
 *  @param arr_type 获取y坐标数据,获取x坐标数据,获取附注数据
 *
 *  @return 把数据保存于数组中并返回
 */
+(NSMutableArray*)fn_get_arr_value:(NSString*)unique_id type:(KChartDataType)arr_type{
    unique_id=[Conversion_helper fn_cut_whitespace:unique_id];
   DB_Chart *db_chart=[[DB_Chart alloc]init];
    //存储返回的数据
    NSMutableArray *alist_results=[[NSMutableArray alloc]initWithCapacity:1];
    //存储图表数据
    NSMutableArray *alist_data=[db_chart fn_get_data:unique_id];
    //存储图表数据的分组
    NSMutableArray *alist_group=[db_chart fn_get_groupNameAndNum:unique_id];
    //存储过滤后的数据
    NSMutableArray *alist_filter=[[NSMutableArray alloc]init];
    NSMutableArray *alist_remarks=[[NSMutableArray alloc]init];
    for (NSMutableDictionary *dic_data in alist_group) {
        NSArray *arr_filter=nil;
        NSString *value=[dic_data valueForKey:@"serie"];
        arr_filter=[Conversion_helper fn_filtered_criteriaData:value arr:alist_data];
        [alist_filter addObject:arr_filter];
        [alist_remarks addObject:value];
    }
    for (NSArray *arr_filter in alist_filter) {
        if (arr_type==kChartDataYoptions) {
            NSMutableArray *arr_result_data=[NSMutableArray array];
            for (NSMutableDictionary *dic in arr_filter) {
                NSString *y=[dic valueForKey:@"y"];
                [arr_result_data addObject:y];
            }
            [alist_results addObject:arr_result_data];
            
        }
    }
    
    if (arr_type==kChartDataXvalues) {
        alist_results=[db_chart fn_get_xValues_data:unique_id];
    }
    if (arr_type==kChartDataColors) {
        for (NSInteger i=0; i<[alist_remarks count]; i++) {
            [alist_results addObject:[self colorForLine]];
        }
    }
    
    if (arr_type==kChartDataRemarks) {
        return alist_remarks;
    }else{
        return alist_results;
    }
}
/**
 *  获取饼状图、网格图表相关数据
 *
 *  @param unique_id     用于获取图表数据
 *  @param arr_type 获取serie数据,获取分割数据
 *
 *  @return 把数据保存于数组中并返回
 */
+(NSMutableArray*)fn_get_chartData_value:(NSString*)unique_id type:(KChartDataType)arr_type{
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    //存储返回的数据
    NSMutableArray *alist_results=[[NSMutableArray alloc]initWithCapacity:1];
    //存储图表数据
    NSMutableArray *alist_data=[db_chart fn_get_data:unique_id];
    for (NSMutableDictionary *dic in alist_data) {
        NSString *serie=[dic valueForKey:@"serie"];
        NSString *y=[dic valueForKey:@"y"];
        if (arr_type==kChartDataSerieValues) {
            [alist_results addObject:serie];
        }
        if (arr_type==kChartDataYoptions) {
            [alist_results addObject:y];
        }
        if (arr_type==kChartDataColors) {
            [alist_results addObject:[self colorForLine]];
        }
    }
    return alist_results;
}
+(UIColor *)colorForLine
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

@end
