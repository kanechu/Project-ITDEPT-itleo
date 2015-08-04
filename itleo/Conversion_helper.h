//
//  Conversion_helper.h
//  itleo
//
//  Created by itdept on 14-9-17.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conversion_helper : NSObject

+ (NSString*)fn_image_convert_base64Str:(UIImage*)image;
+ (UIImage*)fn_base64Str_convert_image:(NSString*)base64Str;
+ (NSDate*)fn_dateFromUnixTimestamp:(NSString*)millisecond;
+ (NSString*)fn_millisecondFromDate:(NSDate*)date;
+ (NSString*)fn_millisecondFrom_days_ago:(NSInteger)num;
+ (NSString*)fn_cut_whitespace:(NSString*)str;
+ (NSString*)fn_cut_pre_string:(NSString*)str;
+ (NSMutableArray*)fn_sort_the_array:(NSMutableArray*)alist_source  key:(NSString*)sortBy_name;
+ (NSArray*)fn_filtered_criteriaData:(NSString*)value arr:(NSMutableArray*)alist_will_filter;
+ (UIImage*)fn_imageWithView:(UIView*)view;

/**
 *  获取登录时候，选择的语言
 *
 *  @return 语言类型
 */
+(NSString*)fn_get_lang_code;
/**
 *  日期类型 date 转换成日期字符串
 *
 *  @param date 日期类型
 *
 *  @return 日期字符串
 */
+(NSString*)fn_DateToStringDate:(NSDate*)date;

/**
 *  日期类型 date 转换成日期时间字符串
 *
 *  @param date 日期类型
 *
 *  @return 日期时间字符串
 */
+(NSString*)fn_Date_ToStringDateTime:(NSDate*)date;

/**
 *  给一个label显示两种不同颜色
 *
 *  @param parentString    父字符串
 *  @param subString 需要改变颜色的子字符串
 *  @param color     颜色
 *
 *  @return 处理后带属性的字符串
 */
+ (NSMutableAttributedString*)fn_get_different_color_inLabel:(NSString*)parentString colorString:(NSString*)subString color:(UIColor*)color;
@end
