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

- (NSMutableArray*)fn_get_group_data;

- (NSMutableArray*)fn_get_upload_col_data;

- (BOOL)fn_delete_all_data;

@end
