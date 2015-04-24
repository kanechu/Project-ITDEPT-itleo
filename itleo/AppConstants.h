//
//  AppConstants.h
//  worldtrans
//
//  Created by itdept on 2/27/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_CODE  @"MOB_ITLEO" // 客户服务器那边用@"ITLEO"，因为没改成"MOB_ITLEO"
//获取itleo 设置的版本
#define VERSION [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleShortVersionString"]!=nil ? [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleShortVersionString"] : @"1.0"
#define ITLEO_VERSION [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleVersion"]!=nil ? [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleVersion"] : @"1.0"
#define IS_ENCRYPTED @"0"

#define SYSTEM_VERSION_GREATER_THAN_IOS8 ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

#define PARA_CODE_ORDERLIST @"MOB_EPOD_DL_ORD"
#define PARA_CODE_GPS @"ANDRDRECGPS"
#define PARA_DATA1 @"1"

@interface AppConstants : NSObject

extern NSString* const STR_BASE_URL;
extern NSString* const STR_APP_CONFIG_URL;
extern NSString* const STR_LOGIN_URL;
extern NSString* const STR_SYPARA_URL;
extern NSString* const STR_PERMIT_URL;
extern NSString* const STR_AEJOB_BROWSE_URL;
extern NSString* const STR_AEJOB_DTL_BROWSE_URL;
extern NSString* const STR_EPOD_UPLOAD_URL;
extern NSString* const STR_EPOD_ORDER_INFO_URL;
extern NSString* const STR_UPD_GPS_URL;
extern NSString* const STR_EPOD_STATUS_URL;
extern NSString* const STR_GET_CHART_URL;
extern NSString* const STR_EXSO_URL;
extern NSString* const STR_UPD_EXCFSDIM_URL;
extern NSString* const STR_WHS_CONFIG_URL;
extern NSString* const STR_ORDER_LIST_URL;
@end
