//
//  Cell_order_detail.m
//  itleo
//
//  Created by itdept on 15/4/16.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "Cell_order_detail.h"
#import "Resp_order_list.h"
#define kTableViewCellControlSpacing 2//控件间距

@interface Cell_order_detail()
@property (weak, nonatomic) IBOutlet UILabel *lbl_origin;
@property (weak, nonatomic) IBOutlet UILabel *ilb_origin_addr;
@property (weak, nonatomic) IBOutlet UILabel *lbl_destination;
@property (weak, nonatomic) IBOutlet UILabel *ilb_destination_addr;
@property (weak, nonatomic) IBOutlet UILabel *lbl_status;
@property (weak, nonatomic) IBOutlet UILabel *ilb_status_value;
@property (weak, nonatomic) IBOutlet UILabel *lbl_remark;
@property (weak, nonatomic) IBOutlet UILabel *ilb_remark_value;

@property (weak, nonatomic) IBOutlet UILabel *lbl_dynamic1;
@property (weak, nonatomic) IBOutlet UILabel *ilb_dynamic1_value;
@property (weak, nonatomic) IBOutlet UILabel *lbl_dynamic2;
@property (weak, nonatomic) IBOutlet UILabel *ilb_dynamic2_value;
@property (weak, nonatomic) IBOutlet UILabel *lbl_dynamic3;

@property (weak, nonatomic) IBOutlet UILabel *ilb_dynamic3_value;
@end


@implementation Cell_order_detail

- (void)setOrder_obj:(Resp_order_list *)order_obj{
    _lbl_origin.text=@"Pick Up Loc:";
    
    CGFloat ilb_originX=CGRectGetMinX(_ilb_origin_addr.frame);
    CGFloat ilb_originY=CGRectGetMinY(_ilb_origin_addr.frame);
    CGFloat ilb_originWidth=CGRectGetWidth(_ilb_origin_addr.frame);
    CGSize ilb_originSize=[order_obj.ilb_origin_addr boundingRectWithSize:CGSizeMake(ilb_originWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_origin_addr.font} context:nil].size;
    CGRect ilb_originRect= CGRectMake(ilb_originX, ilb_originY, ilb_originSize.width, ilb_originSize.height);
    _ilb_origin_addr.text=order_obj.ilb_origin_addr;
    _ilb_origin_addr.frame=ilb_originRect;
    
    CGFloat lbl_desX=CGRectGetMinX(_lbl_destination.frame);
    CGFloat lbl_desY=CGRectGetMaxY(_ilb_origin_addr.frame)+kTableViewCellControlSpacing;
    CGFloat lbl_desWidth=CGRectGetWidth(_lbl_destination.frame),lbl_desHeight=CGRectGetHeight(_lbl_destination.frame);
    _lbl_destination.frame=CGRectMake(lbl_desX, lbl_desY,lbl_desWidth,lbl_desHeight);
    _lbl_destination.text=@"Destination:";
    
    CGFloat ilb_des_addrX=CGRectGetMinX(_ilb_destination_addr.frame);
    CGFloat ilb_des_addrY=CGRectGetMaxY(_ilb_origin_addr.frame)+kTableViewCellControlSpacing;
    CGFloat ilb_des_addrWidth=CGRectGetWidth(_ilb_destination_addr.frame);
    CGSize ilb_des_addrSize=[order_obj.ilb_destination_addr boundingRectWithSize:CGSizeMake(ilb_des_addrWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_destination_addr.font} context:nil].size;
    CGRect ilb_des_addrRect= CGRectMake(ilb_des_addrX,ilb_des_addrY, ilb_des_addrWidth, ilb_des_addrSize.height);
    _ilb_destination_addr.text=order_obj.ilb_destination_addr;
    _ilb_destination_addr.frame=ilb_des_addrRect;
    
    CGFloat lbl_statusX=CGRectGetMinX(_lbl_status.frame);
    CGFloat lbl_statusY=CGRectGetMaxY(_ilb_destination_addr.frame)+kTableViewCellControlSpacing;
    CGFloat lbl_statusWidth=CGRectGetWidth(_lbl_status.frame),lbl_statusHeight=CGRectGetHeight(_lbl_status.frame);
    _lbl_status.frame=CGRectMake(lbl_statusX,lbl_statusY,lbl_statusWidth,lbl_statusHeight);
    _lbl_status.text=@"Status:";
    
    CGFloat ilb_status_contentX=CGRectGetMinX(_ilb_status_value.frame);
    CGFloat ilb_status_contentY=CGRectGetMaxY(_ilb_destination_addr.frame)+kTableViewCellControlSpacing;
    CGFloat ilb_status_contentWidth=CGRectGetWidth(_ilb_status_value.frame);
    CGSize ilb_status_contentSize=[order_obj.ilb_order_status boundingRectWithSize:CGSizeMake(ilb_status_contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_status_value.font} context:nil].size;
    CGRect ilb_status_contentRect= CGRectMake(ilb_status_contentX,ilb_status_contentY, ilb_status_contentSize.width, ilb_status_contentSize.height);
    _ilb_status_value.text=order_obj.ilb_order_status;
    _ilb_status_value.frame=ilb_status_contentRect;
    
    CGFloat lbl_remarkX=CGRectGetMinX(_lbl_remark.frame);
    CGFloat lbl_remarkY=CGRectGetMaxY(_ilb_status_value.frame)+kTableViewCellControlSpacing;
    CGFloat lbl_remarkWidth=CGRectGetWidth(_lbl_remark.frame),lbl_remarkHeight=CGRectGetHeight(_lbl_remark.frame);
    _lbl_remark.frame=CGRectMake(lbl_remarkX,lbl_remarkY,lbl_remarkWidth,lbl_remarkHeight);
    _lbl_remark.text=@"Remark:";
    
    CGFloat ilb_remark_contentX=CGRectGetMinX(_ilb_remark_value.frame);
    CGFloat ilb_remark_contentY=CGRectGetMaxY(_ilb_status_value.frame)+kTableViewCellControlSpacing;
    CGFloat ilb_remark_contentWidth=CGRectGetWidth(_ilb_remark_value.frame);
    CGSize ilb_remark_contentSize=[order_obj.ilb_remark boundingRectWithSize:CGSizeMake(ilb_remark_contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_remark_value.font} context:nil].size;
    CGRect ilb_remark_contentRect= CGRectMake(ilb_remark_contentX,ilb_remark_contentY, ilb_remark_contentWidth, ilb_remark_contentSize.height);
    _ilb_remark_value.text=order_obj.ilb_remark;
    _ilb_remark_value.frame=ilb_remark_contentRect;
    
    CGFloat lbl_dynamic1X=CGRectGetMinX(_lbl_dynamic1.frame);
    CGFloat lbl_dynamic1Y=CGRectGetMaxY(_ilb_remark_value.frame)+kTableViewCellControlSpacing;
    CGFloat lbl_dynamic1Width=CGRectGetWidth(_lbl_dynamic1.frame),lbl_dynamic1Height=CGRectGetHeight(_lbl_dynamic1.frame);
    _lbl_dynamic1.frame=CGRectMake(lbl_dynamic1X,lbl_dynamic1Y,lbl_dynamic1Width,lbl_dynamic1Height);
    _lbl_dynamic1.text=@"Dynamic1:";
    
    CGFloat dynamic1_contentX=CGRectGetMinX(_ilb_dynamic1_value.frame);
    CGFloat dynamic1_contentY=CGRectGetMaxY(_ilb_remark_value.frame)+kTableViewCellControlSpacing;
    CGFloat dynamic1_contentWidth=CGRectGetWidth(_ilb_dynamic1_value.frame);
    CGSize dynamic1_contentSize=[@"" boundingRectWithSize:CGSizeMake(ilb_remark_contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_dynamic1_value.font} context:nil].size;
    CGRect dynamic1_contentRect= CGRectMake(dynamic1_contentX,dynamic1_contentY, dynamic1_contentWidth, dynamic1_contentSize.height);
    _ilb_dynamic1_value.text=@"Dynamic Value1";
    _ilb_dynamic1_value.frame=dynamic1_contentRect;
    
    CGFloat lbl_dynamic2X=CGRectGetMinX(_lbl_dynamic2.frame);
    CGFloat lbl_dynamic2Y=CGRectGetMaxY(_ilb_dynamic1_value.frame)+kTableViewCellControlSpacing;
    CGFloat lbl_dynamic2Width=CGRectGetWidth(_lbl_dynamic2.frame),lbl_dynamic2Height=CGRectGetHeight(_lbl_dynamic2.frame);
    _lbl_dynamic2.frame=CGRectMake(lbl_dynamic2X,lbl_dynamic2Y,lbl_dynamic2Width,lbl_dynamic2Height);
    _lbl_dynamic2.text=@"Dynamic2:";
    
    CGFloat dynamic2_contentX=CGRectGetMinX(_ilb_dynamic2_value.frame);
    CGFloat dynamic2_contentY=CGRectGetMaxY(_ilb_dynamic1_value.frame)+kTableViewCellControlSpacing;
    CGFloat dynamic2_contentWidth=CGRectGetWidth(_ilb_dynamic2_value.frame);
    CGSize dynamic2_contentSize=[@"" boundingRectWithSize:CGSizeMake(dynamic2_contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_dynamic2_value.font} context:nil].size;
    CGRect dynamic2_contentRect= CGRectMake(dynamic2_contentX,dynamic2_contentY, dynamic2_contentWidth, dynamic2_contentSize.height);
    _ilb_dynamic2_value.text=@"Dynamic Value2";
    _ilb_dynamic2_value.frame=dynamic2_contentRect;
    
    CGFloat lbl_dynamic3X=CGRectGetMinX(_lbl_dynamic3.frame);
    CGFloat lbl_dynamic3Y=CGRectGetMaxY(_ilb_dynamic2_value.frame)+kTableViewCellControlSpacing;
    CGFloat lbl_dynamic3Width=CGRectGetWidth(_lbl_dynamic3.frame),lbl_dynamic3Height=CGRectGetHeight(_lbl_dynamic3.frame);
    _lbl_dynamic3.frame=CGRectMake(lbl_dynamic3X,lbl_dynamic3Y,lbl_dynamic3Width,lbl_dynamic3Height);
    _lbl_dynamic3.text=@"Dynamic3:";
    
    CGFloat dynamic3_contentX=CGRectGetMinX(_ilb_dynamic3_value.frame);
    CGFloat dynamic3_contentY=CGRectGetMaxY(_ilb_dynamic2_value.frame)+kTableViewCellControlSpacing;
    CGFloat dynamic3_contentWidth=CGRectGetWidth(_ilb_dynamic3_value.frame);
    CGSize dynamic3_contentSize=[@"" boundingRectWithSize:CGSizeMake(dynamic3_contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_dynamic3_value.font} context:nil].size;
    CGRect dynamic3_contentRect= CGRectMake(dynamic3_contentX,dynamic3_contentY, dynamic3_contentWidth, dynamic3_contentSize.height);
    _ilb_dynamic3_value.text=@"Dynamic Values";
    _ilb_dynamic3_value.frame=dynamic3_contentRect;

    _height=CGRectGetMaxY(_ilb_dynamic3_value.frame)+kTableViewCellControlSpacing*2;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
