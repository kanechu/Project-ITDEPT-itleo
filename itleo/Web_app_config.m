//
//  Web_get_permit.m
//  itleo
//
//  Created by itdept on 14-11-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_app_config.h"
#import "Web_base.h"
#import "Web_get_chart_data.h"
#import "Resp_permit.h"
#import "Resp_get_status.h"
#import "Resp_sypara.h"
#import "DB_sypara.h"
#import "DB_LoginInfo.h"
#import "DB_permit.h"
#import "DB_ePod.h"

@implementation Web_app_config

-(void)fn_get_permit_data:(NSString*)base_url callBack:(call_isGetPermit)call_back{
    RequestContract *ao_form=[[RequestContract alloc]init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    ao_form.Auth=auth;
    SearchFormContract *searchform=[[SearchFormContract alloc]init];
    searchform.os_column=@"type";
    searchform.os_value=@"ALL";
    ao_form.SearchForm=[NSSet setWithObject:searchform];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_PERMIT_URL;
    web_base.iresp_class=[Resp_permit class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[Resp_permit class]];
    web_base.callBack=^(NSMutableArray *alist_arr){
        DB_permit *db_permit=[[DB_permit alloc]init];
        if ([alist_arr count]!=0) {
            //清除旧permit，存新的permit
            [db_permit fn_delete_all_permit_data];
            [db_permit fn_save_permit_data:alist_arr];
        }
        //如果存在chart功能，则请求chart数据
        if ([db_permit fn_isExist_module:MODULE_WHS_SUMMARY f_exec:MODULE_F_EXEC]) {
            Web_get_chart_data *web_chart=[Web_get_chart_data fn_shareInstance];
            [web_chart fn_get_chart_data:base_url uid:nil type:kRequestAll];
            web_chart.callBack=^(){
                [[Web_get_chart_data fn_shareInstance]fn_asyn_get_all_charts];
            };
        }
        if (call_back) {
            call_back(YES);
        }
        db_permit=nil;
    };
    [web_base fn_get_data:ao_form base_url:base_url];
    ao_form=nil;
    db_login=nil;
    web_base=nil;
}

-(void)fn_get_sypara_data:(NSString*)base_url{
    
    RequestContract *req_form = [[RequestContract alloc] init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    req_form.Auth =auth;
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_SYPARA_URL;
    web_base.iresp_class=[Resp_sypara class];
    web_base.ilist_resp_mapping =[NSArray arrayWithPropertiesOfObject:[Resp_sypara class]];
    web_base.callBack=^(NSMutableArray *alist_result){
        if ([alist_result count]!=0) {
            DB_sypara *db_sypara=[[DB_sypara alloc]init];
            [db_sypara fn_save_sypara_data:alist_result];
            db_sypara=nil;
        }
    };
    [web_base fn_get_data:req_form base_url:base_url];
    req_form=nil;
    db_login=nil;
    web_base=nil;
}

//GET EPOD STATUS
-(void)fn_get_epod_status_data:(NSString*)base_url{
    RequestContract *ao_form=[[RequestContract alloc]init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    ao_form.Auth=auth;
    SearchFormContract *searchform=[[SearchFormContract alloc]init];
    searchform.os_column=@"status_type";
    searchform.os_value=@"EPOD";
    ao_form.SearchForm=[NSSet setWithObject:searchform];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_EPOD_STATUS_URL;
    web_base.iresp_class=[Resp_get_status class];
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[Resp_get_status class]];
    web_base.callBack=^(NSMutableArray *arr_result){
        DB_ePod *db_epod=[[DB_ePod alloc]init];
        if ([arr_result count]!=0) {
            //清除旧epod status，存新的epod status
            [db_epod fn_delete_all_epod_status_data];
            [db_epod fn_save_epod_status_data:arr_result];
        }
       
        db_epod=nil;
    };
    [web_base fn_get_data:ao_form base_url:base_url];
    ao_form=nil;
    db_login=nil;
    web_base=nil;
}

@end
