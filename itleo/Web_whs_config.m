//
//  Web_get_whs_config.m
//  itleo
//
//  Created by itdept on 14-12-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_whs_config.h"
#import "Web_base.h"
#import "DB_LoginInfo.h"
#import "DB_whs_config.h"
#import "Resp_whs_config.h"
#import "Resp_MaintForm.h"

#define STR_POST_BOUNDARY @"------7d33a816d302b6"

@implementation Web_whs_config

-(void)fn_get_whs_config_data:(NSString*)base_url{
    RequestContract *req_form=[[RequestContract alloc]init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    
    AuthContract *auth=[db_login fn_get_RequestAuth];
#warning neet to modify
    auth.system=@"ITNEW";
    req_form.Auth=auth;
    Web_base *web_obj=[[Web_base alloc]init];
    web_obj.il_url=STR_WHS_CONFIG_URL;
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
            [db_whs fn_save_whs_config_data:arr_resp_result];
        }
        db_whs=nil;
    };
    arr_maintform=nil;
    [web_obj fn_get_whs_config_data:req_form Auth:auth base_url:base_url];
    req_form=nil;
    auth=nil;
    db_login=nil;
    web_obj=nil;
}

#pragma mark -post multipart form data to server

-(void)fn_post_multipart_formData_to_server:(NSDictionary*)dic_parameters completionHandler:(callBack_dic)callBack{
    NSURLRequest *urlRequest=[self fn_create_urlrequest:dic_parameters];
    NSURLResponse *response=nil;
    NSError *error=nil;
    NSData *reciveData=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (error) {
        NSLog(@"出现异常%@",error);
    }else{
        NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse*)response;
        if (httpResponse.statusCode==200) {
            NSMutableDictionary *dic_result=[NSJSONSerialization JSONObjectWithData:reciveData options:NSJSONReadingMutableLeaves error:nil];
            if (callBack) {
                callBack(dic_result);
            }
        }
    }
}

-(NSMutableURLRequest*)fn_create_urlrequest:(NSDictionary *)dic_parameters{
    //附加的stringByAddingPercentEscapesUsingEncoding：是为了保证url字符串有效。
    NSURL *url=[NSURL URLWithString:[_str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *urlRequest=[[NSMutableURLRequest alloc]initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",STR_POST_BOUNDARY];
    //设置内容的类型
    [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:[self fn_get_HTTPPOSTMultipartBodyWithParameters:dic_parameters]];
    return urlRequest;
}
- (NSData*)fn_get_HTTPPOSTMultipartBodyWithParameters:(NSDictionary*)dic_parameters{
    NSMutableData *body = [NSMutableData data];
    
    // Add Main Body
    for (NSString *key in [dic_parameters allKeys]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",STR_POST_BOUNDARY]dataUsingEncoding:NSUTF8StringEncoding]];
        
        id value = [dic_parameters objectForKey:key];
        
        if ([value isKindOfClass:[NSString class]]){
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;name=\"%@\"\r\n\r\n%@\r\n",key,value]dataUsingEncoding:NSUTF8StringEncoding]];
            
        }else {
            NSLog(@"please use addMultiPartData:withName:type:filename: Methods to implement");
        }
    }
    return body;
}

@end
