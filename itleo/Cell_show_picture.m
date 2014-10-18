//
//  Cell_show_picture.m
//  itleo
//
//  Created by itdept on 14-9-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_show_picture.h"

@implementation Cell_show_picture

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
    [super layoutSubviews];
    self.layer.cornerRadius=2;
    self.layer.borderWidth=1;
    self.layer.borderColor=[UIColor lightGrayColor].CGColor;
}

@end
