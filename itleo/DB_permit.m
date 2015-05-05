//
//  DB_permit.m
//  itleo
//
//  Created by itdept on 14-11-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_permit.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "DatabaseQueue.h"
#import "NSDictionary.h"
#import "Resp_permit.h"
@implementation DB_permit
@synthesize queue;

-(id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}


- (BOOL)fn_save_permit_data:(NSMutableArray*)arr_permit{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (Resp_permit *permit in arr_permit) {
                NSMutableDictionary *dic_permit=[[NSDictionary dictionaryWithPropertiesOfObject:permit]mutableCopy];
                NSString *module_code=[Conversion_helper fn_cut_whitespace:[dic_permit valueForKey:@"module_code"]];
                [dic_permit setObject:module_code forKey:@"module_code"];
                module_code=nil;
                
                ib_updated=[db executeUpdate:@"insert into permit(module_unique_id,module_code,module_desc,module_desc_lang1,module_desc_lang2,f_exec)values(:module_unique_id,:module_code,:module_desc,:module_desc_lang1,:module_desc_lang2,:f_exec)" withParameterDictionary:dic_permit];
                
            }
            [db close];
        }
    }];
    return ib_updated;
}

- (NSMutableArray*)fn_get_permit_data{
    __block  NSMutableArray *arr_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from permit"];
            while ([lfmdb_result next]) {
                [arr_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr_result;
}
- (BOOL)fn_isExist_module:(NSString*)module_code f_exec:(NSString*)f_exec{
    __block  NSMutableArray *arr_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from permit where module_code like ? and f_exec like ?",module_code,f_exec];
            while ([lfmdb_result next]) {
                [arr_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    if ([arr_result count]!=0) {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)fn_delete_all_permit_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from permit"];
            [db close];
        }
    }];
    return ib_deleted;
}

@end
