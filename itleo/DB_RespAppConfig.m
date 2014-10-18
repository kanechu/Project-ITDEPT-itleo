//
//  DB_Resp_AppConfig.m
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_RespAppConfig.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RespAppConfig.h"
@implementation DB_RespAppConfig
@synthesize queue;

-(id)init{
    queue=[DatabaseQueue fn_sharedInstance];
    return self;
}
-(BOOL)fn_save_RespAppConfig_data:(NSMutableArray*)arr_result{
    __block BOOL isSucceed=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (RespAppConfig *lmap_data in arr_result) {
                NSMutableDictionary *dic=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
                isSucceed=[db executeUpdate:@"delete from RespAppConfig where company_code = :company_code and sys_name = :sys_name and env = :env and web_addr =:web_addr and php_addr =:php_addr" withParameterDictionary:dic];
                isSucceed=[db executeUpdate:@"insert into RespAppConfig (company_code, sys_name, env, web_addr,php_addr) values (:company_code, :sys_name, :env, :web_addr,:php_addr)" withParameterDictionary:dic];
            }
            [db close];
        }
        
    }];
    return isSucceed;
}
-(NSMutableArray*)fn_get_all_RespAppConfig_data{
    __block NSMutableArray *llist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"SELECT * FROM RespAppConfig"];
            while ([lfmdb_result next]) {
                [llist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return llist_result;
}
-(BOOL)fn_delete_all_RespAppConfig_data{
    __block BOOL isDeleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            isDeleted=[db executeUpdate:@"delete from RespAppConfig"];
            [db close];
        }
    }];
    return isDeleted;
}

@end
