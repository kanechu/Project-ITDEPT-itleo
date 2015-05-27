//
//  IsAuto_upload_data.m
//  itleo
//
//  Created by itdept on 14-9-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "IsAuto_upload_data.h"
#import "DB_ePod.h"
#import "DB_Location.h"
#import "DB_LoginInfo.h"
#import "Web_update_epod.h"
#import "Epod_upd_milestone_image_contract.h"
#import "Resp_upd_image_result.h"
#import "RespEpod_updmilestone.h"
#import "Resp_upd_GPS.h"
#import "CheckNetWork.h"
static NSDate *flag_record_date=nil;
static NSDate *flag_GPS_date=nil;
@implementation IsAuto_upload_data

-(void)fn_Automatically_upload_data{
    NSDate *current_day=[NSDate date];
    if (flag_record_date==nil) {
        flag_record_date=current_day;
    }else{
        NSTimeInterval time_interval=[current_day timeIntervalSinceDate:flag_record_date];
        time_interval=(NSInteger)time_interval+1;
        if (time_interval<[self fn_get_timeInterval]) {
            /**
             *  用于计算是否已经相隔用户设置的时间，如果不是返回
             */
            return;
        }else{
            flag_record_date=current_day;
        }
    }
    CheckNetWork *netWork_obj=[[CheckNetWork alloc]init];
    if ([netWork_obj fn_check_isNetworking]) {
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

-(void)fn_Auto_upload_GPS{
    NSDate *current_day=[NSDate date];
    if (flag_GPS_date==nil) {
        flag_GPS_date=current_day;
    }else{
        NSTimeInterval time_interval=[current_day timeIntervalSinceDate:flag_GPS_date];
        time_interval=(NSInteger)time_interval+1;
        if (time_interval<[self fn_get_timeInterval]) {
            /**
             *  用于计算是否已经相隔用户设置的时间，如果不是返回
             */
            return;
        }else{
            flag_GPS_date=current_day;
        }
    }
    
    CheckNetWork *netWork_obj=[[CheckNetWork alloc]init];
    if ([netWork_obj fn_check_isNetworking]) {
        DB_Location *db_location=[[DB_Location alloc]init];
        NSMutableArray *alist_gps=[db_location fn_get_location_data:@"0"];
        DB_LoginInfo *db_login=[[DB_LoginInfo alloc]init];
        AuthContract *auth=[db_login fn_get_RequestAuth];
        NSMutableArray *arr_form=[[NSMutableArray alloc]init];
        for (NSMutableDictionary *idic in alist_gps) {
            UpdateFormContract_GPS *updateform=[[UpdateFormContract_GPS alloc]init];
            updateform.unique_id=[idic valueForKey:@"id_t"];
            updateform.car_no=[idic valueForKey:@"car_no"];
            updateform.longitude=[[idic valueForKey:@"longitude"]floatValue];
            updateform.latitude=[[idic valueForKey:@"latitude"]floatValue];
            updateform.log_date=[idic valueForKey:@"log_date"];
            [arr_form addObject:updateform];
        }
        if ([arr_form count]!=0) {
            Web_update_epod *upd_obj=[[Web_update_epod alloc]init];
            [upd_obj fn_upload_epod_GPS:arr_form Auth:auth back_result:^(NSMutableArray *alist_result){
                for (Resp_upd_GPS *resp_obj in alist_result) {
                    if ([resp_obj.status isEqualToString:@"true"]) {
                        [db_location fn_update_isUploaded_status:resp_obj.unique_id isUploaded:@"1"];
                    }
                }
            }];
            
        }
    }

}
#pragma mark -get upload time interval
-(CGFloat)fn_get_timeInterval{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *key=[userDefault objectForKey:SETTINGS_ORDER_INTERVAL];
    CGFloat timeInerval=[self fn_Auto_Sync_timeInterval:key];
    return timeInerval;
}

-(CGFloat)fn_Auto_Sync_timeInterval:(NSString*)key{
    CGFloat interval=0.0f;
   if ([key isEqualToString:@"lbl_minute"]){
        interval=60.0f;
    }else if ([key isEqualToString:@"lbl_2minutes"]){
        interval=2*60.0f;
    }else if ([key isEqualToString:@"lbl_3minutes"]){
        interval=3*60.0f;
    }else if ([key isEqualToString:@"lbl_5minutes"]){
        interval=5*60.0f;
    }else if ([key isEqualToString:@"lbl_10minutes"]){
        interval=10*60.0f;
    }else if ([key isEqualToString:@"lbl_30minutes"]){
        interval=30*60.0f;
    }else if ([key isEqualToString:@"lbl_hour"]){
        interval=60*60.0f;
    }
    return interval;
}

@end
