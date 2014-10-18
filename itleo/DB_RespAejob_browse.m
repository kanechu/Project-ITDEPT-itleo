//
//  DB_RespAejob_browse.m
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_RespAejob_browse.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RespAejob_browse.h"
@implementation DB_RespAejob_browse
@synthesize queue;

-(id)init{
    self=[super init];
    if (self!=nil) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_aejob_browse_data:(NSMutableArray*)arr_result{
    __block BOOL isSucceed=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (RespAejob_browse *lmap_data in arr_result) {
                NSMutableDictionary *dic=[[NSDictionary dictionaryWithPropertiesOfObject:lmap_data]mutableCopy];
                isSucceed=[db executeUpdate:@"insert into aejob_browse(job_no,flight_no,flight_date,dish_port,uld_type,uld_no,pkg,kgs,cbf,no_of_hawb,carr_name,pallet_id)values(:job_no,:flight_no,:flight_date,:dish_port,:uld_type,:uld_no,:pkg,:kgs,:cbf,:no_of_hawb,:carr_name,:pallet_id)" withParameterDictionary:dic];
            }
            [db close];
        }
        
    }];
    return isSucceed;
}
-(NSMutableArray*)fn_get_groupData_num{
    __block  NSMutableArray *arr=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"SELECT flight_no,flight_date,dish_port,carr_name ,job_no,SUM(pkg) as pkg, SUM(kgs) as kgs, SUM(cbf) as cbf ,COUNT(flight_no) as num FROM aejob_browse GROUP BY flight_no,flight_date,carr_name,job_no"];
            while ([lfmdb_result next]) {
                [arr addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr;
}

-(NSMutableArray*)fn_get_all_aejob_browse_data{
    __block  NSMutableArray *arr_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb=[db executeQuery:@"select * from aejob_browse"];
            while ([lfmdb next]) {
                [arr_result addObject:[lfmdb resultDictionary]];
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
            NSString *delete=[NSString stringWithFormat:@"delete from aejob_browse"];
            ib_deleted=[db executeUpdate:delete];
            [db close];
        }
    }];
    return ib_deleted;
}
@end
