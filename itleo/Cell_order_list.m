//
//  Cell_order_list.m
//  itleo
//
//  Created by itdept on 15/4/15.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "Cell_order_list.h"
#import "Resp_order_list.h"

#define kTableViewCellControlSpacing 5//控件间距

@interface Cell_order_list(){
   
}
@property (weak, nonatomic) IBOutlet UIImageView *imgView_order;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_origin;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_destination;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_remark;
@property (weak, nonatomic) IBOutlet UILabel *ilb_order_no;
@property (weak, nonatomic) IBOutlet UILabel *ilb_update_time;
@property (weak, nonatomic) IBOutlet UILabel *ilb_origin_addr;
@property (weak, nonatomic) IBOutlet UILabel *ilb_order_status;
@property (weak, nonatomic) IBOutlet UILabel *ilb_destination_addr;
@property (weak, nonatomic) IBOutlet UILabel *ilb_remark;

@end

@implementation Cell_order_list

- (void)setDic_order:(NSDictionary *)dic_order{
    _imgView_order.image=[UIImage imageNamed:@"ic_order"];
    
    _ilb_order_no.text=dic_order[@"order_no"];
    
    _ilb_update_time.text=dic_order[@"update_time"];
    
    _imgView_origin.image=[UIImage imageNamed:@"ic_origin"];
    
    CGFloat ilb_originX=CGRectGetMinX(_ilb_origin_addr.frame);
    CGFloat ilb_originY=CGRectGetMinY(_ilb_origin_addr.frame);
    CGFloat ilb_originWidth=CGRectGetWidth(_ilb_origin_addr.frame);
    CGSize ilb_originSize=[dic_order[@"pick_addr"] boundingRectWithSize:CGSizeMake(ilb_originWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_origin_addr.font} context:nil].size;
    CGRect ilb_originRect= CGRectMake(ilb_originX, ilb_originY, ilb_originSize.width, ilb_originSize.height);
    _ilb_origin_addr.text=dic_order[@"pick_addr"];
    _ilb_origin_addr.frame=ilb_originRect;
    
    _ilb_order_status.text=[NSString stringWithFormat:@"(%@)",dic_order[@"status"]];
    
    CGFloat img_desX=CGRectGetMinX(_imgView_destination.frame);
    CGFloat img_desY=CGRectGetMaxY(_ilb_origin_addr.frame)+kTableViewCellControlSpacing;
    if (img_desY<CGRectGetMaxY(_imgView_origin.frame)) {
        img_desY=CGRectGetMaxY(_imgView_origin.frame);
    }
    CGFloat img_desWidth=CGRectGetWidth(_imgView_destination.frame),img_desHeight=CGRectGetHeight(_imgView_destination.frame);
    _imgView_destination.frame=CGRectMake(img_desX, img_desY,img_desWidth,img_desHeight);
    _imgView_destination.image=[UIImage imageNamed:@"ic_destination"];
    
    CGFloat ilb_desX=CGRectGetMinX(_ilb_destination_addr.frame);
    CGFloat ilb_desY=CGRectGetMaxY(_ilb_origin_addr.frame)+kTableViewCellControlSpacing;
    if (ilb_desY<CGRectGetMaxY(_imgView_origin.frame)) {
        ilb_desY=CGRectGetMaxY(_imgView_origin.frame);
    }
    CGFloat ilb_desWidth=CGRectGetWidth(_ilb_destination_addr.frame);
    CGSize ilb_desSize=[dic_order[@"dely_addr"] boundingRectWithSize:CGSizeMake(ilb_desWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_destination_addr.font} context:nil].size;
    CGRect ilb_desRect= CGRectMake(ilb_desX,ilb_desY, ilb_desWidth, ilb_desSize.height);
    _ilb_destination_addr.text=dic_order[@"dely_addr"];
    _ilb_destination_addr.frame=ilb_desRect;
    
    CGFloat img_remarkX=CGRectGetMinX(_imgView_remark.frame);
    CGFloat img_remarkY=CGRectGetMaxY(_ilb_destination_addr.frame)+kTableViewCellControlSpacing;
    if (img_remarkY<CGRectGetMaxY(_imgView_destination.frame)) {
        img_remarkY=CGRectGetMaxY(_imgView_destination.frame);
    }
    CGFloat img_remarkWidth=CGRectGetWidth(_imgView_remark.frame),img_remarkHeight=CGRectGetHeight(_imgView_remark.frame);
    _imgView_remark.frame=CGRectMake(img_remarkX,img_remarkY,img_remarkWidth,img_remarkHeight);
    _imgView_remark.image=[UIImage imageNamed:@"ic_remark"];
    
    CGFloat ilb_remarkX=CGRectGetMinX(_ilb_remark.frame);
    CGFloat ilb_remarkY=CGRectGetMaxY(_ilb_destination_addr.frame)+kTableViewCellControlSpacing;
    if (ilb_remarkY<CGRectGetMaxY(_imgView_destination.frame)) {
        ilb_remarkY=CGRectGetMaxY(_imgView_destination.frame);
    }
    CGFloat ilb_remarkWidth=CGRectGetWidth(_ilb_remark.frame);
    CGSize ilb_remarkSize=[dic_order[@"remark"] boundingRectWithSize:CGSizeMake(ilb_remarkWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_ilb_remark.font} context:nil].size;
    CGRect ilb_remarkRect= CGRectMake(ilb_remarkX,ilb_remarkY, ilb_remarkSize.width, ilb_remarkSize.height);
    _ilb_remark.text=dic_order[@"remark"];
    _ilb_remark.frame=ilb_remarkRect;
    _height=CGRectGetMaxY(_ilb_remark.frame)+kTableViewCellControlSpacing*2;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
