//
//  DB_Resp_AppConfig.h
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
typedef enum {
    //枚举成员
    kCompany_code,
    kWeb_addr,
    kPhp_addr
}kAppConfig_field;//枚举名称

@interface DB_RespAppConfig : NSObject

@property (nonatomic, strong) DatabaseQueue *queue;

- (BOOL)fn_save_RespAppConfig_data:(NSMutableArray*)arr_result;

- (NSMutableArray*)fn_get_all_RespAppConfig_data;

- (BOOL)fn_delete_all_RespAppConfig_data;

- (NSString*)fn_get_field_content:(kAppConfig_field)field_name;
@end
