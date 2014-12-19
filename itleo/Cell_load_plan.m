//
//  Cell_load_plan.m
//  itleo
//
//  Created by itdept on 14-12-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_load_plan.h"
#import "Cal_lineHeight.h"
@implementation Cell_load_plan

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _ilb_remark.frame=CGRectMake(_ilb_remark.frame.origin.x, _ilb_remark.frame.origin.y, _ilb_remark.frame.size.width, [self fn_get_label_height:_ilb_remark]);
    
}
-(CGFloat)fn_get_label_height:(UILabel*)label{
    Cal_lineHeight *cal_obj=[[Cal_lineHeight alloc]init];
    CGFloat height=[cal_obj fn_heightWithString:label.text font:label.font constrainedToWidth:label.frame.size.width];
    if (height<21) {
        height=22;
    }
    cal_obj=nil;
    return height;
}
@end
