//
//  Resp_order_info.h
//  itleo
//
//  Created by itdept on 14-10-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_order_info : NSObject

@property(nonatomic, copy) NSString *order_no;
@property(nonatomic, copy) NSString *cust_code;
@property(nonatomic, copy) NSString *cust_name;//客户
@property(nonatomic, copy) NSString *pick_cust_code;
@property(nonatomic, copy) NSString *pick_cust_name;//取货客户
@property(nonatomic, copy) NSString *pick_addr;//取货地址
@property(nonatomic, copy) NSString *dely_cust_code;
@property(nonatomic, copy) NSString *dely_cust_name;//送货客户
@property(nonatomic, copy) NSString *dely_addr;//送货地址
@property(nonatomic, copy) NSString *dely_app_date;//预约送货日期
@property(nonatomic, copy) NSString *dely_app_time;//预约送货时间
@property(nonatomic, copy) NSString *item_desc;//货物
@property(nonatomic, copy) NSString *load_pkg;//件数
@property(nonatomic, copy) NSString *load_pkg_unit;//件数单位
@property(nonatomic, copy) NSString *load_kgs;//重量
@property(nonatomic, copy) NSString *load_cbm;//体积

@end
