//
//  DB_Location.m
//  itleo
//
//  Created by itdept on 14-9-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_Location.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
@implementation DB_Location
@synthesize queue;
-(id)init{
    self=[super init];
    if (self!=nil) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_loaction_data:(NSString*)longitude latitude:(NSString*)latitude car_no:(NSString*)car_no{
    __block BOOL isSucceed=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *current_date=[self fn_get_current_date];
            NSString *is_uploaded=@"0";
            NSString *sql=[NSString stringWithFormat:@"insert into location(car_no,longitude,latitude,log_date,is_uploaded)values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",car_no,longitude, latitude,current_date,is_uploaded];
            
            isSucceed=[db executeUpdate:sql];
            [db close];
        }
    }];
    return isSucceed;
}
-(NSMutableArray*)fn_get_location_data:(NSString*)is_uploaded{
    __block NSMutableArray *arr_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from location where is_uploaded like ?",is_uploaded];
            while ([lfmdb_result next]) {
                [arr_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr_result;
}
-(BOOL)fn_update_isUploaded_status:(NSString*)unique isUploaded:(NSString*)is_uploaded{
    __block BOOL isUpdated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            isUpdated=[db executeUpdate:@"update location set is_uploaded=? where id_t=?",is_uploaded,unique];
            [db close];
        }
    }];
    return isUpdated;
}

-(BOOL)fn_delete_location_data{
    __block BOOL isDeleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            isDeleted =[db executeUpdate:@"delete from location"];
            [db close];
        }
    }];
    return isDeleted;
}
-(NSString*)fn_get_current_date{
    NSDate *current_date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:current_date];
}
@end
