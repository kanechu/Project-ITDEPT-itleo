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
@end
