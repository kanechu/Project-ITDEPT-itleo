//
//  DB_permit.h
//  itleo
//
//  Created by itdept on 14-11-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_permit : NSObject
@property(nonatomic,strong)DatabaseQueue *queue;

- (BOOL)fn_save_permit_data:(NSMutableArray*)arr_permit;

- (NSMutableArray*)fn_get_permit_data;

- (BOOL)fn_isExist_module:(NSString*)module_code f_exec:(NSString*)f_exec;

- (BOOL)fn_delete_all_permit_data;

@end
