//
//  ChartData_handler.h
//  itleo
//
//  Created by itdept on 14-11-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartData_handler : NSObject

+(NSMutableArray*)fn_get_arr_value:(NSString*)unique_id type:(NSInteger)flag_arr_type;

+(NSMutableArray*)fn_get_chartData_value:(NSString*)unique_id type:(NSInteger)flag_arr_type;

@end
