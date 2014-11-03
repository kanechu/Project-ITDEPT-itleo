//
//  DB_single_field.h
//  itleo
//
//  Created by itdept on 14-9-22.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_single_field : NSObject

@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_data:(NSString*)table_name table_field:(NSString*)table_field field_value:(NSString*)field_value;
-(NSMutableArray*)fn_get_data:(NSString*)table_name;
-(BOOL)fn_delete_all_data:(NSString*)table_name;
-(BOOL)fn_delete_data:(NSString*)table_name unique:(NSString*)unique_id;
@end
