//
//  DB_single_field.m
//  itleo
//
//  Created by itdept on 14-9-22.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_single_field.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
@implementation DB_single_field
@synthesize queue;
-(id)init{
    self=[super init];
    if (self!=nil) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_data:(NSString*)table_name table_field:(NSString*)table_field field_value:(NSString*)field_value{
    __block BOOL isSuccess=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *delete_sql=[NSString stringWithFormat:@"delete from %@ where %@ =?",table_name,table_field];
            isSuccess =[db executeUpdate:delete_sql,field_value];
            NSString *insertsql=[NSString stringWithFormat:@"insert into %@(%@)values(\"%@\")",table_name,table_field,field_value];
            isSuccess=[db executeUpdate:insertsql];
            [db close];
        }
    }];
    return isSuccess;
}
-(NSMutableArray*)fn_get_data:(NSString*)table_name{
    __block  NSMutableArray *arr_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase* db){
        if ([db open]) {
            NSString *select_sql=[NSString stringWithFormat:@"select * from %@",table_name];
            FMResultSet *lfmdb_result=[db executeQuery:select_sql];
            while ([lfmdb_result next]) {
                [arr_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
        
    }];
    return arr_result;
}
-(BOOL)fn_delete_all_data:(NSString*)table_name{
    __block BOOL isDeleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *delete_sql=[NSString stringWithFormat:@"delete from %@",table_name];
            isDeleted=[db executeUpdate:delete_sql];
            [db close];
        }
    }];
    return isDeleted;
}
-(BOOL)fn_delete_data:(NSString*)table_name unique:(NSString*)unique_id{
    __block BOOL isDeleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *delete_sql=[NSString stringWithFormat:@"delete from %@ where unique_id like %@",table_name,unique_id];
            isDeleted=[db executeUpdate:delete_sql];
            [db close];
        }
    }];
    return isDeleted;
}
@end
