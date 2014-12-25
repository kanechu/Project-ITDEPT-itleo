//
//  Web_get_whs_config.m
//  itleo
//
//  Created by itdept on 14-12-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_get_whs_config.h"
#import "Web_base.h"
#import "DB_LoginInfo.h"
#import "DB_whs_config.h"
#import "Resp_whs_config.h"
#import "Resp_MaintForm.h"
@implementation Web_get_whs_config

-(void)fn_get_whs_config_data:(NSString*)base_url{
    RequestContract *req_form=[[RequestContract alloc]init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    
    AuthContract *auth=[db_login fn_get_RequestAuth];
#warning -neet fix
    auth.company_code=@"ITNEW";
    auth.system=@"ITNEW";
    req_form.Auth=auth;
    Web_base *web_obj=[[Web_base alloc]init];
    web_obj.il_url=STR_WHS_CONFIG;
    web_obj.iresp_class=[Resp_whs_config class];
    web_obj.iresp_class1=[Resp_MaintForm class];
    NSMutableArray *arr_maintform=[[NSArray arrayWithPropertiesOfObject:[Resp_MaintForm class]]mutableCopy];
    [arr_maintform removeObjectAtIndex:0];
    [arr_maintform removeLastObject];
    web_obj.ilist_resp_mapping1=arr_maintform;
    
    web_obj.callBack=^(NSMutableArray* arr_resp_result){
        DB_whs_config *db_whs=[[DB_whs_config alloc]init];
        if ([arr_resp_result count]!=0) {
            [db_whs fn_delete_all_data];
        }
        [db_whs fn_save_whs_config_data:arr_resp_result];
        db_whs=nil;
    };
    arr_maintform=nil;
    [web_obj fn_get_whs_config_data:req_form Auth:auth base_url:base_url];
    req_form=nil;
    auth=nil;
    db_login=nil;
    web_obj=nil;
}
@end
