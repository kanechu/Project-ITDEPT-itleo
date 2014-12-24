//
//  Resp_UPLOAD_COL.h
//  itleo
//
//  Created by itdept on 14-12-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_UPLOAD_COL : NSObject

@property (nonatomic, assign) NSInteger seq;
@property (nonatomic, copy) NSString *col_field;
@property (nonatomic, strong) NSSet *col_label;
@property (nonatomic, copy) NSString *col_type;
@property (nonatomic, copy) NSString *col_option;
@property (nonatomic, copy) NSString *col_def;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, assign) NSInteger is_mandatory;

@end
