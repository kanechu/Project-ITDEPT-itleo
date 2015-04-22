//
//  Cell_order_info.m
//  itleo
//
//  Created by itdept on 15/4/21.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "Cell_order_info.h"

#define kTableViewCellControlSpacing 5

@interface Cell_order_info ()
@property (weak, nonatomic) IBOutlet UILabel *lbl_pick_addr;
@property (weak, nonatomic) IBOutlet UILabel *lbl_dely_addr;
@property (weak, nonatomic) IBOutlet UILabel *lbl_remark;
@property (weak, nonatomic) IBOutlet UILabel *ilb_pick_addr_value;
@property (weak, nonatomic) IBOutlet UILabel *ilb_dely_addr_value;
@property (weak, nonatomic) IBOutlet UILabel *ilb_remark_value;

@end

@implementation Cell_order_info

- (void)setDic_order:(NSDictionary *)dic_order{
    _lbl_pick_addr.text=MY_LocalizedString(@"lbl_pick_address", nil);
    
    CGFloat pick_addr_valueX=CGRectGetMinX(_ilb_pick_addr_value.frame);
    CGFloat pick_addr_valueY=CGRectGetMinY(_ilb_pick_addr_value.frame);
    CGFloat pick_addr_valueWidth=CGRectGetWidth(_ilb_pick_addr_value.frame);
    CGSize pick_addr_valueSize=[dic_order[@"pick_addr"] boundingRectWithSize:CGSizeMake(pick_addr_valueWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_pick_addr_value.font} context:nil].size;
    CGRect pick_addr_valueRect=CGRectMake(pick_addr_valueX, pick_addr_valueY, pick_addr_valueWidth, pick_addr_valueSize.height);
    _ilb_pick_addr_value.frame=pick_addr_valueRect;
    _ilb_pick_addr_value.text=dic_order[@"pick_addr"];
    
    CGFloat dely_addrX=CGRectGetMinX(_lbl_dely_addr.frame);
    CGFloat dely_addrY=CGRectGetMaxY(_ilb_pick_addr_value.frame)+kTableViewCellControlSpacing;
    CGFloat dely_addrWidth=CGRectGetWidth(_lbl_dely_addr.frame),dely_addrHeight=CGRectGetHeight(_lbl_dely_addr.frame);
    _lbl_dely_addr.frame=CGRectMake(dely_addrX, dely_addrY, dely_addrWidth, dely_addrHeight);
    _lbl_dely_addr.text=MY_LocalizedString(@"lbl_dely_address", nil);
    
    CGFloat dely_addr_valueX=CGRectGetMinX(_ilb_dely_addr_value.frame);
    CGFloat dely_addr_valueY=CGRectGetMaxY(_ilb_pick_addr_value.frame)+kTableViewCellControlSpacing;
    CGFloat dely_addr_valueWidth=CGRectGetWidth(_ilb_dely_addr_value.frame);
    CGSize dely_addr_valueSize=[dic_order[@"dely_addr"] boundingRectWithSize:CGSizeMake(dely_addr_valueWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_dely_addr_value.font} context:nil].size;
    CGRect dely_addr_valueRect=CGRectMake(dely_addr_valueX, dely_addr_valueY, dely_addr_valueWidth, dely_addr_valueSize.height);
    _ilb_dely_addr_value.frame=dely_addr_valueRect;
    _ilb_dely_addr_value.text=dic_order[@"dely_addr"];
    
    CGFloat lbl_remarkX=CGRectGetMinX(_lbl_remark.frame);
    CGFloat lbl_remarkY=CGRectGetMaxY(_ilb_dely_addr_value.frame)+kTableViewCellControlSpacing;
    CGFloat lbl_remarkWidth=CGRectGetWidth(_lbl_remark.frame),lbl_remarkHeight=CGRectGetHeight(_lbl_remark.frame);
    _lbl_remark.frame=CGRectMake(lbl_remarkX, lbl_remarkY, lbl_remarkWidth, lbl_remarkHeight);
    _lbl_remark.text=MY_LocalizedString(@"lbl_order_remark", nil);
    
    CGFloat remark_valueX=CGRectGetMinX(_ilb_remark_value.frame);
    CGFloat remark_valueY=CGRectGetMaxY(_ilb_dely_addr_value.frame)+kTableViewCellControlSpacing;
    CGFloat remark_valueWidth=CGRectGetWidth(_ilb_remark_value.frame);
    CGSize remark_valueSize=[dic_order[@"remark"] boundingRectWithSize:CGSizeMake(remark_valueWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_remark_value.font} context:nil].size;
    CGRect remark_valueRect=CGRectMake(remark_valueX, remark_valueY, remark_valueWidth, remark_valueSize.height);
    _ilb_remark_value.frame=remark_valueRect;
    _ilb_remark_value.text=dic_order[@"remark"];
    
    _height=CGRectGetMaxY(_ilb_remark_value.frame)+kTableViewCellControlSpacing*2;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
