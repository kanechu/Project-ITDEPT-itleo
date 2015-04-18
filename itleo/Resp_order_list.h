//
//  Resp_order_list.h
//  itleo
//
//  Created by itdept on 15/4/16.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_order_list : NSObject

@property (nonatomic ,copy) NSString * ilb_phone_num;//手机号码

@property (nonatomic ,copy) NSString * ilb_update_time;//同步时间

@property (nonatomic ,copy) NSString * ilb_origin_addr;//起始地点

@property (nonatomic ,copy) NSString * ilb_order_status;//订单状态

@property (nonatomic ,copy) NSString * ilb_destination_addr;//目的地点

@property (nonatomic ,copy) NSString * ilb_remark;//备注

#pragma mark - 方法
#pragma mark 根据字典初始化订单对象
- (Resp_order_list * )initWithDictionary:(NSDictionary *)dic;

#pragma mark 初始化订单对象（静态方法）
+ (Resp_order_list *)fn_statusWithDictionary:(NSDictionary *)dic;


@end
