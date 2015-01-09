//
//  Web_get_exso.m
//  itleo
//
//  Created by itdept on 14-12-8.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_get_exso.h"
#import "Resp_exso.h"
#import "DB_RespAppConfig.h"
#import "DB_LoginInfo.h"
@implementation Web_get_exso

-(void)fn_get_exso_data:(NSString*)so_no{
    RequestContract *req_form=[[RequestContract alloc]init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    req_form.Auth=auth;
    db_login=nil;
    SearchFormContract *searchForm=[[SearchFormContract alloc]init];
    searchForm.os_column=@"so_no";
    searchForm.os_value=so_no;
    req_form.SearchForm=[NSSet setWithObject:searchForm];
    searchForm=nil;
    Web_base *web_obj=[[Web_base alloc]init];
    web_obj.il_url=STR_EXSO_URL;
    web_obj.iresp_class=[Resp_exso class];
    web_obj.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[Resp_exso class]];
    
    web_obj.callBack=^(NSMutableArray* arr_resp_result){
        if (_callBack_exso) {
            _callBack_exso(arr_resp_result);
        }
    };
    DB_RespAppConfig *db_obj=[[DB_RespAppConfig alloc]init];
    NSString *str_base_url=[db_obj fn_get_field_content:kWeb_addr];
    db_obj=nil;
    [web_obj fn_get_exso_data:req_form Auth:auth base_url:str_base_url];
    str_base_url=nil;
    auth=nil;
    req_form=nil;
    web_obj=nil;
}
@end
