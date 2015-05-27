//
//  settings_dataModel.h
//  itleo
//
//  Created by itdept on 15/5/22.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SWITCH_FUNCTION 1
#define SELECT_INTERVAL 2

@interface settings_dataModel : NSObject

@property (nonatomic, copy) NSString *promptStr;

@property (nonatomic, copy) NSString *intervalStr;

@property (nonatomic, assign) BOOL switch_isOn;

@property (nonatomic, assign) NSInteger flag_settings_type;


+ (settings_dataModel*)fn_get_settings_dataModel:(NSString*)prompt_str interval:(NSString*)interval_str type:(NSInteger)settings_type switch_isOn:(BOOL)switch_isOn;

@end
