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
@implementation Web_get_exso

-(void)fn_get_exso_data:(NSString*)so_no{
    RequestContract *req_form=[[RequestContract alloc]init];
    AuthContract *auth=[[AuthContract alloc]init];
#warning - neet fix
    auth.user_code=@"sa";
    auth.password=@"bugfree12";
    auth.company_code=COMPANY_CODE;
    auth.system=@"PHP_ENSIGN";
    req_form.Auth=auth;
    SearchFormContract *searchForm=[[SearchFormContract alloc]init];
    searchForm.os_column=@"so_no";
    searchForm.os_value=so_no;
    req_form.SearchForm=[NSSet setWithObject:searchForm];
    Web_base *web_obj=[[Web_base alloc]init];
    web_obj.il_url=STR_EXSO_URL;
    web_obj.iresp_class=[Resp_exso class];
    web_obj.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[Resp_exso class]];
    
    web_obj.callBack=^(NSMutableArray* arr_resp_result){
        if (_callBack_exso) {
            _callBack_exso(arr_resp_result);
        }
        
    };
    /*
     DB_RespAppConfig *db_obj=[[DB_RespAppConfig alloc]init];
     NSMutableArray *alist_result=[db_obj fn_get_all_RespAppConfig_data];
     if ([alist_result count]!=0) {
     NSString *str_base_url=[[alist_result objectAtIndex:0]valueForKey:@"web_addr"];
     
     }*/
#warning -neet fix
    NSString *str_base_url=@"http://192.168.1.17/kie_web_api/";
    [web_obj fn_get_data:req_form base_url:str_base_url];
}
@end
