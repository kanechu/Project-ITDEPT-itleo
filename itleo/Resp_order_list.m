//
//  Resp_order_list.m
//  itleo
//
//  Created by itdept on 15/4/16.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "Resp_order_list.h"

@implementation Resp_order_list
#pragma mark 根据字典初始化订单对象
- (Resp_order_list * )initWithDictionary:(NSDictionary *)dic{
    if (self= [super init]) {
        self.ilb_phone_num=dic[@"ilb_phone_num"];
        self.ilb_update_time=dic[@"ilb_update_time"];
        self.ilb_origin_addr=dic[@"ilb_origin_addr"];
        self.ilb_order_status=dic[@"ilb_order_status"];
        self.ilb_destination_addr=dic[@"ilb_destination_addr"];
        self.ilb_remark=dic[@"ilb_remark"];
    }
    return self;
}

#pragma mark 初始化订单对象（静态方法）
+ (Resp_order_list *)fn_statusWithDictionary:(NSDictionary *)dic{
    Resp_order_list *order_obj=[[Resp_order_list alloc]initWithDictionary:dic];
    return order_obj;
}


@end
