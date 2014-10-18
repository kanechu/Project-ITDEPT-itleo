//
//  MY_LocalizedString.m
//  itleo
//
//  Created by itdept on 14-10-7.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "MY_LocalizedString.h"
static NSBundle *bundle = nil;
@implementation MY_LocalizedString
+(MY_LocalizedString*)getshareInstance{
    static dispatch_once_t pred=0;
    __strong static MY_LocalizedString* Localize=nil;
    dispatch_once(&pred, ^{
        Localize=[[self alloc]init];
        
    });
    return Localize;
}
- (void)fn_setLanguage_type:(NSString *)language{
    NSString *path = [[ NSBundle mainBundle ] pathForResource:language ofType:@"lproj" ];
    if (!path) {
        path = [[ NSBundle mainBundle ] pathForResource:@"en" ofType:@"lproj" ];
        //[self resetLocalization];
    }
    bundle = [NSBundle bundleWithPath:path];
}
- (NSString*)getCurrentLanguage{
    NSArray *langArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"];
    return langArray[0];
}
- (NSString *)get:(NSString *)key alter:(NSString *)alternate{
    return [bundle localizedStringForKey:key value:alternate table:@"Localized"];
}
@end
