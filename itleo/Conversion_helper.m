//
//  Conversion_helper.m
//  itleo
//
//  Created by itdept on 14-9-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Conversion_helper.h"
#import "DB_LoginInfo.h"
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
//把前后的空格都去掉
+(NSString*)fn_cut_whitespace:(NSString*)str{
    NSString *subStr=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return subStr;
}
+(NSString*)fn_cut_pre_string:(NSString*)str{
    NSString *subStr=str;
    if ([str rangeOfString:@" "].length>0) {
        NSRange range=[str rangeOfString:@" "];
        subStr=[str substringToIndex:range.location];
    }
    return subStr;
}
/**
 *  给数组排序
 *
 *  @param alist_source 要排序的数组
 *  @param sortBy_name  根据关键字排序
 *
 *  @return 返回排序后的数组
 */
+(NSMutableArray*)fn_sort_the_array:(NSMutableArray*)alist_source  key:(NSString*)sortBy_name{
    //如果需要降序，那么将ascending由YES改为NO
    NSSortDescriptor *sortDes=[NSSortDescriptor sortDescriptorWithKey:sortBy_name ascending:YES];
    NSArray *sortDescriptors=[NSArray arrayWithObject:sortDes];
    NSMutableArray *sortedArray=[[alist_source sortedArrayUsingDescriptors:sortDescriptors]mutableCopy];
    //重新排序后，返回
    return sortedArray;
}
#pragma mark 对数组进行过滤
+(NSArray*)fn_filtered_criteriaData:(NSString*)value arr:(NSMutableArray*)alist_will_filter{
    NSArray *filtered=[alist_will_filter filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(serie==%@)",value]];
    return filtered;
}
#pragma mark -UIView转Image
+(UIImage*)fn_imageWithView:(UIView*)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen]scale]);
    //UIGraphicsBeginImageContext(view.bounds.size)相对比较模糊
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  获取登录时候，选择的语言
 *
 *  @return 语言类型
 */
+(NSString*)fn_get_lang_code{
    DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
    NSMutableArray *arr=[db fn_get_all_LoginInfoData];
    NSString *lang_code=@"";
    if ([arr count]!=0) {
        lang_code=[[arr objectAtIndex:0]valueForKey:@"lang_code"];
        if ([lang_code isEqualToString:@"EN"]) {
            lang_code=@"en";
        }
        if ([lang_code isEqualToString:@"CN"]) {
            lang_code=@"zh-Hans";
        }
        if ([lang_code isEqualToString:@"TCN"]) {
            lang_code=@"zh-Hant";
        }
    }
    return lang_code;
}
@end
