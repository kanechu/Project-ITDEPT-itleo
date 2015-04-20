//
//  Cell_order_list.h
//  itleo
//
//  Created by itdept on 15/4/15.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_order_list : UITableViewCell

@property (nonatomic, strong) NSDictionary *dic_order;

#pragma mark 单元格高度
@property (nonatomic ,assign) CGFloat height;

@end
