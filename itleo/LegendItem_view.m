//
//  LegendItem_view.m
//  itleo
//
//  Created by itdept on 14-11-14.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "LegendItem_view.h"

@implementation LegendItem_view

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(LegendItem_view*)fn_shareInstance{
    NSArray *nibView=[[NSBundle mainBundle]loadNibNamed:@"LegendItem_view" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
