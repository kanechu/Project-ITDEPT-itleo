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
-(void)layoutSubviews{
    [super layoutSubviews];
    _ilb_remark.lineBreakMode=NSLineBreakByCharWrapping;
    _ilb_remark.numberOfLines=0;
    _ilb_remark.frame=CGRectMake(_ilb_remark.frame.origin.x,0, self.frame.size.width-_ilb_color.frame.size.width-_ilb_color.frame.origin.x, self.frame.size.height-_ilb_remark.frame.origin.y);
    
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
