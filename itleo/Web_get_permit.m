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
@implementation Web_get_permit

-(void)fn_get_permit_data:(NSString*)base_url{
    RequestContract *ao_form=[[RequestContract alloc]init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    auth.system=@"ITNEW";//备注，这里先写死，日后记住改过来
    base_url=@"http://192.168.1.17/kie_web_api/";//这里也先写死，日后记住改过来
    auth.app_code=@"ITLEO";
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
    };
    [web_base fn_get_data:ao_form base_url:base_url];
}

@end
