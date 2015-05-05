//
//  DB_LoginInfo.m
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_LoginInfo.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabase.h"
#import "DB_RespAppConfig.h"
@implementation DB_LoginInfo
@synthesize queue;

-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}

-(BOOL)fn_save_LoginInfo_data:(NSString*)user_code password:(NSString*)password system:(NSString*)sys_name user_logo:(NSString*)user_logo lang_code:(NSString*)lang_code{
    __block BOOL isSuccess=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *delete=[NSString stringWithFormat:@"delete from loginInfo where user_code=? and password=? and system=?"];
            isSuccess=[db executeUpdate:delete,user_code,password,sys_name];
            NSString *insertSql=[NSString stringWithFormat:@"insert into loginInfo(user_code,password,system,user_logo,lang_code)values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",user_code,password,sys_name,user_logo,lang_code];
            isSuccess=[db executeUpdate:insertSql];
            
            [db close];
        }
        
    }];
    return isSuccess;
}

-(NSMutableArray*)fn_get_all_LoginInfoData{
    __block NSMutableArray *resultArr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from loginInfo"];
            while ([lfmdb_result next]) {
                [resultArr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return resultArr;
}

-(BOOL)fn_delete_LoginInfo_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *delete=[NSString stringWithFormat:@"delete from loginInfo"];
            ib_deleted=[db executeUpdate:delete];
            [db close];
        }
    }];
    return ib_deleted;
}

-(AuthContract*)fn_get_RequestAuth{
    AuthContract *auth=[[AuthContract alloc]init];
    NSMutableArray *userInfo=[self fn_get_all_LoginInfoData];
    if ([userInfo count]!=0) {
        NSMutableDictionary *dic=[userInfo objectAtIndex:0];
        auth.user_code=[dic valueForKey:@"user_code"];
        auth.password=[dic valueForKey:@"password"];
        auth.system=[dic valueForKey:@"system"];
        auth.lang_code=[dic valueForKey:@"lang_code"];
    }
    DB_RespAppConfig *db_appconfig=[[DB_RespAppConfig alloc]init];
    auth.company_code=[db_appconfig fn_get_field_content:kCompany_code];
    auth.encrypted=IS_ENCRYPTED;
    auth.version=VERSION;
    auth.app_code=APP_CODE;
    db_appconfig=nil;
    return auth;
}

@end
