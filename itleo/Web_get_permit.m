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
#import "DB_LoginInfo.h"
#import "DB_permit.h"
#import "Conversion_helper.h"
@implementation Web_get_permit

-(void)fn_get_permit_data:(NSString*)base_url callBack:(call_isGetPermit)call_back{
    RequestContract *ao_form=[[RequestContract alloc]init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    auth.system=@"ITNEW";//备注，这里先写死，日后记住改过来
    base_url=@"http://192.168.1.17/kie_web_api/";//这里也先写死，日后记住改过来
    auth.app_code=APP_CODE;
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
        [db_permit fn_save_permit_data:alist_arr];
        if (call_back) {
            call_back(YES);
        }
    };
    [web_base fn_get_data:ao_form base_url:base_url];
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
    }
    return alist_function;
}
@end
