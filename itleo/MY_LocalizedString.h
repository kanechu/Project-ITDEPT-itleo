//
//  MY_LocalizedString.h
//  itleo
//
//  Created by itdept on 14-10-7.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MY_LocalizedString(key, comment) \
[[MY_LocalizedString getshareInstance] get:(key) alter:(comment)]
@interface MY_LocalizedString : NSObject

+ (MY_LocalizedString*)getshareInstance;
- (void)fn_setLanguage_type:(NSString *)language;
- (NSString*)getCurrentLanguage;
- (NSString *)get:(NSString *)key alter:(NSString *)alternate;
@end
