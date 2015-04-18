//
//  Cell_order_list.h
//  itleo
//
//  Created by itdept on 15/4/15.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Resp_order_list;

@interface Cell_order_list : UITableViewCell
#pragma mark 订单对象
@property (nonatomic ,strong) Resp_order_list * order_obj;

#pragma mark 单元格高度
@property (nonatomic ,assign) CGFloat height;

@end
