//
//  DB_order.h
//  itleo
//
//  Created by itdept on 15/4/18.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@class Resp_epod_order_list;
@interface DB_order : NSObject

@property (nonatomic,strong) DatabaseQueue *queue;

-(BOOL)fn_save_epod_order_data:(NSMutableArray*)alist_orders;

-(NSMutableArray*)fn_get_order_list_data;

-(NSMutableArray*)fn_get_all_order_uid;

-(NSMutableArray*)fn_filter_order_list:(NSString*)order_no;

-(NSMutableArray*)fn_get_order_dtl_list_data:(NSString*)order_uid;

-(BOOL)fn_delete_inexistence_order:(NSString*)order_uid;

-(BOOL)fn_delete_all_order_list;

@end
