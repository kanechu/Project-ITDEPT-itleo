//
//  ChartData_handler.h
//  itleo
//
//  Created by itdept on 14-11-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    kChartDataXvalues,
    kChartDataSerieValues,
    kChartDataYoptions,
    kChartDataRemarks,
    kChartDataColors
}KChartDataType;

@interface ChartData_handler : NSObject
/**
 *  获取图表所需的数据
 *
 *  @param unique_id  图表类型的唯一值，根据此值获取该图表数据
 *  @param arr_type   获取图表的x/y坐标等值
 *  @param chart_type 图表的类型
 *
 *  @return 相关值存储与数组中并返回
 */
+(NSMutableArray*)fn_gets_the_chart_Data:(NSString *)unique_id arr_type:(KChartDataType)arr_type chart_type:(NSString*)chart_type;

@end
