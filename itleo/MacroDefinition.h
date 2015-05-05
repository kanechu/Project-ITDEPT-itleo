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
#define PARA_CODE_GPS @"ANDRDRECGPS"
#define PARA_DATA1 @"1"

//------permit , 控制用户拥有的权限------
#define MODULE_AIR_LOAD_PLAN @"AIR_LOAD_PLAN"
#define MODULE_EPOD @"EPOD"
#define MODULE_WHS_SUMMARY @"WHS_SUMMARY"
#define MODULE_CFSRECV @"CFSRECV"
#define MODULE_WAREHOUSE @"WAREHOUSE"
#define MODULE_F_EXEC @"1"

#endif
