//
//  DB_sypara.h
//  ittracking
//
//  Created by itdept on 14-10-9.
//  Copyright (c) 2014年 ittracking Logistics Services Ltd. . All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_sypara : NSObject

@property (nonatomic, strong) DatabaseQueue *queue;

- (BOOL)fn_save_sypara_data:(NSMutableArray*)arr_sypara;

- (NSMutableArray*)fn_get_sypara_data;

- (BOOL)fn_isExist_sypara_data:(NSString*)para_code data1:(NSString*)str_data1;

- (BOOL)fn_isMust_open_the_GPS:(NSString*)para_code data2:(NSString*)str_data2;

- (BOOL)fn_delete_all_sypara_data;


@end
