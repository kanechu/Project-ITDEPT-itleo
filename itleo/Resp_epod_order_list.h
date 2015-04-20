//
//  Resp_epod_order_list.h
//  itleo
//
//  Created by itdept on 15/4/18.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_epod_order_list : NSObject

@property (nonatomic, copy) NSString *ls_action;

@property (nonatomic, copy) NSString *ls_status;

@property (nonatomic, copy) NSString *ls_msg;

@property (nonatomic, strong) NSArray *ls_order_list;

@end
