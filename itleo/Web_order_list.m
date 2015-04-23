//
//  Web_order_list.m
//  itleo
//
//  Created by itdept on 15/4/18.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "Web_order_list.h"
#import "Web_base.h"
#import "Resp_order_dtl_list.h"
#import "Resp_epod_order_list.h"
#import "Resp_order_list.h"
#import "DB_LoginInfo.h"
#import "DB_order.h"
#import "DB_RespAppConfig.h"
#import "UpdateForm_orderList.h"

#define ACTIONTYPE_GET_ALL @"get_order_list_all"
#define ACTIONTYPE_GET @"get_order_list"
#define ACTIONTYPE_CONFIRM @"get_order_list_confirm"
#define ACTIONTYPE_SEE @"isee"

@implementation Web_order_list

-(void)fn_handle_order_list_data:(NSSet*)set_uid_list type:(kAction_type)action_type{
    RequestContract *req_form=[[RequestContract alloc]init];
    
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    req_form.Auth=auth;
    db_login=nil;
    
    UpdateForm_orderList *updateForm_obj=[[UpdateForm_orderList alloc]init];
    updateForm_obj.ls_driver_code=auth.user_code;
    updateForm_obj.ls_uid_list=set_uid_list;
    if (action_type==kGet_order_list) {
        updateForm_obj.ls_action=ACTIONTYPE_GET;
    }
    if (action_type==kConfirm_order_list) {
        updateForm_obj.ls_action=ACTIONTYPE_CONFIRM;
    }
    if (action_type==kCheck_order_list) {
        updateForm_obj.ls_action=ACTIONTYPE_SEE;
    }
    if (action_type==kGet_all_order) {
        updateForm_obj.ls_action=ACTIONTYPE_GET_ALL;
    }
    req_form.UpdateForm=updateForm_obj;
    
    Web_base *web_obj=[[Web_base alloc]init];
    web_obj.il_url=STR_ORDER_LIST_URL;
    web_obj.iresp_class=[Resp_epod_order_list class];
    web_obj.iresp_class1=[Resp_order_list class];
    
    NSMutableArray *arr_epod_order=[[NSArray arrayWithPropertiesOfObject:[Resp_epod_order_list class]]mutableCopy];
    [arr_epod_order removeLastObject];
    
    NSMutableArray *arr_order_list=[[NSArray arrayWithPropertiesOfObject:[Resp_order_list class]]mutableCopy];
    [arr_order_list removeLastObject];
    
    web_obj.ilist_resp_mapping=arr_epod_order;
    web_obj.ilist_resp_mapping1=arr_order_list;
    
    web_obj.callBack=^(NSMutableArray* arr_resp_result){
        if (action_type==kGet_order_list) {
            [self fn_set_order_isSycn_download:arr_resp_result];
        }
        if (action_type==kCheck_order_list) {
            [self fn_set_order_isSync_read:arr_resp_result];
        }
    };
   arr_epod_order=nil;
    DB_RespAppConfig *db_appConfig=[[DB_RespAppConfig alloc]init];
    NSString *str_base_url=[db_appConfig fn_get_field_content:kWeb_addr];
    [web_obj fn_get_order_list_data:req_form Auth:auth base_url:str_base_url];
    db_appConfig=nil;
    str_base_url=nil;
    req_form=nil;
    auth=nil;
    web_obj=nil;
}
- (void)fn_set_order_isSycn_download:(NSMutableArray*)alist_result{
    DB_order *db_order_obj=[[DB_order alloc]init];
    BOOL isSaved=[db_order_obj fn_save_epod_order_data:alist_result];
    if (isSaved) {
        NSSet *arr_uid=[db_order_obj fn_get_all_order_uid];
        [self fn_handle_order_list_data:arr_uid type:kConfirm_order_list];
        arr_uid=nil;
    }
    
}
- (void)fn_set_order_isSync_read:(NSMutableArray*)alist_result{
     DB_order *db_order_obj=[[DB_order alloc]init];
    for (Resp_epod_order_list *epod_orderList_obj in alist_result) {
        NSArray *alist_order_list=epod_orderList_obj.ls_order_list;
        for (Resp_order_list *orderList_obj in alist_order_list) {
            NSString *str_order_uid=orderList_obj.order_uid;
            if ([str_order_uid length]!=0) {
                [db_order_obj fn_update_order_isSync_read:@"1" order_uid:str_order_uid];
            }
        }
    }
}

@end
