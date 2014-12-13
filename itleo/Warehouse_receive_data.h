//
//  Warehouse_receive_data.h
//  itleo
//
//  Created by itdept on 14-12-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Warehouse_receive_data : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *pkg;
@property (nonatomic, copy) NSString *length;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *cbm;
@property (nonatomic, copy) NSString *kgs;
@property (nonatomic, copy) NSString *so_uid;
@property (nonatomic, copy) NSString *unique_id;
@property (nonatomic, copy) NSString *voided;
@property (nonatomic, copy) NSString *remark;

@end
