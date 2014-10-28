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
//日期转换为毫秒
+(NSString*)fn_millisecondFromDate:(NSDate*)date{
    NSTimeInterval interval=[date timeIntervalSince1970];
    NSTimeInterval millisecond=interval*1000.0f;
    NSString *str_millisecond=[NSString stringWithFormat:@"%0.0lf",millisecond];
    return str_millisecond;
}
//获取num天前的日期毫秒
+(NSString*)fn_millisecondFrom_days_ago:(NSInteger)num{
    //得到（24*60*60*num)即num前的日期
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:-(24*60*60*num)];
    return [self fn_millisecondFromDate:date];
}
+(NSString*)fn_cut_space:(NSString*)str{
    NSString *subStr=str;
    if ([str rangeOfString:@" "].length>0) {
        NSRange range=[str rangeOfString:@" "];
        subStr=[str substringToIndex:range.location];
    }
    return subStr;
}
@end
