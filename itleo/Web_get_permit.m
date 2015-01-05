//
//  Web_get_permit.m
//  itleo
//
//  Created by itdept on 14-11-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_get_permit.h"
#import "Web_base.h"
#import "Resp_permit.h"
#import "Resp_get_status.h"
#import "DB_LoginInfo.h"
#import "DB_permit.h"
#import "DB_ePod.h"
@implementation Web_get_permit

-(void)fn_get_permit_data:(NSString*)base_url callBack:(call_isGetPermit)call_back{
    RequestContract *ao_form=[[RequestContract alloc]init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    auth.company_code=COMPANY_CODE;
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
-(NSMutableArray*)fn_get_function_module{
    DB_permit *db_permit=[[DB_permit alloc]init];
    NSMutableArray *alist_result=[db_permit fn_get_permit_data];
    NSMutableArray *alist_function=[[NSMutableArray alloc]initWithCapacity:1];
    for (NSMutableDictionary *dic in alist_result) {
        NSMutableDictionary *idic_result=[[NSMutableDictionary alloc]initWithCapacity:1];
        NSString *module_unique_i=[Conversion_helper fn_cut_whitespace:[dic valueForKey:@"module_unique_id"]] ;
        NSString *module_code=[Conversion_helper fn_cut_whitespace:[dic valueForKey:@"module_code"]];
        if ([module_unique_i isEqualToString:@"SYS"]==NO) {
            NSString *f_exec=[dic valueForKey:@"f_exec"];
            [idic_result setObject:module_code forKey:@"module_code"];
            [idic_result setObject:f_exec forKey:@"f_exec"];
            [alist_function addObject:idic_result];
        }
        idic_result=nil;
    }
    return alist_function;
}
//GET EPOD STATUS
-(void)fn_get_epod_status_data:(NSString*)base_url{
    RequestContract *ao_form=[[RequestContract alloc]init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    auth.company_code=COMPANY_CODE;
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
