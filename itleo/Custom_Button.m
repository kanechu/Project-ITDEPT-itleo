//
//  Custom_Button.m
//  itleo
//
//  Created by itdept on 14-9-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Custom_Button.h"

@implementation Custom_Button

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _line_color=COLOR_LIGHT_BLUE;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        _line_color=COLOR_light_BLUE;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius=5;
    self.layer.borderWidth=1.5;
    self.layer.borderColor=_line_color.CGColor;
    [self fn_set_btn_leftIcon];
    self.titleLabel.textColor=[UIColor darkGrayColor];
    self.titleEdgeInsets=UIEdgeInsetsMake(0, self.frame.size.height-5, 0, 0);
}
- (void)fn_set_btn_leftIcon{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,3,self.frame.size.height-5, self.frame.size.height-6)];
    imageView.image=_left_icon;
    [self addSubview:imageView];
}

@end
