//
//  Cell_aejob_browse.m
//  itleo
//
//  Created by itdept on 14-8-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_aejob_browse.h"

@implementation Cell_aejob_browse

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _imag_aejob.layer.borderWidth=2;
    _imag_aejob.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
