//
//  DB_Chart.m
//  itleo
//
//  Created by itdept on 14-11-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_Chart.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "DatabaseQueue.h"
#import "Conversion_helper.h"
#import "Resp_get_chart.h"
#import "Resp_DashboardGrpResult.h"
#import "Resp_DashboardDtlResult.h"
#import "Resp_data.h"
@implementation DB_Chart
@synthesize queue;
-(id)init{
    self=[super init];
    if (self!=nil) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}

-(BOOL)fn_save_chart_data:(NSMutableArray*)alist_result{
    __block BOOL isUpdated=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            for (Resp_get_chart *chart in alist_result) {
                NSSet *alist_Grp=chart.DashboardGrpDResult;
                NSSet *alist_Dtl=chart.DashboardDtlResult;
                for (Resp_DashboardGrpResult *resp_Grp in alist_Grp) {
                    NSMutableDictionary *dic_Grp=[[NSDictionary dictionaryWithPropertiesOfObject:resp_Grp]mutableCopy];
                    isUpdated=[db executeUpdate:@"insert into DashboardGrpDResult(unique_id,grp_code,grp_desc,grp_title_en,grp_title_cn,grp_title_big5,rec_crt_usr,rec_upd_usr,rec_crt_date,rec_upd_date)values(:unique_id,:grp_code,:grp_desc,:grp_title_en,:grp_title_cn,:grp_title_big5,:rec_crt_usr,:rec_upd_usr,:rec_crt_date,:rec_upd_date)" withParameterDictionary:dic_Grp];
                }
                for (Resp_DashboardDtlResult *resp_Dtl in alist_Dtl) {
                    NSSet *alist_data=resp_Dtl.data;
                    NSString *unique_id=resp_Dtl.unique_id;
                    NSMutableDictionary *dic_Dtl=[[NSMutableDictionary dictionaryWithPropertiesOfObject:resp_Dtl]mutableCopy];
                    [dic_Dtl removeObjectForKey:@"data"];
                    isUpdated=[db executeUpdate:@"insert into DashboardDtlResult(unique_id,chart_seq,dhb_group_id,chart_title_en,chart_title_cn,chart_title_big5,chart_desc,chart_type,x_title_en,x_title_cn,x_title_big5,y_title_en,y_title_cn,y_title_big5,rec_crt_usr,rec_upd_usr,rec_crt_date,rec_upd_date)values(:unique_id,:chart_seq,:dhb_group_id,:chart_title_en,:chart_title_cn,:chart_title_big5,:chart_desc,:chart_type,:x_title_en,:x_title_cn,:x_title_big5,:y_title_en,:y_title_cn,:y_title_big5,:rec_crt_usr,:rec_upd_usr,:rec_crt_date,:rec_upd_date)" withParameterDictionary:dic_Dtl];
                    
                    for (Resp_data *resp_data in alist_data) {
                        NSMutableDictionary *dic_data=[[NSMutableDictionary dictionaryWithPropertiesOfObject:resp_data]mutableCopy];
                        [dic_data setObject:unique_id forKey:@"correlation_id"];
                        isUpdated=[db executeUpdate:@"insert into data(serie,x,y,correlation_id)values(:serie,:x,:y,:correlation_id)" withParameterDictionary:dic_data];
                    }
                }
                
            }
            [db close];
        }
    }];
    return isUpdated;
}
-(NSMutableArray*)fn_get_DashboardGrpDResult_data{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from DashboardGrpDResult"];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
}
-(NSMutableArray*)fn_get_DashboardDtlResult:(NSString*)group_id{
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb_result=[db executeQuery:@"select * from DashboardDtlResult where dhb_group_id like ?",group_id];
            while ([lfmdb_result next]) {
                [alist_result addObject:[lfmdb_result resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
    
}
-(NSMutableArray*)fn_get_data:(NSString*)unique_id{
    unique_id=[Conversion_helper fn_cut_whitespace:unique_id];
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb=[db executeQuery:@"select * from data where correlation_id like ? order by x",unique_id];
            while ([lfmdb next]) {
                [alist_result addObject:[lfmdb resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
}
-(NSMutableArray*)fn_get_xValues_data:(NSString*)unique_id{
    unique_id=[Conversion_helper fn_cut_whitespace:unique_id];
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb=[db executeQuery:@"select distinct x from data where correlation_id like ? order by x desc",unique_id];
            while ([lfmdb next]) {
                [alist_result addObject:[lfmdb stringForColumn:@"x"]];
            }
            [db close];
        }
    }];
    return alist_result;
}
-(NSMutableArray*)fn_get_distinct_Values:(NSString*) field unique_id:(NSString*)unique_id{
    unique_id=[Conversion_helper fn_cut_whitespace:unique_id];    
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            NSString *str_sql=[NSString stringWithFormat:@"select distinct %@ from data where correlation_id like ? order by x desc",field];
            FMResultSet *lfmdb=[db executeQuery:str_sql,unique_id];
            while ([lfmdb next]) {
                [alist_result addObject:[lfmdb stringForColumn:[NSString stringWithFormat:@"%@",field]]];
            }
            [db close];
        }
    }];
    return alist_result;
}
-(NSMutableArray*)fn_get_yValues:(NSString*)unique_id x:(NSString*)x serie:(NSString*)serie{
    unique_id=[Conversion_helper fn_cut_whitespace:unique_id];
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb=[db executeQuery:@"select y from data where correlation_id like ? and x like ? and serie like ?",unique_id,x,serie];
            while ([lfmdb next]) {
                [alist_result addObject:[lfmdb stringForColumn:@"y"]];
            }
            [db close];
        }
    }];
    return alist_result;
}

-(NSMutableArray*)fn_get_groupNameAndNum:(NSString*)unique_id{
    unique_id=[Conversion_helper fn_cut_whitespace:unique_id];
    __block NSMutableArray *alist_result=[NSMutableArray array];
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            FMResultSet *lfmdb=[db executeQuery:@"select serie,COUNT(serie) from data where correlation_id like ? group by serie",unique_id];
            while ([lfmdb next]) {
                [alist_result addObject:[lfmdb resultDictionary]];
            }
            [db close];
        }
    }];
    return alist_result;
}

-(BOOL)fn_delete_all_chart_data{
    __block BOOL isDeleted=NO;
    [queue inDataBase:^(FMDatabase *db){
        if ([db open]) {
            isDeleted=[db executeUpdate:@"delete from data"];
            isDeleted=[db executeUpdate:@"delete from DashboardDtlResult"];
            isDeleted=[db executeUpdate:@"delete from DashboardGrpDResult"];
            [db close];
        }
    }];
    return isDeleted;
}
@end
