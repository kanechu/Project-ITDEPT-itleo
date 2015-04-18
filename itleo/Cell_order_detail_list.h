//
//  Cell_order_detail_list.h
//  itleo
//
//  Created by itdept on 15/4/16.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Resp_order_list;
@interface Cell_order_detail_list : UITableViewCell

@property (nonatomic, strong) Resp_order_list *order_obj;
@property (nonatomic, assign) CGFloat height;

@end
