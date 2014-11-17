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
 *  @param flag_arr_type 为1获取y坐标数据
 为2 获取x坐标数据  为3 获取附注数据
 *
 *  @return 把数据保存于数组中并返回
 */
+(NSMutableArray*)fn_get_arr_value:(NSString*)unique_id type:(NSInteger)flag_arr_type{
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
        if (flag_arr_type==1) {
            NSMutableArray *arr_result_data=[NSMutableArray array];
            for (NSMutableDictionary *dic in arr_filter) {
                NSString *y=[dic valueForKey:@"y"];
                [arr_result_data addObject:y];
            }
            [alist_results addObject:arr_result_data];
            
        }
    }
    if (flag_arr_type==2) {
        alist_results=[db_chart fn_get_xValues_data:unique_id];
    }
    if (flag_arr_type==3) {
        return alist_remarks;
    }else{
        return alist_results;
    }
}
/**
 *  获取饼状图、网格图表相关数据
 *
 *  @param unique_id     用于获取图表数据
 *  @param flag_arr_type 为1获取serie数据
 为2 获取分割数据
 *
 *  @return 把数据保存于数组中并返回
 */
+(NSMutableArray*)fn_get_chartData_value:(NSString*)unique_id type:(NSInteger)flag_arr_type{
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    //存储返回的数据
    NSMutableArray *alist_results=[[NSMutableArray alloc]initWithCapacity:1];
    //存储图表数据
    NSMutableArray *alist_data=[db_chart fn_get_data:unique_id];
    for (NSMutableDictionary *dic in alist_data) {
        NSString *serie=[dic valueForKey:@"serie"];
        NSString *y=[dic valueForKey:@"y"];
        if (flag_arr_type==1) {
            [alist_results addObject:serie];
        }
        if (flag_arr_type==2) {
            [alist_results addObject:y];
        }
    }
    return alist_results;
}

@end
