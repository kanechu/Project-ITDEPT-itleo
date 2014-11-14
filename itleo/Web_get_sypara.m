//
//  Web_get_sypara.m
//  worldtrans
//
//  Created by itdept on 14-10-22.
//  Copyright (c) 2014年 Worldtrans Logistics Services Ltd. . All rights reserved.
//

#import "Web_get_sypara.h"
#import "Resp_sypara.h"
#import "Web_base.h"
#import "DB_sypara.h"
#import "DB_RespAppConfig.h"
#import "DB_LoginInfo.h"
#import "Conversion_helper.h"
@implementation Web_get_sypara

-(void)fn_get_sypara_data{
    
    RequestContract *req_form = [[RequestContract alloc] init];
    DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_login fn_get_RequestAuth];
    auth.encrypted=@"0";
    req_form.Auth =auth;
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_SYPARA_URL;
    web_base.iresp_class=[Resp_sypara class];
    web_base.ilist_resp_mapping =[NSArray arrayWithPropertiesOfObject:[Resp_sypara class]];
    web_base.callBack=^(NSMutableArray *alist_result){
        [self fn_save_sypara:alist_result];
    };
    DB_RespAppConfig *db=[[DB_RespAppConfig alloc]init];
    NSMutableArray *arr=[db fn_get_all_RespAppConfig_data];
    if ([arr count]!=0) {
        NSString *base_url=[[arr objectAtIndex:0]valueForKey:@"web_addr"];    [web_base fn_get_data:req_form base_url:base_url];
    }
}
-(void)fn_save_sypara:(NSMutableArray*)alist_result{
    if ([alist_result count]!=0) {
        DB_sypara *db_sypara=[[DB_sypara alloc]init];
        [db_sypara fn_save_sypara_data:alist_result];
    }
}
-(NSInteger)fn_isShow_GPS_function{
    NSInteger flag=0;
    DB_sypara *db_sypara=[[DB_sypara alloc]init];
    NSMutableArray *alist_sypara=[db_sypara fn_get_sypara_data];
    for (NSMutableDictionary *dic in alist_sypara) {
        NSString *para_code=[Conversion_helper fn_cut_whitespace:[dic valueForKey:@"para_code"]];
        NSString *data1=[dic valueForKey:@"data1"];
        if ([para_code isEqualToString:@"ANDRDRECGPS"] && [data1 isEqualToString:@"1"]) {
            flag=1;
        }
    }
    return flag;
}
@end