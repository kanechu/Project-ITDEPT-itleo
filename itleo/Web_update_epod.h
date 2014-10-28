//
//  Web_update_epod.h
//  itleo
//
//  Created by itdept on 14-9-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateFormContract_GPS.h"
typedef void (^callBack_result)(NSMutableArray*);
@interface Web_update_epod : NSObject
@property(nonatomic, copy) NSString *base_url;

- (void)fn_upload_epod_data:(UpdateFormContract*)updateform Auth:(AuthContract*)auth back_result:(callBack_result)call_back;
- (void)fn_get_order_info:(NSMutableArray*)arr_searchforms   back_result:(callBack_result)call_back;
- (void)fn_upload_epod_GPS:(NSMutableArray*)updateform Auth:(AuthContract*)auth back_result:(callBack_result)call_back;
@end
