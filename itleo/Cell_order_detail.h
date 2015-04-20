//
//  Cell_order_detail.h
//  itleo
//
//  Created by itdept on 15/4/16.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_order_detail : UITableViewCell

@property (nonatomic,strong) NSDictionary *dic_order;

#pragma mark 单元格高度
@property (nonatomic ,assign) CGFloat height;

@end
