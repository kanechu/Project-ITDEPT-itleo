//
//  MacroDefinition.h
//  itleo
//
//  Created by itdept on 15/5/5.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#ifndef itleo_MacroDefinition_h
#define itleo_MacroDefinition_h

// 客户服务器那边用@"ITLEO"，因为没改成"MOB_ITLEO"
#define APP_CODE  @"MOB_ITLEO" 

//获取itleo 设置的版本
#define VERSION [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleShortVersionString"]!=nil ? [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleShortVersionString"] : @"1.0"
#define ITLEO_VERSION [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleVersion"]!=nil ? [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleVersion"] : @"1.0"

//授权的时候，是否对密码加密 0为不加密 1加密
#define IS_ENCRYPTED @"0"

//IOS8以上
#define SYSTEM_VERSION_GREATER_THAN_IOS8 ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
//--------检查系统版本--------
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//------sypara , 用于控制是否有该功能------
#define PARA_CODE_ORDERLIST @"MOB_EPOD_DL_ORD"
#define PARA_CODE_GPS @"MOB_REC_GPS"
#define PARA_DATA1 @"1"
#define PARA_DATA2 @"1"

//------permit , 控制用户拥有的权限------
#define MODULE_AIR_LOAD_PLAN @"AIR_LOAD_PLAN"
#define MODULE_EPOD @"EPOD"
#define MODULE_WHS_SUMMARY @"WHS_SUMMARY"
#define MODULE_CFSRECV @"CFSRECV"
#define MODULE_WAREHOUSE @"WAREHOUSE"
#define MODULE_F_EXEC @"1"

//右上角item间距
#define FIXSPACE 15
#define ITEM_LINE_WIDTH 1.5

//settings userDefault key
#define SETTINGS_DATE_RANGE @"date_range"
#define SETTINGS_ORDER_INTERVAL @"interval_range"
#define SETTINGS_GPS_INTERVAL @"GPS_interval_range"
#define SETTINGS_WHS_INTERVAL @"whs_interval_range"
#define SETTINGS_AUTO_UPLOAD_RECORD @"auto_transfer_record"
#define SETTINGS_AUTO_UPLOAD_GPS @"auto_transfer_GPS"
#define SETTINGS_AUTO_UPLOAD_WHS @"auto_upload_whs"

//--------自定义的颜色--------
#define COLOR_EERIE_BLACK [UIColor colorWithRed:27.0/255.0 green:27.0/255.0 blue:27.0/255.0 alpha:1]

#define COLOR_DARK_JUNGLE_GREEN [UIColor colorWithRed:26.0/255.0 green:36.0/255.0 blue:33.0/255.0 alpha:1]


#define COLOR_LAVENDER [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1]

#define COLOR_LIGHT_BLUE [UIColor colorWithRed:243.0/255.0 green:249.0/255.0 blue:253.0/255.0 alpha:1]

#define COLOR_LIGHT_GRAY [UIColor colorWithRed:255.0/255.0 green:251.0/255.0 blue:245.0/255.0 alpha:1]

#define COLOR_BITTER_LIME [UIColor colorWithRed:191.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1]

#define COLOR_DARK_BLUE [UIColor colorWithRed:65.0/255.0 green:95.0/255.0 blue:237.0/255.0 alpha:1]
#define COLOR_light_BLUE [UIColor colorWithRed:176.0/255.0 green:213.0/255.0 blue:251.0/255.0 alpha:1]

#define COLOR_LIGHT_YELLOW1 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:210.0/255.0 alpha:1]

#define COLOR_LIGTH_GREEN [UIColor colorWithRed:115.0/255.0 green:200.0/255.0 blue:152.0/255.0 alpha:1]
#define COLOR_LIGHT_BLUE1 [UIColor colorWithRed:221.0/255.0 green:251.0/255.0 blue:244.0/255.0 alpha:1]
#define COLOR_LIGHT_PINK [UIColor colorWithRed:255/255.0 green:251.0/255.0 blue:244.0/255.0 alpha:1]
#define COLOR_DARK_GREEN [UIColor colorWithRed:51/255.0 green:110.0/255.0 blue:109.0/255.0 alpha:1]
#define COLOR_DARK_GREEN1 [UIColor colorWithRed:58/255.0 green:135.0/255.0 blue:38.0/255.0 alpha:1]

#define COLOR_DARK_RED [UIColor colorWithRed:163/255.0 green:33.0/255.0 blue:13.0/255.0 alpha:1]

#endif
