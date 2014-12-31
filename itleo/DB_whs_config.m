//
//  DB_whs_config.m
//  itleo
//
//  Created by itdept on 14-12-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_whs_config.h"
#import "DatabaseQueue.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#import "Resp_whs_config.h"
#import "Resp_MaintForm.h"
#import "Resp_language_type.h"
#import "Resp_UPLOAD_COL.h"
@implementation DB_whs_config
@synthesize queue;

- (id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}
- (BOOL)fn_save_whs_config_data:(NSMutableArray*)alist_result{
    __block BOOL ib_updated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (Resp_whs_config *whs_config in alist_result) {
                NSArray *maintForm=whs_config.MaintForm;
                NSInteger i=1;
                for (Resp_MaintForm *resp_maint_obj in maintForm) {
                    NSMutableDictionary *dic_whs_header=[[NSDictionary dictionaryWithPropertiesOfObject:resp_maint_obj]mutableCopy];
                    [dic_whs_header removeObjectsForKeys:@[@"FORMAT_NAME",@"UPLOAD_COL"]];
                    NSArray *arr_format_names=resp_maint_obj.FORMAT_NAME;
                    for (Resp_language_type *language_obj in arr_format_names) {
                        NSDictionary *dic_language=[NSDictionary dictionaryWithPropertiesOfObject:language_obj];
                        for (NSString *str_key in [dic_language allKeys]) {
                            NSString *key_value=[dic_language valueForKey:str_key];
                            [dic_whs_header setObject:key_value forKey:str_key];
                            key_value=nil;
                        }
                        dic_language=nil;
                        
                    }
                    NSArray *arr_upload_col=resp_maint_obj.UPLOAD_COL;
                    
                    ib_updated=[db executeUpdate:@"insert into whs_config_header(EN,CN,TCN,ENABLE,UPLOAD_TYPE)values(:EN,:CN,:TCN,:ENABLE,:UPLOAD_TYPE)" withParameterDictionary:dic_whs_header];
                    dic_whs_header=nil;
                    
                    for (Resp_UPLOAD_COL *upload_col_obj in arr_upload_col) {
                        NSMutableDictionary *dic_whs_detail=[[NSDictionary dictionaryWithPropertiesOfObject:upload_col_obj]mutableCopy];
                        [dic_whs_detail removeObjectsForKeys:@[@"col_label",@"group_name"]];
            
                        [dic_whs_detail setObject:[NSString stringWithFormat:@"%d",i] forKey:@"unique_id"];
                        NSArray *arr_col_labels=upload_col_obj.col_label;
                        for (Resp_language_type *language_obj in arr_col_labels) {
                            NSDictionary *dic_language=[NSDictionary dictionaryWithPropertiesOfObject:language_obj];
                            for (NSString *str_key in [dic_language allKeys]) {
                                NSString *key_value=[dic_language valueForKey:str_key];
                                if ([str_key isEqualToString:@"EN"]) {
                                  [dic_whs_detail setObject:key_value forKey:@"col_lable_en"];
                                }
                                if ([str_key isEqualToString:@"CN"]) {
                                    [dic_whs_detail setObject:key_value forKey:@"col_lable_cn"];
                                }
                                if ([str_key isEqualToString:@"TCN"]) {
                                    [dic_whs_detail setObject:key_value forKey:@"col_lable_tcn"];
                                }
                                key_value=nil;
                            }
                            dic_language=nil;
                            
                        }
                        NSArray *arr_group_names=upload_col_obj.group_name;
                        for (Resp_language_type *language_obj in arr_group_names) {
                            NSDictionary *dic_language=[NSDictionary dictionaryWithPropertiesOfObject:language_obj];
                            for (NSString *str_key in [dic_language allKeys]) {
                                NSString *key_value=[dic_language valueForKey:str_key];
                                if ([str_key isEqualToString:@"EN"]) {
                                    [dic_whs_detail setObject:key_value forKey:@"group_name_en"];
                                }
                                if ([str_key isEqualToString:@"CN"]) {
                                    [dic_whs_detail setObject:key_value forKey:@"group_name_cn"];
                                }
                                if ([str_key isEqualToString:@"TCN"]) {
                                    [dic_whs_detail setObject:key_value forKey:@"group_name_tcn"];
                                }

                                key_value=nil;
                            }
                            dic_language=nil;
                            
                        }
                        
                        ib_updated=[db executeUpdate:@"insert into whs_upload_col(seq,col_field,col_lable_en,col_lable_cn,col_lable_tcn,col_type,col_option,col_def,group_name_en,group_name_cn,group_name_tcn,is_mandatory,unique_id)values(:seq,:col_field,:col_lable_en,:col_lable_cn,:col_lable_tcn,:col_type,:col_option,:col_def,:group_name_en,:group_name_cn,:group_name_tcn,:is_mandatory,:unique_id)" withParameterDictionary:dic_whs_detail];
                        dic_whs_detail=nil;
                    }
                  i++;
                }
                
            }
            
            [db close];
        }
    }];
    return ib_updated;
}
- (BOOL)fn_save_input_warehouse_data:(NSMutableDictionary*)idic_whs_data{
    __block BOOL ib_updated=NO;
    NSDate *current_date=[NSDate date];
    NSString *millisecond=[Conversion_helper fn_millisecondFromDate:current_date];
    NSMutableArray *alist_result=[NSMutableArray array];
    for (NSString *key in [idic_whs_data allKeys]) {
        NSMutableDictionary *idic=[[NSMutableDictionary alloc]init];
        NSString *key_value=[idic_whs_data valueForKey:key];
        NSString *str_uploaded=@"lili";
        [idic setObject:key forKey:@"col_field_name"];
        [idic setObject:key_value forKey:@"col_field_value"];
        [idic setObject:millisecond forKey:@"save_time"];
        [idic setObject:str_uploaded forKey:@"is_uploaded "];
        [alist_result addObject:idic];
        idic=nil;
    }
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (NSDictionary *dic in alist_result) {
                ib_updated=[db executeUpdate:@"insert into whs_config_data(col_field_name,col_field_value,save_time,is_uploaded)values(:col_field_name,:col_field_value,:save_time,:is_uploaded)" withParameterDictionary:dic];
            }
            
            [db close];
        }
    }];
    alist_result=nil;
    return ib_updated;
}

- (NSMutableArray*)fn_get_group_data:(NSString*)enable{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from whs_config_header where ENABLE like ?",enable];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
}
- (NSMutableArray*)fn_get_cols_group_nameAndnum:(NSString*)unique_id{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select group_name_en,group_name_cn,group_name_tcn,COUNT(group_name_en) as num from whs_upload_col where unique_id=? group by group_name_en",unique_id];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
}
- (NSMutableArray*)fn_get_upload_col_data:(NSString*)unique_id{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from whs_upload_col where unique_id=?",unique_id];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
}

- (NSMutableArray*)fn_get_warehouse_record{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb=[db executeQuery:@"select * from whs_config_data  group by save_time"];
            while ([lfmdb next]) {
                [alist_result addObject:[lfmdb resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
}
- (BOOL)fn_delete_all_data{
    __block BOOL ib_deleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            ib_deleted=[db executeUpdate:@"delete from whs_config_header"];
            ib_deleted=[db executeUpdate:@"delete from whs_upload_col"];
            [db close];
        }
    }];
    return ib_deleted;
}
@end
