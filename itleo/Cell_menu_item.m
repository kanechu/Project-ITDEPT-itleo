//
//  Cell_menu_item.m
//  itleo
//
//  Created by itdept on 14-8-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_menu_item.h"

@implementation Cell_menu_item

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
    _ibtn_image.layer.cornerRadius=2;
    _ibtn_image.backgroundColor=[UIColor lightGrayColor];
}

@end
