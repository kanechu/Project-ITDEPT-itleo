//
//  Cal_lineHeight.h
//  itleo
//
//  Created by itdept on 14-8-14.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cal_lineHeight : NSObject
-(CGFloat)fn_heightWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width;
@end
