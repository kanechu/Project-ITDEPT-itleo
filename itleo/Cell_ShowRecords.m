//
//  Cell_ShowRecords.m
//  itleo
//
//  Created by itdept on 14-9-23.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_ShowRecords.h"
#import "Checkbox.h"

#define I_HEIGHT 35
@implementation Cell_ShowRecords

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        _ibox_Delete=[[Checkbox alloc]initWithFrame:CGRectZero];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [_ibox_Delete setFrame:CGRectMake(_ilb_delete.frame.origin.x+_ilb_delete.frame.size.width,_ilb_delete.frame.origin.y-8,I_HEIGHT, I_HEIGHT)];
    _ibox_Delete.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_ibox_Delete];
}

@end
