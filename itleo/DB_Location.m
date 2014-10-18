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
-(BOOL)fn_save_loaction_data:(NSString*)longitude latitude:(NSString*)latitude{
    __block BOOL isSucceed=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            isSucceed=[db executeUpdate:@"delete from location where longitude =? and latitude =?",longitude,latitude];
            
            NSString *sql=[NSString stringWithFormat:@"insert into location(longitude,latitude)values (\"%@\",\"%@\")", longitude, latitude];
            
            isSucceed=[db executeUpdate:sql];
            [db close];
        }
    }];
    return isSucceed;
}
-(NSMutableArray*)fn_get_location_data{
    __block NSMutableArray *arr_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from location"];
            while ([lfmdb_result next]) {
                [arr_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return arr_result;
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
@end
