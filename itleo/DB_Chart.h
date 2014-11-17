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

@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_chart_data:(NSMutableArray*)alist_result;

-(NSMutableArray*)fn_get_DashboardGrpDResult_data;

-(NSMutableArray*)fn_get_DashboardDtlResult:(NSString*)group_id;

-(NSMutableArray*)fn_get_data:(NSString*)unique_id;
-(NSMutableArray*)fn_get_xValues_data:(NSString*)unique_id;
-(NSMutableArray*)fn_get_groupNameAndNum:(NSString*)unique_id;
-(BOOL)fn_delete_all_chart_data;

@end
