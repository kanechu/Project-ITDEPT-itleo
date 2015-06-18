//
//  Cal_lineHeight.m
//  itleo
//
//  Created by itdept on 14-8-14.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cal_lineHeight.h"

@implementation Cal_lineHeight

-(CGFloat)fn_heightWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    CGSize rtSize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    rtSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(rtSize.height) + 0.5;
}

@end
