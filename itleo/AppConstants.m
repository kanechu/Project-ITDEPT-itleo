//
//  AppConstants.m
//  worldtrans
//
//  Created by itdept on 2/27/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import "AppConstants.h"

#ifdef DEBUG 
NSString* const STR_BASE_URL = @"http://demo.itdept.com.hk/itcrm_web_api/";
NSString* const STR_APP_CONFIG_URL=@"api/System/app_config";

//这部分是固定的，用户选择系统登陆后，会返回一个基本的路径，与其拼接
NSString* const STR_LOGIN_URL=@"api/users/login";
NSString* const STR_SYPARA_URL=@"api/System/sypara";
NSString* const STR_PERMIT_URL=@"api/Users/permit";

NSString* const STR_AEJOB_BROWSE_URL=@"api/Search/aejob_browse";
NSString* const STR_AEJOB_DTL_BROWSE_URL=@"api/Search/aejob_dtl_browse";

NSString* const STR_EPOD_UPLOAD_URL=@"api/epod/updmilestone2";
NSString* const STR_EPOD_ORDER_INFO_URL=@"api/Epod/get_order_info";
NSString* const STR_UPD_GPS_URL=@"api/epod/upd_gps";
NSString* const STR_EPOD_STATUS_URL=@"api/Epod/get_status";

NSString* const STR_GET_CHART_URL=@"api/System/get_chart";

NSString* const STR_EXSO_URL=@"api/Search/exso";
NSString* const STR_UPD_EXCFSDIM_URL=@"api/ct/upd_excfsdim";

NSString* const STR_WHS_CONFIG_URL=@"api/Search/whs_config";

NSString* const STR_ORDER_LIST_URL=@"api/epod/epod_get_order_list";

#else

NSString* const STR_BASE_URL = @"http://demo.itdept.com.hk/itcrm_web_api/";
NSString* const STR_APP_CONFIG_URL=@"api/System/app_config";

//这部分是固定的，用户选择系统登陆后，会返回一个基本的路径，与其拼接
NSString* const STR_LOGIN_URL=@"api/users/login";
NSString* const STR_SYPARA_URL=@"api/System/sypara";
NSString* const STR_PERMIT_URL=@"api/Users/permit";

NSString* const STR_AEJOB_BROWSE_URL=@"api/Search/aejob_browse";
NSString* const STR_AEJOB_DTL_BROWSE_URL=@"api/Search/aejob_dtl_browse";

NSString* const STR_EPOD_UPLOAD_URL=@"api/epod/updmilestone2";
NSString* const STR_EPOD_ORDER_INFO_URL=@"api/Epod/get_order_info";
NSString* const STR_UPD_GPS_URL=@"api/epod/upd_gps";
NSString* const STR_EPOD_STATUS_URL=@"api/Epod/get_status";

NSString* const STR_GET_CHART_URL=@"api/System/get_chart";

NSString* const STR_EXSO_URL=@"api/Search/exso";
NSString* const STR_UPD_EXCFSDIM_URL=@"api/ct/upd_excfsdim";

NSString* const STR_WHS_CONFIG_URL=@"api/Search/whs_config";

NSString* const STR_ORDER_LIST_URL=@"api/epod/epod_get_order_list";
#endif