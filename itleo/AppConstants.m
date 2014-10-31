//
//  AppConstants.m
//  worldtrans
//
//  Created by itdept on 2/27/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import "AppConstants.h"

#ifdef DEBUG 
NSString* const STR_BASE_URL = @"http://demo.itdept.com.hk/";
NSString* const STR_APP_CONFIG_URL=@"itcrm_web_api/api/System/app_config";

//这部分是固定的，用户选择系统登陆后，会返回一个基本的路径，与其拼接
NSString* const STR_AEJOB_BROWSE_URL=@"api/Search/aejob_browse";
NSString* const STR_AEJOB_DTL_BROWSE_URL=@"api/Search/aejob_dtl_browse";
NSString* const STR_LOGIN_URL=@"api/users/login";
NSString* const STR_SYPARA_URL=@"api/System/sypara";

NSString* const STR_EPOD_UPLOAD_URL=@"api/epod/updmilestone2";
NSString* const STR_EPOD_ORDER_INFO_URL=@"api/Epod/get_order_info"; NSString* const STR_UPD_GPS_URL=@"api/epod/upd_gps";
#else
NSString* const STR_BASE_URL = @"http://223.255.167.158/";
#endif