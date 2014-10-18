//
//  Conversion_helper.m
//  itleo
//
//  Created by itdept on 14-9-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Conversion_helper.h"

@implementation Conversion_helper

#pragma mark -base64Str and image transformation
+ (NSString*)fn_image_convert_base64Str:(UIImage*)image{
    NSData *data=UIImagePNGRepresentation(image);
    return [data base64EncodedStringWithOptions:0];
}
+ (UIImage*)fn_base64Str_convert_image:(NSString*)base64Str{
    NSData *data=[[NSData alloc]initWithBase64EncodedString:base64Str options:0];
    return [UIImage imageWithData:data];
}
//毫秒转换为日期
+(NSDate*)fn_dateFromUnixTimestamp:(NSString*)millisecond{
    double millisecond_value=[millisecond doubleValue];
    NSTimeInterval timeinterval=millisecond_value/1000.0f;
    return [NSDate dateWithTimeIntervalSince1970:timeinterval];
}
@end
