//
//  DB_RespAejob_dtl_browse.h
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@interface DB_RespAejob_dtl_browse : NSObject

@property (nonatomic, strong) DatabaseQueue *queue;

- (BOOL)fn_save_aejob_dtl_browse_data:(NSMutableArray*)arr_result;
- (NSMutableArray*)fn_get_aejob_dtl_browse_data;
- (BOOL)fn_delete_aejob_browse_data;

@end
