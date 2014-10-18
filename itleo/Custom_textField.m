//
//  Custom_textField.m
//  itleo
//
//  Created by itdept on 14-8-29.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Custom_textField.h"
@interface Custom_textField()

@property(nonatomic,strong)UIColor *color;

@end
@implementation Custom_textField
@synthesize color;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        color=[UIColor lightGrayColor];
    }
    return self;
}
-(void)fn_setLine_color:(UIColor*)line_color{
    color=line_color;
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //设置上下文
     CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGPoint apoints[4];
    apoints[0]=CGPointMake(0, self.frame.size.height-5);
    apoints[1]=CGPointMake(0, self.frame.size.height);
    apoints[2]=CGPointMake(self.frame.size.width, self.frame.size.height);
    apoints[3]=CGPointMake(self.frame.size.width, self.frame.size.height-5);
    CGContextAddLines(context, apoints, 4);
    CGContextDrawPath(context, kCGPathStroke);
    [self setContentScaleFactor:2.0];

}
-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGFloat x=bounds.origin.x+5;
    bounds.origin.x=x;
    return bounds;
}
-(CGRect)textRectForBounds:(CGRect)bounds{
    CGFloat x=bounds.origin.x+5;
    bounds.origin.x=x;
    return bounds;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGFloat x=bounds.origin.x+5;
    bounds.origin.x=x;
    return bounds;
}

@end
