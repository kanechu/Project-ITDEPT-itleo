//
//  DB_whs_config.h
//  itleo
//
//  Created by itdept on 14-12-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;

@interface DB_whs_config : NSObject

@property (nonatomic,strong) DatabaseQueue *queue;

- (BOOL)fn_save_whs_config_data:(NSMutableArray*)alist_result;

- (NSMutableArray*)fn_get_group_data:(NSString*)enable;

- (NSMutableArray*)fn_get_cols_group_nameAndnum:(NSString*)unique_id;

- (NSMutableArray*)fn_get_upload_col_data:(NSString*)unique_id;

- (BOOL)fn_delete_all_data;

//操作存储输入数据的表
- (BOOL)fn_save_warehouse_log:(NSMutableDictionary*)idic_whs_data;

- (NSMutableArray*)fn_get_warehouse_log:(NSString*)str_type_code;

- (BOOL)fn_update_warehouse_log_data:(NSString*)unique_id result_status:(NSString*)result_status result_msg:(NSString*)result_msg;

- (BOOL)fn_delete_all_wharehouse_log;

@end
