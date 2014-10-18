//
//  Cell_status_list.m
//  itleo
//
//  Created by itdept on 14-9-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_status_list.h"

@implementation Cell_status_list

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
-(void)layoutSubviews{
    [super layoutSubviews];
    _itf_declare.layer.borderColor=[UIColor lightGrayColor].CGColor ;
    _itf_declare.layer.borderWidth=1;
    _itf_declare.layer.cornerRadius=5;
    if (_flag_enable==1) {
        _itf_declare.enabled=YES;
    }else{
        _itf_declare.enabled=NO;
    }

}

@end
