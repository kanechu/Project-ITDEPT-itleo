//
//  Resp_order_list.h
//  itleo
//
//  Created by itdept on 15/4/16.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_order_list : NSObject

@property (nonatomic, copy) NSString *order_uid;

@property (nonatomic, copy) NSString *order_no;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *pick_addr;

@property (nonatomic, copy) NSString *dely_addr;

@property (nonatomic, copy) NSString *sign_path;

@property (nonatomic, copy) NSString *sign_path_base64;

@property (nonatomic, copy) NSString *voided;

@property (nonatomic, copy) NSArray *ls_order_dtl_list;

@end
