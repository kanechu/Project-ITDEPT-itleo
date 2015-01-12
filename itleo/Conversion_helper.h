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
+(NSDate*)fn_dateFromUnixTimestamp:(NSString*)millisecond;
+(NSString*)fn_millisecondFromDate:(NSDate*)date;
+(NSString*)fn_millisecondFrom_days_ago:(NSInteger)num;
+(NSString*)fn_cut_whitespace:(NSString*)str;
+(NSString*)fn_cut_pre_string:(NSString*)str;
+(NSMutableArray*)fn_sort_the_array:(NSMutableArray*)alist_source  key:(NSString*)sortBy_name;
+(NSArray*)fn_filtered_criteriaData:(NSString*)value arr:(NSMutableArray*)alist_will_filter;
+(UIImage*)fn_imageWithView:(UIView*)view;

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
 *  一个Label显示不同颜色
 *
 *  @param _str   需要变换颜色的字符串
 *  @param _range 变换颜色字符串的范围
 *
 *  @return 结果
 */
+(NSMutableAttributedString*)fn_different_fontcolor:(NSString*)_str range:(NSRange)_range;
@end
