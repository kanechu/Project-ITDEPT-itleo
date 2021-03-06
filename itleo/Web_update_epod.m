//
//  Web_update_epod.m
//  itleo
//
//  Created by itdept on 14-9-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_update_epod.h"
#import "Web_base.h"
#import "DB_LoginInfo.h"
#import "DB_RespAppConfig.h"
#import "RespEpod_updmilestone.h"
#import "Resp_upd_image_result.h"
#import "Resp_order_info.h"
#import "Resp_upd_GPS.h"
#import "UploadGPSContract.h"
@implementation Web_update_epod
@synthesize base_url;
-(id)init{
    self=[super init];
    if (self) {
        DB_RespAppConfig *db_appconfig=[[DB_RespAppConfig alloc]init];
        base_url=[db_appconfig fn_get_field_content:kWeb_addr];
    }
    return self;
}

#pragma mark -NetWork Resquest
- (void)fn_upload_epod_data:(UpdateFormContract*)updateform Auth:(AuthContract*)auth back_result:(callBack_result)call_back{
    UploadContract *upload_form=[[UploadContract alloc]init];
    upload_form.Auth=auth;
    upload_form.UpdateForm=updateform;
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_EPOD_UPLOAD_URL;
   
    web_base.iresp_class=[RespEpod_updmilestone class];
     NSMutableArray *arr_respEpod=[[NSArray arrayWithPropertiesOfObject:[RespEpod_updmilestone class]]mutableCopy];
    [arr_respEpod removeLastObject];
    web_base.ilist_resp_mapping=arr_respEpod;
    web_base.iresp_class1=[Resp_upd_image_result class];
    web_base.ilist_resp_mapping1=[NSArray arrayWithPropertiesOfObject:[Resp_upd_image_result class]];
    
    web_base.callBack=^(NSMutableArray *arr_resp_result){
        call_back(arr_resp_result);
    };
    [web_base fn_uploaded_data:upload_form base_url:base_url];
    web_base=nil;
}
//获取配置单的信息
- (void)fn_get_order_info:(NSMutableArray*)arr_searchforms back_result:(callBack_result)call_back{
    RequestContract *req_form=[[RequestContract alloc]init];
    DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db fn_get_RequestAuth];
    req_form.Auth=auth;
    req_form.SearchForm=[NSSet setWithArray:arr_searchforms];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_EPOD_ORDER_INFO_URL;
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[Resp_order_info class]];
    web_base.iresp_class=[Resp_order_info class];
    web_base.callBack=^(NSMutableArray* arr_resp_result){
        if (call_back) {
            call_back(arr_resp_result);
        }
    };
    [web_base fn_get_data:req_form base_url:base_url];
}
- (void)fn_upload_epod_GPS:(NSMutableArray*)updateform Auth:(AuthContract*)auth back_result:(callBack_result)call_back{
    UploadGPSContract *upload=[[UploadGPSContract alloc]init];
    upload.UpdateForm=[NSSet setWithArray:updateform];
    upload.Auth=auth;
    Web_base *web_obj=[[Web_base alloc]init];
    web_obj.il_url=STR_UPD_GPS_URL;
    web_obj.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[Resp_upd_GPS class]];
    web_obj.iresp_class=[Resp_upd_GPS class];
    web_obj.callBack=^(NSMutableArray* arr_resp_result){
        if (call_back) {
            call_back(arr_resp_result);
        }
    };
    [web_obj fn_uploaded_GPS:upload base_url:base_url];
    web_obj=nil;
}
@end
