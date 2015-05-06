//
//  OrderDetailViewController.h
//  itleo
//
//  Created by itdept on 15/4/16.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callBack_handleOrder)(void);
@interface OrderDetailViewController : UIViewController

@property (nonatomic,strong) callBack_handleOrder callback;
@property (nonatomic,strong) NSDictionary *dic_order;
/**
 *  车牌号
 */
@property (copy, nonatomic) NSString *vehicle_no;

@end
