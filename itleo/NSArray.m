//
//  NSArray.m
//  worldtrans
//
//  Created by itdept on 14-3-26.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "NSArray.h"

@implementation NSArray(ArrayWithObject)
+(NSArray *) arrayWithPropertiesOfObject:(id) obj{
    NSMutableArray *arr=[NSMutableArray array];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [arr addObject:key];
    }
    
    free(properties);
    
    return [NSArray arrayWithArray:arr];
}
+(NSArray *) arrayWithPropertiesValueOfObject:(id) obj{
    NSMutableArray *arr=[NSMutableArray array];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([obj valueForKey:key]==nil) {
            [arr addObject:@""];
        }else{
            [arr addObject:[obj valueForKey:key]];
        }
       
    }
    free(properties);
    return [NSArray arrayWithArray:arr];
}
+ (NSArray *)arrayWithPropertiesOfObject_withoutNil:(id) obj{
    NSMutableArray *arr=[NSMutableArray array];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([obj valueForKey:key]!=nil) {
            [arr addObject:key];
        }
    }
    free(properties);
    return [NSArray arrayWithArray:arr];
}

@end
