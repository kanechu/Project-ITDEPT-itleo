//
//  DB_ePod.m
//  itleo
//
//  Created by itdept on 14-9-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_ePod.h"
#import "DatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "Truck_order_data.h"
#import "Truck_order_image_data.h"
#import "DB_LoginInfo.h"
#import "Resp_upd_image_result.h"
#import "Resp_get_status.h"
@interface DB_ePod()
@property(nonatomic,copy)NSString *user_code;
@property(nonatomic,copy)NSString *system;
@end

@implementation DB_ePod
@synthesize queue;
-(id)init{
    self=[super init];
    if (self!=nil) {
        queue=[DatabaseQueue fn_sharedInstance];
        DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
        AuthContract *auth=[db fn_get_RequestAuth];
        _user_code=auth.user_code;
        _system=auth.system;
    }
    return self;
    
}
-(BOOL)fn_save_ePod_data:(Truck_order_data*)upload_ms image_ms:(NSMutableArray*)alist_image_ms{
    NSString *order_no=upload_ms.order_no;
    NSString *vehicle_no=upload_ms.vehicle_no;
    NSMutableArray *arr_truck_order=[self fn_select_ePod_data:order_no vehicle_no:vehicle_no];
    NSNumber *unique_id=nil;
    if ([arr_truck_order count]!=0) {
        unique_id=[[arr_truck_order objectAtIndex:0]valueForKey:@"unique_id"];
    }
    __block BOOL isSuccess=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            if (unique_id!=nil) {
                isSuccess=[db  executeUpdate:@"delete from truck_order_image where correlation_id =?",unique_id];
            }
            isSuccess=[db executeUpdate:@"delete from truck_order where order_no=? and vehicle_no=?",order_no,vehicle_no];
            NSMutableDictionary *dic=[[NSDictionary dictionaryWithPropertiesOfObject:upload_ms]mutableCopy];
            isSuccess=[db executeUpdate:@"insert into truck_order(user_code,password,system_name,version,order_no,vehicle_no,status,is_uploaded,result,upload_date,error_date)values(:user_code,:password,:system_name,:version,:order_no,:vehicle_no,:status,:is_uploaded,:result,:upload_date,:error_date)" withParameterDictionary:dic];
            
            sqlite_int64 lastid=[db lastInsertRowId];
            NSNumber *lastID=[NSNumber numberWithLongLong:lastid];
            for (Truck_order_image_data *image_ms in alist_image_ms) {
                image_ms.correlation_id=lastID;
                NSMutableDictionary *dic_image=[[NSDictionary dictionaryWithPropertiesOfObject:image_ms]mutableCopy];
                isSuccess=[db executeUpdate:@"insert into truck_order_image(image,image_remark,image_isUploaded,error_reason,img_error_date,correlation_id)values(:image,:image_remark,:image_isUploaded,:error_reason,:img_error_date,:correlation_id)" withParameterDictionary:dic_image];
                
            }
            [db close];
        }
    }];
    return isSuccess;
}
-(NSMutableArray*)fn_select_ePod_data:(NSString*)order_no vehicle_no:(NSString*)vehicle_no{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from (select truck_order.*,truck_order_image.* from truck_order INNER JOIN truck_order_image on truck_order.unique_id=truck_order_image.correlation_id) where user_code=? and system_name=? and order_no like ? and vehicle_no like ?",_user_code,_system,order_no,vehicle_no];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            };
            [db close];
        }
        
    }];
    return alist_result;
}
-(NSMutableArray*)fn_select_ePod_data_no_image:(NSString*)order_no vehicle_no:(NSString*)vehicle_no{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from truck_order where user_code=? and system_name=? and order_no like ? and vehicle_no like ?",_user_code,_system,order_no,vehicle_no];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            };
            [db close];
        }
        
    }];
    return alist_result;
}
-(NSMutableArray*)fn_select_ePod_data:(NSString*)millisecond{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from truck_order  where user_code=? and system_name=? and (upload_date>? or error_date>?)",_user_code,_system,millisecond,millisecond];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            };
            [db close];
        }
        
    }];
    return alist_result;
}
-(NSMutableArray*)fn_select_all_ePod_data{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from truck_order  where user_code=? and system_name=?",_user_code,_system];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            };
            [db close];
        }
        
    }];
    return alist_result;
}
-(NSMutableArray*)fn_select_unUpload_truck_order_data:(NSString*)isUploaded1 isUploade2:(NSString*)isUploaded2{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from truck_order where (is_uploaded=? or is_uploaded=?) and user_code=? and system_name=?",isUploaded1,isUploaded2,_user_code,_system];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            };
            [db close];
        }
        
    }];
    return alist_result;
}
-(NSMutableArray*)fn_select_unUpload_ePod_data:(NSString*)is_uploaded{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from (select truck_order.*,truck_order_image.* from truck_order INNER JOIN truck_order_image on truck_order.unique_id=truck_order_image.correlation_id) where is_uploaded like ?",is_uploaded];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            };
            [db close];
        }
    }];
    return alist_result;
}
-(NSMutableArray*)fn_select_unUpload_record:(NSString*)is_uploaded{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from truck_order  where is_uploaded like ? and user_code=? and system_name=?",is_uploaded,_user_code,_system];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            };
            [db close];
        }
    }];
    return alist_result;
}
-(NSMutableArray*)fn_select_unUpload_ePod_data_amount:(NSString*)is_uploaded{
    __block  NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select vehicle_no,order_no,status,unique_id from (select truck_order.unique_id,truck_order.vehicle_no,truck_order.order_no,truck_order.status,truck_order.is_uploaded,truck_order_image.image from truck_order INNER JOIN truck_order_image on truck_order.unique_id=truck_order_image.correlation_id) where is_uploaded like ? GROUP BY vehicle_no,order_no",is_uploaded];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            };
            [db close];
        }
    }];
    return alist_result;
}

-(BOOL)fn_update_epod_after_uploaded:(NSString*)unique_id is_uploaded:(NSString*)is_uploaded date:(NSString*)date result:(NSString*)result user_code:(NSString*)user_code system:(NSString*)system  images:(NSSet*)alist_images_result{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *sql=@"";
            if ([is_uploaded isEqualToString:@"1"]) {
                sql=@"update truck_order set is_uploaded=?,upload_date=?,result=? where unique_id=? and user_code=? and system_name=?";
            }
            if ([is_uploaded isEqualToString:@"2"]) {
                sql=@"update truck_order set is_uploaded=?,error_date=?,result=? where unique_id=? and user_code=? and system_name=?";
            }
            ib_updated=[db executeUpdate:sql,is_uploaded,date,result,unique_id,user_code,system];
            for (Resp_upd_image_result *resp_upd_image in alist_images_result) {
                NSString *img_unique_id=resp_upd_image.unique_id;
                NSString *is_upload_sucess=resp_upd_image.is_upload_sucess;
                NSString *error_reason=resp_upd_image.error_reason;
                NSString *error_date=resp_upd_image.error_date;
                if (error_reason==nil) {
                    error_reason=@"";
                }
                if (error_date==nil) {
                    error_date=@"";
                }
                ib_updated=[db executeUpdate:@"update truck_order_image set image_isUploaded=?,error_reason=?,img_error_date =? where img_unique_id=?",is_upload_sucess,error_reason,error_date,img_unique_id];
            }
            [db close];
        }
    }];
    return ib_updated;
}

- (BOOL)fn_isRepeat_upload_epod_data:(NSString*)order_no status:(NSString*)status{
    __block BOOL isExist=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSMutableArray *alist_result=[NSMutableArray array];
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from truck_order where is_uploaded='1' and order_no=? and status=?",order_no,status];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            if ([alist_result count]!=0) {
                isExist=YES;
            }
            
            [db close];
        }
    }];
    return isExist;
}


-(BOOL)fn_delete_epod_data:(int)unique_id{
    __block BOOL isDeleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *sql=[NSString stringWithFormat:@"delete from truck_order_image where correlation_id =%d",unique_id];
            isDeleted=[db executeUpdate:sql];
            
            NSString *sql_truck=[NSString stringWithFormat:@"delete from truck_order where unique_id=%d and user_code=? and system_name=?",unique_id];
            isDeleted=[db executeUpdate:sql_truck,_user_code,_system];
            
            [db close];
        }
    }];
    return isDeleted;
}
-(BOOL)fn_delete_all_epod_data{
    __block BOOL isDeleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *sql=[NSString stringWithFormat:@"delete from truck_order_image"];
            isDeleted=[db executeUpdate:sql];
            
            NSString *sql_truck=[NSString stringWithFormat:@"delete from truck_order"];
            isDeleted=[db executeUpdate:sql_truck,_user_code,_system];
            
            [db close];
        }
    }];
    return isDeleted;
}
#pragma mark -epod status method

- (BOOL)fn_save_epod_status_data:(NSMutableArray*)alist_status{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (Resp_get_status *Resp_status in alist_status) {
                NSDictionary *dic=[NSDictionary dictionaryWithPropertiesOfObject:Resp_status];
                ib_updated=[db executeUpdate:@"insert into epod_status(status_code,status_desc_en,status_desc_sc,status_desc_tc)values(:status_code,:status_desc_en,:status_desc_sc,:status_desc_tc)" withParameterDictionary:dic];
            }
            [db close];
        }
    }];
    return ib_updated;
}
- (NSMutableArray*)fn_get_epod_status_data{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from epod_status"];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
}
- (BOOL)fn_delete_all_epod_status_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from epod_status"];
            [db close];
        }
    }];
    return ib_deleted;
}

@end
