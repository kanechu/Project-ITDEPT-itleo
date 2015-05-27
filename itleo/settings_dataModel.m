//
//  settings_dataModel.m
//  itleo
//
//  Created by itdept on 15/5/22.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "settings_dataModel.h"

@implementation settings_dataModel

@synthesize promptStr;
@synthesize intervalStr;
@synthesize flag_settings_type;

+ (settings_dataModel*)fn_get_settings_dataModel:(NSString*)prompt_str interval:(NSString*)interval_str type:(NSInteger)settings_type switch_isOn:(BOOL)switch_isOn{
    settings_dataModel *dataModel_obj=[[self alloc]init];
    dataModel_obj.promptStr=prompt_str;
    dataModel_obj.intervalStr=interval_str;
    dataModel_obj.flag_settings_type=settings_type;
    dataModel_obj.switch_isOn=switch_isOn;
    return dataModel_obj;
}

@end
