//
//  DB_order.m
//  itleo
//
//  Created by itdept on 15/4/18.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "DB_order.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "Resp_epod_order_list.h"
#import "Resp_order_list.h"
#import "Resp_order_dtl_list.h"

@implementation DB_order
@synthesize queue;

- (id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
-(BOOL)fn_save_epod_order_data:(NSMutableArray*)alist_orders{
    __block BOOL isSuccess=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (Resp_epod_order_list *epod_order_obj in alist_orders) {
                NSArray *alist_order_list=epod_order_obj.ls_order_list;
                for (Resp_order_list *order_list_obj in alist_order_list) {
                    NSArray *alist_order_dtl_list=order_list_obj.ls_order_dtl_list;
                    NSString *order_uid=order_list_obj.order_uid;
                    NSMutableDictionary *dic_order_list=[[NSDictionary dictionaryWithPropertiesOfObject:order_list_obj]mutableCopy];
                    [dic_order_list setObject:@"2015-04-20" forKey:@"update_time"];
                    [dic_order_list removeObjectForKey:@"ls_order_dtl_list"];
                    isSuccess=[db executeUpdate:@"insert into order_list(order_uid,order_no,status,remark,pick_addr,dely_addr,sign_path,sign_path_base64,voided,update_time)values(:order_uid,:order_no,:status,:remark,:pick_addr,:dely_addr,:sign_path,:sign_path_base64,:voided,:update_time)" withParameterDictionary:dic_order_list];
                    for (Resp_order_dtl_list *order_dtl_obj in alist_order_dtl_list) {
                        NSMutableDictionary *dic_order_dtl=[[NSDictionary dictionaryWithPropertiesOfObject:order_dtl_obj]mutableCopy];
                        [dic_order_dtl setObject:order_uid forKey:@"order_uid"];
                        
                        isSuccess=[db executeUpdate:@"insert into order_dtl_list(pgdw_lot_uid,descp,pkg,item_pic_path,item_pic_path_base64,order_uid)values(:pgdw_lot_uid,:descp,:pkg,:item_pic_path,:item_pic_path_base64,:order_uid)" withParameterDictionary:dic_order_dtl];
                    }
                }
            }
            [db close];
        }
    }];
    return isSuccess;
}

-(NSMutableArray*)fn_get_order_list_data{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from order_list"];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
}
-(NSMutableArray*)fn_get_all_order_uid{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select order_uid from order_list"];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
}

-(NSMutableArray*)fn_filter_order_list:(NSString*)order_no{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from order_list where order_no like ? ",[NSString stringWithFormat:@"%%%@%%",order_no]];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;

}
-(NSMutableArray*)fn_get_order_dtl_list_data:(NSString*)order_uid{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from order_dtl_list where order_uid = ?",order_uid];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
        
    }];
    return alist_result;
}

-(BOOL)fn_delete_inexistence_order:(NSString*)order_uid{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from order_dtl_list where order_uid= ?",order_uid];
            ib_deleted=[db executeUpdate:@"delete from order_list where order_uid= ?",order_uid];
            [db close];
        }
    }];
    return ib_deleted;
}

-(BOOL)fn_delete_all_order_list{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from order_dtl_list"];
            ib_deleted=[db executeUpdate:@"delete from order_list"];
            [db close];
        }
    }];
    return ib_deleted;
}

@end
