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

-(NSSet*)fn_get_all_order_uid;

-(NSMutableArray*)fn_filter_order_list:(NSString*)order_no;

- (NSMutableArray*)fn_isExist_order:(NSString*)order_no;

-(NSMutableArray*)fn_get_order_dtl_list_data:(NSString*)order_uid;

-(BOOL)fn_update_order_isRead:(NSString*)is_read read_date:(NSString*)read_date order_uid:(NSString*)order_uid;

-(BOOL)fn_update_order_isSync_read:(NSString*)isSync_read order_uid:(NSString*)order_uid;

-(BOOL)fn_update_order_isConfirm:(NSString*)is_confirm order_uid:(NSString*)order_uid;

-(BOOL)fn_delete_inexistence_order:(NSString*)str_order_uids;

-(BOOL)fn_delete_all_order_list;

@end
