//
//  Web_base.h
//  worldtrans
//
//  Created by itdept on 3/25/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadContract.h"
#import "UploadGPSContract.h"
typedef void (^callBack_resp_result)(NSMutableArray* arr);
@interface Web_base : NSObject

@property (strong, nonatomic) callBack_resp_result callBack;
@property (strong, nonatomic) NSString *il_url;//路径

@property (strong, nonatomic) Class iresp_class;//映射对象类
@property (strong, nonatomic) Class iresp_class1;//嵌套

@property (strong, nonatomic) NSArray *ilist_resp_mapping;//结果
@property (strong, nonatomic) NSArray *ilist_resp_mapping1;//嵌套
@property (strong, nonatomic) NSMutableArray *ilist_resp_result;//返回结果
//NetWorking Request
- (void) fn_get_data:(RequestContract*)ao_form base_url:(NSString*)base_url;

- (void) fn_get_chart_data:(RequestContract *)ao_form base_url:(NSString *)base_url;

- (void) fn_get_exso_data:(RequestContract *)ao_form base_url:(NSString *)base_url;
- (void) fn_get_whs_config_data:(RequestContract *)ao_form base_url:(NSString*)base_url;

- (void) fn_get_order_list_data:(RequestContract *)ao_form base_url:(NSString*)base_url;

//Uploading Data
- (void) fn_uploaded_data:(UploadContract*)ao_form base_url:(NSString*)base_url;

- (void) fn_uploaded_GPS:(UploadGPSContract*)ao_form base_url:(NSString*)base_url;
- (void) fn_uploaded_warehouse_receive_data:(UploadGPSContract*)ao_form base_url:(NSString*)base_url;
@end
