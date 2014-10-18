//
//  DB_RespAejob_dtl_browse.m
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_RespAejob_dtl_browse.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RespAejob_dtl_browse.h"
@implementation DB_RespAejob_dtl_browse
@synthesize queue;

-(id)init{
    self=[super init];
    if (self!=nil) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}

-(BOOL)fn_save_aejob_dtl_browse_data:(NSMutableArray*)arr_result{
    __block BOOL isSucceed=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (RespAejob_dtl_browse *lmap_data in arr_result) {
                NSMutableDictionary *dic=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
                isSucceed=[db executeUpdate:@"insert into aejob_dtl_browse(pallet_id,uld_type,uld_no,hbl_no,cbl_no,dest_port,pkg,kgs,cbf,mnf_act_weight,shpr_name,cnee_name)values(:pallet_id,:uld_type,:uld_no,:hbl_no,:cbl_no,:dest_port,:pkg,:kgs,:cbf,:mnf_act_weight,:shpr_name,:cnee_name)" withParameterDictionary:dic];
            }
            [db close];
        }
    }];
    
    return isSucceed;
}
-(NSMutableArray*)fn_get_aejob_dtl_browse_data{
    __block NSMutableArray *arr_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from aejob_dtl_browse"];
            while ([lfmdb_result next]) {
                [arr_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr_result;
}


-(BOOL)fn_delete_aejob_browse_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *delete=[NSString stringWithFormat:@"delete from aejob_dtl_browse"];
            ib_deleted=[db executeUpdate:delete];
            [db close];
        }
    }];
    return ib_deleted;
}
@end
