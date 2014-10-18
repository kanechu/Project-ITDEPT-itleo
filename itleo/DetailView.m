//
//  DetailView.m
//  itleo
//
//  Created by itdept on 14-8-14.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
-(void)layoutSubviews{
    _imag_detail_icon.layer.cornerRadius=1;
    _imag_detail_icon.layer.borderWidth=2;
    _imag_detail_icon.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _imag_detail_icon.backgroundColor=[UIColor whiteColor];
}
@end
