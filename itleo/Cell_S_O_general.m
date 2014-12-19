//
//  Cell_S_O_general.m
//  itleo
//
//  Created by itdept on 14-12-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Cell_S_O_general.h"
#import "Cal_lineHeight.h"
@implementation Cell_S_O_general

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
-(void)layoutSubviews{
    [super layoutSubviews];
    [self fn_adjust_general_label_height];
}
-(void)fn_adjust_general_label_height{
    _ilb_vsl_voy.frame=CGRectMake(_ilb_vsl_voy.frame.origin.x, _ilb_vsl_voy.frame.origin.y, _ilb_vsl_voy.frame.size.width, [self fn_get_label_height:_ilb_vsl_voy]);
    _ilb_shipper.frame=CGRectMake(_ilb_shipper.frame.origin.x, _ilb_vsl_voy.frame.origin.y+_ilb_vsl_voy.frame.size.height, _ilb_shipper.frame.size.width, [self fn_get_label_height:_ilb_shipper]);
    _ilb_consignee.frame=CGRectMake(_ilb_consignee.frame.origin.x, _ilb_shipper.frame.origin.y+_ilb_shipper.frame.size.height, _ilb_consignee.frame.size.width, [self fn_get_label_height:_ilb_consignee]);
    _ilb_loadPort.frame=CGRectMake(_ilb_loadPort.frame.origin.x, _ilb_consignee.frame.origin.y+_ilb_consignee.frame.size.height, _ilb_loadPort.frame.size.width,[self fn_get_label_height:_ilb_loadPort]);
    _ilb_dishPort.frame=CGRectMake(_ilb_dishPort.frame.origin.x, _ilb_loadPort.frame.origin.y+_ilb_loadPort.frame.size.height,_ilb_dishPort.frame.size.width, [self fn_get_label_height:_ilb_dishPort]);
    _ilb_destination.frame=CGRectMake(_ilb_destination.frame.origin.x, _ilb_dishPort.frame.origin.y+_ilb_dishPort.frame.size.height, _ilb_destination.frame.size.width,[self fn_get_label_height:_ilb_destination]);
    
    //固定
    
    _ilb_title_vsl_voy.text=MY_LocalizedString(@"lbl_vsl_voy", nil);
    _ilb_title_shipper.text=MY_LocalizedString(@"lbl_shpr", nil);
    _ilb_title_consignee.text=MY_LocalizedString(@"lbl_cnee", nil);
    _ilb_title_loadPort.text=MY_LocalizedString(@"lbl_load", nil);
    _ilb_title_dishPort.text=MY_LocalizedString(@"lbl_dish", nil);
    _ilb_title_destination.text=MY_LocalizedString(@"lbl_dest", nil);
    
    _ilb_title_vsl_voy.frame=CGRectMake(_ilb_title_vsl_voy.frame.origin.x, _ilb_vsl_voy.frame.origin.y, _ilb_title_vsl_voy.frame.size.width, _ilb_title_vsl_voy.frame.size.height);
    _ilb_title_shipper.frame=CGRectMake(_ilb_title_shipper.frame.origin.x, _ilb_shipper.frame.origin.y, _ilb_title_shipper.frame.size.width, _ilb_title_shipper.frame.size.height);
    _ilb_title_consignee.frame=CGRectMake(_ilb_title_consignee.frame.origin.x, _ilb_consignee.frame.origin.y, _ilb_title_consignee.frame.size.width, _ilb_title_consignee.frame.size.height);
    _ilb_title_loadPort.frame=CGRectMake(_ilb_title_loadPort.frame.origin.x, _ilb_loadPort.frame.origin.y, _ilb_title_loadPort.frame.size.width, _ilb_title_loadPort.frame.size.height);
    _ilb_title_dishPort.frame=CGRectMake(_ilb_title_dishPort.frame.origin.x, _ilb_dishPort.frame.origin.y, _ilb_title_dishPort.frame.size.width, _ilb_title_dishPort.frame.size.height);
    _ilb_title_destination.frame=CGRectMake(_ilb_title_destination.frame.origin.x, _ilb_destination.frame.origin.y, _ilb_title_destination.frame.size.width, _ilb_title_destination.frame.size.height);
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
