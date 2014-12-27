//
//  ChartData_handler.m
//  itleo
//
//  Created by itdept on 14-11-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "ChartData_handler.h"
#import "DB_Chart.h"
@implementation ChartData_handler

+(NSMutableArray*)fn_gets_the_chart_Data:(NSString *)unique_id arr_type:(KChartDataType)arr_type chart_type:(NSString*)chart_type{
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    //存储返回的数据
    NSMutableArray *alist_results=[[NSMutableArray alloc]initWithCapacity:1];
    //存储图表x Values
    NSMutableArray *alist_xValues=[db_chart fn_get_distinct_Values:@"x" unique_id:unique_id];
    //存储图表serie Values
    NSMutableArray *alist_serie=[db_chart fn_get_distinct_Values:@"serie" unique_id:unique_id];
    //存储图表y Values
    NSMutableArray *alist_yValues=[[NSMutableArray alloc]initWithCapacity:1];
    if ([chart_type isEqualToString:@"LINE"]) {
        for (NSString *str_serie in alist_serie) {
            NSMutableArray *alist_group_y=[[NSMutableArray alloc]initWithCapacity:1];
            for (NSString *str_x in alist_xValues) {
                NSMutableArray *alist_y=[db_chart fn_get_yValues:unique_id x:str_x serie:str_serie];
                if ([alist_y count]!=0) {
                    NSString *str_y=[alist_y objectAtIndex:0];
                    [alist_group_y addObject:str_y];
                }else{
                    [alist_group_y addObject:@"0"];
                }
            }
            [alist_yValues addObject:alist_group_y];
        }
        
    }
    if ([chart_type isEqualToString:@"BAR"]) {
        for (NSString *str_x in alist_xValues) {
            NSMutableArray *alist_group_y=[[NSMutableArray alloc]initWithCapacity:1];
            for (NSString *str_serie in alist_serie) {
                NSMutableArray *alist_y=[db_chart fn_get_yValues:unique_id x:str_x serie:str_serie];
                if ([alist_y count]!=0) {
                    NSString *str_y=[alist_y objectAtIndex:0];
                    [alist_group_y addObject:str_y];
                }else{
                    [alist_group_y addObject:@"0"];
                }
            }
            [alist_yValues addObject:alist_group_y];
        }
    }
    if ([chart_type isEqualToString:@"PIE"] || [chart_type isEqualToString:@"GRID"]) {
        if (arr_type==kChartDataSerieValues) {
            alist_results=[NSMutableArray arrayWithArray:alist_serie];
        }
        for (NSString *str_serie in alist_serie) {
            NSInteger int_y=0;
            for (NSString *str_x in alist_xValues) {
                NSMutableArray *alist_y=[db_chart fn_get_yValues:unique_id x:str_x serie:str_serie];
                if ([alist_y count]!=0) {
                    NSString *str_y=[alist_y objectAtIndex:0];
                    int_y=int_y+[str_y integerValue];
                }
            }
            [alist_yValues addObject:[NSNumber numberWithInteger:int_y]];
        }
    }
    
    if (arr_type==kChartDataXvalues) {
        return  alist_xValues;
    }
    if (arr_type==kChartDataYoptions) {
        return alist_yValues;
    }
    if (arr_type==kChartDataRemarks) {
        return alist_serie;
    }
    if (arr_type==kChartDataColors) {
        
        for (NSInteger i=0; i<[alist_serie count]; i++) {
            [alist_results addObject:[self colorForLine:i]];
        }
    }
    return alist_results;
}

+(UIColor *)colorForLine:(NSInteger)i
{
  /*  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black*/
    
      CGFloat hue = ((i*(11+i)) % 256 / 256.0 );  //  0.0 to 1.0
     CGFloat saturation = ((i*(22+i))% 128 / 256.0 )+0.6 ;  //  0.5 to 1.0, away from white
     CGFloat brightness = ( (i*(33+i)) % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

@end
