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

- (BOOL)fn_save_warehouse_log:(NSMutableDictionary*)idic_whs_data;

- (NSMutableArray*)fn_get_group_data:(NSString*)enable;

- (NSMutableArray*)fn_get_cols_group_nameAndnum:(NSString*)unique_id;
- (NSMutableArray*)fn_get_upload_col_data:(NSString*)unique_id;

- (NSMutableArray*)fn_get_warehouse_record:(NSString*)str_upload_type;

- (BOOL)fn_delete_all_data;
- (BOOL)fn_delete_all_wharehouse_log;
@end
