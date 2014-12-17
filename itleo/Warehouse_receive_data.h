//
//  Warehouse_receive_data.h
//  itleo
//
//  Created by itdept on 14-12-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Warehouse_receive_data : NSObject

@property (nonatomic, copy)   NSString *uid;
@property (nonatomic, assign) NSInteger pkg;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger cbm;
@property (nonatomic, assign) NSInteger kgs;
@property (nonatomic, copy)   NSString *so_uid;
@property (nonatomic, copy)   NSString *unique_id;
@property (nonatomic, assign) NSInteger voided;
@property (nonatomic, copy)   NSString *remark;
@property (nonatomic, copy)   NSString *char_col1;
@property (nonatomic, copy)   NSString *char_col2;

@end
