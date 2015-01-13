//
//  Cell_advance_search.m
//  itleo
//
//  Created by itdept on 14-8-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_advance_search.h"

@implementation Cell_advance_search

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
    if (_flag_enable==0) {
        _itf_inputdata.enabled=YES;
    }else{
        _itf_inputdata.enabled=NO;
    }
    if (_keyboardType==kNum_keyboard) {
        _itf_inputdata.keyboardType=UIKeyboardTypeNumberPad;
    }else if (_keyboardType==kDecimal_keyboard){
        _itf_inputdata.keyboardType=UIKeyboardTypeDecimalPad;
    }else{
        _itf_inputdata.keyboardType=UIKeyboardTypeDefault;
    }
}

@end
