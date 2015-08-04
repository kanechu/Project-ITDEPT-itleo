//
//  DB_LoginInfo.h
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@class AuthContract;
@interface DB_LoginInfo : NSObject

@property (nonatomic, strong) DatabaseQueue *queue;

- (BOOL)fn_save_LoginInfo_data:(NSString*)user_code password:(NSString*)password system:(NSString*)sys_name user_logo:(NSString*)user_logo lang_code:(NSString*)lang_code;

- (NSMutableArray*)fn_get_all_LoginInfoData;

- (BOOL)fn_delete_LoginInfo_data;

- (AuthContract*)fn_get_RequestAuth;

@end
