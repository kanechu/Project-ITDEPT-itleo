//
//  Cell_order_detail_list.m
//  itleo
//
//  Created by itdept on 15/4/16.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "Cell_order_detail_list.h"
#import "Resp_order_dtl_list.h"
#define kTableViewCellControlSpacing 5//控件间距

@interface Cell_order_detail_list()
@property (weak, nonatomic) IBOutlet UILabel *lbl_item_desc;
@property (weak, nonatomic) IBOutlet UILabel *ilb_item_desc_value;
@property (weak, nonatomic) IBOutlet UILabel *lbl_pkg;
@property (weak, nonatomic) IBOutlet UILabel *ilb_pkg_value;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_detail;

@end
@implementation Cell_order_detail_list

- (void)setDic_order_dtl:(NSDictionary *)dic_order_dtl{
    _lbl_item_desc.text=MY_LocalizedString(@"lbl_item_descp", nil);
    NSString *str_image=dic_order_dtl[@"item_pic_path_base64"];
    _imgView_detail.image=[Conversion_helper fn_base64Str_convert_image:str_image];
    _imgView_detail.layer.borderWidth=1.5;
    _imgView_detail.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _imgView_detail.layer.cornerRadius=2;
    
    CGFloat item_desc_valueX=CGRectGetMinX(_ilb_item_desc_value.frame);
    CGFloat item_desc_valueY=CGRectGetMinY(_ilb_item_desc_value.frame);
    CGFloat item_desc_valueWidth=CGRectGetWidth(_ilb_item_desc_value.frame);
    CGSize item_desc_valueSize=[dic_order_dtl[@"descp"] boundingRectWithSize:CGSizeMake(item_desc_valueWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_item_desc_value.font} context:nil].size;
    CGRect item_desc_valueRect=CGRectMake(item_desc_valueX, item_desc_valueY, item_desc_valueWidth, item_desc_valueSize.height);
    _ilb_item_desc_value.text=dic_order_dtl[@"descp"];
    _ilb_item_desc_value.frame=item_desc_valueRect;
    
    CGFloat lbl_pkgX=CGRectGetMinX(_lbl_pkg.frame);
    CGFloat lbl_pkgY=CGRectGetMaxY(_ilb_item_desc_value.frame)+kTableViewCellControlSpacing;
    CGFloat lbl_pkgWidth=CGRectGetWidth(_lbl_pkg.frame),lbl_pkgHeight=CGRectGetHeight(_lbl_pkg.frame);
    _lbl_pkg.frame=CGRectMake(lbl_pkgX, lbl_pkgY, lbl_pkgWidth, lbl_pkgHeight);
    _lbl_pkg.text=MY_LocalizedString(@"lbl_order_pkg", nil);
    
    CGFloat lbl_pkg_valueX=CGRectGetMinX(_ilb_pkg_value.frame);
    CGFloat lbl_pkg_valueY=CGRectGetMaxY(_ilb_item_desc_value.frame)+kTableViewCellControlSpacing;
    CGFloat lbl_pkg_valueWidth=CGRectGetWidth(_ilb_pkg_value.frame),lbl_pkg_valueHeight=CGRectGetHeight(_ilb_pkg_value.frame);
    _ilb_pkg_value.frame=CGRectMake(lbl_pkg_valueX, lbl_pkg_valueY, lbl_pkg_valueWidth, lbl_pkg_valueHeight);
    _ilb_pkg_value.text=dic_order_dtl[@"pkg"];
    
    _height=CGRectGetMaxY(_ilb_pkg_value.frame)+kTableViewCellControlSpacing*2;
    if (_height<CGRectGetMaxY(_imgView_detail.frame)) {
        _height=CGRectGetMaxY(_imgView_detail.frame)+kTableViewCellControlSpacing;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
