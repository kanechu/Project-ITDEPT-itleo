//
//  DB_Chart.h
//  itleo
//
//  Created by itdept on 14-11-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_Chart : NSObject

@property (nonatomic, strong) DatabaseQueue *queue;

- (BOOL)fn_save_chart_data:(NSMutableArray*)alist_result;

- (NSMutableArray*)fn_get_DashboardGrpDResult_data;

- (NSMutableArray*)fn_get_DashboardDtlResult:(NSString*)group_id;

- (NSMutableArray*)fn_get_data:(NSString*)unique_id;
- (NSMutableArray*)fn_get_xValues_data:(NSString*)unique_id;
/**
 *  获取x/serie的唯一值
 *
 *  @param field     x或serie
 *  @param unique_id 根据ID获取指定图数据
 *
 *  @return 返回存储x/serie唯一值的数组
 */
- (NSMutableArray*)fn_get_distinct_Values:(NSString*) field unique_id:(NSString*)unique_id;
/**
 *  根据x,serie获取y值
 *
 *  @param unique_id 根据ID获取指定图数据
 *  @param x         x坐标值
 *  @param serie     serie
 *
 *  @return 返回存储y值的数组。
 */
- (NSMutableArray*)fn_get_yValues:(NSString*)unique_id x:(NSString*)x serie:(NSString*)serie;
- (NSMutableArray*)fn_get_groupNameAndNum:(NSString*)unique_id;
- (BOOL)fn_update_chart_data:(NSMutableArray*)alist_result uid:(NSString*)unique_id;
- (BOOL)fn_delete_all_chart_data;

@end
