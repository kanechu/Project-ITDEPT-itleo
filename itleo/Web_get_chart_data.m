//
//  Web_get_chart_data.m
//  itleo
//
//  Created by itdept on 14-11-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_get_chart_data.h"
#import "Web_base.h"
#import "DB_LoginInfo.h"
#import "DB_Chart.h"
#import "Conversion_helper.h"

@implementation Web_get_chart_data

- (void) fn_get_chart_data:(NSString*)base_url uid:(NSString*)unique_id type:(RequestType)requestType{
    unique_id=[Conversion_helper fn_cut_whitespace:unique_id];
    RequestContract *request_form=[[RequestContract alloc]init];
    DB_LoginInfo *login_obj=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[login_obj fn_get_RequestAuth];
    auth.app_code=APP_CODE;
    auth.system=@"ITNEW";
    request_form.Auth=auth;
#warning neet fix
    base_url=@"http://192.168.1.17/kie_web_api/";//这里也先写死，日后记住改过来
    if (requestType==kRequestAll) {
        SearchFormContract *searchform=[[SearchFormContract alloc]init];
        searchform.os_column=@"type";
        searchform.os_value=@"ALL";
        request_form.SearchForm=[NSSet setWithObject:searchform];
    }
    if (requestType==kRequestOne) {
        SearchFormContract *searchform=[[SearchFormContract alloc]init];
        searchform.os_column=@"type";
        searchform.os_value=@"CHART";
        SearchFormContract *searchform1=[[SearchFormContract alloc]init];
        searchform1.os_column=@"uid";
        searchform1.os_value=unique_id;
        request_form.SearchForm=[NSSet setWithObjects:searchform,searchform1, nil];
    }
    
    Web_base *web_obj=[[Web_base alloc]init];
    web_obj.il_url=STR_GET_CHART_URL;
    web_obj.callBack=^(NSMutableArray *arr_resp_result){
        DB_Chart *db=[[DB_Chart alloc]init];
        if (requestType==kRequestAll) {
            [db fn_delete_all_chart_data];
            [db fn_save_chart_data:arr_resp_result];
            if (_callBack) {
                _callBack();
            }
        }
        if (requestType==kRequestOne) {
            [db fn_update_chart_data:arr_resp_result uid:unique_id];
            if (_callBack) {
                _callBack();
            }
        }
        
    };
    [web_obj fn_get_chart_data:request_form Auth:auth base_url:base_url];
}

@end
