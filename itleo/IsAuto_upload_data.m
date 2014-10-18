//
//  IsAuto_upload_data.m
//  itleo
//
//  Created by itdept on 14-9-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "IsAuto_upload_data.h"
#import "DB_ePod.h"
#import "Reachability/Reachability.h"
#import "Web_update_epod.h"
#import "UpdateFormContract.h"
#import "Epod_upd_milestone_image_contract.h"
#import "Resp_upd_image_result.h"
#import "RespEpod_updmilestone.h"
@implementation IsAuto_upload_data
-(BOOL)fn_check_isNetworking{
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus!=NotReachable)||([Reachability reachabilityForLocalWiFi].currentReachabilityStatus!=NotReachable)) {
        return YES;
    }else{
        return NO;
    }
}
-(void)fn_Automatically_upload_data{
    if ([self fn_check_isNetworking]) {
        DB_ePod *db=[[DB_ePod alloc]init];
        NSMutableArray *arr_result=[db fn_select_unUpload_ePod_data:@"0"];
        NSMutableArray *arr_group=[db fn_select_unUpload_ePod_data_amount:@"0"];
        for (NSMutableDictionary *dic in arr_group) {
            NSString *order_no=[dic valueForKey:@"order_no"];
            NSString *vehicle_no=[dic valueForKey:@"vehicle_no"];
            NSString *status=[dic valueForKey:@"status"];
            NSString *unique_id=[dic valueForKey:@"unique_id"];
            
            UpdateFormContract *updateform=[[UpdateFormContract alloc]init];
            updateform.unique_id=unique_id;
            updateform.order_no=order_no;
            updateform.vehicle_no=vehicle_no;
            updateform.ms_status=status;
            NSMutableArray *arr_image=[NSMutableArray array];
            AuthContract *auth=[[AuthContract alloc]init];
            int i=0;
            for (NSMutableDictionary *dic_sub in arr_result) {
                NSString *order_no1=[dic_sub valueForKey:@"order_no"];
                NSString *vehicle_no1=[dic_sub valueForKey:@"vehicle_no"] ;
                if ([order_no isEqualToString:order_no1] && [vehicle_no isEqualToString:vehicle_no1]) {
                    auth.user_code=[dic_sub valueForKey:@"user_code"];
                    auth.password=[dic_sub valueForKey:@"password"];
                    auth.system=[dic_sub valueForKey:@"system_name"];
                    auth.version=[dic_sub valueForKey:@"version"];
                    Epod_upd_milestone_image_contract *upd_imageForm=[[Epod_upd_milestone_image_contract alloc]init];
                    upd_imageForm.unique_id=[dic_sub valueForKey:@"img_unique_id"];
                    upd_imageForm.ms_upload_queue_id=[dic_sub valueForKey:@"correlation_id"];
                    upd_imageForm.ms_imgBase64=[dic_sub valueForKey:@"image"];
                    NSString *image_remark=[dic_sub valueForKey:@"image_remark"];
                    if ([image_remark length]!=0) {
                        upd_imageForm.img_remark=image_remark;
                    }
                    [arr_image addObject:upd_imageForm];
                }
                i++;
            }
            updateform.Epod_upd_milestone_image=[NSSet setWithArray:arr_image];
            Web_update_epod *upload=[[Web_update_epod alloc]init];
            [upload fn_upload_epod_data:updateform Auth:auth back_result:^(NSMutableArray* arr_result){
                if ([arr_result count]!=0) {
                    RespEpod_updmilestone *respEpod=[arr_result objectAtIndex:0];
                    NSSet *resp_upd_images=respEpod.Epod_upd_milestone_image_Result;
                    NSString *unique_id=respEpod.unique_id;
                    NSString *is_upload_sucess=respEpod.is_upload_sucess;
                    NSString *upload_date=respEpod.upload_date;
                    NSString *error_reason=respEpod.error_reason;
                    NSString *error_date=respEpod.error_date;
                    if ([is_upload_sucess isEqualToString:@"true"]) {
                         [db fn_update_epod_after_uploaded:unique_id is_uploaded:@"1" date:upload_date result:@"isuccess" user_code:auth.user_code system:auth.system  images:resp_upd_images];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"upload_success" object:nil];                       
                    }else{
                        [db fn_update_epod_after_uploaded:unique_id is_uploaded:@"2" date:error_date result:error_reason user_code:auth.user_code system:auth.system  images:resp_upd_images];
                    }
                }

            }];
            
        }
    }
}
@end
