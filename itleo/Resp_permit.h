//
//  Resp_permit.h
//  itleo
//
//  Created by itdept on 14-11-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_permit : NSObject

@property(nonatomic, copy) NSString *module_unique_id;
@property(nonatomic, copy) NSString *module_code;
@property(nonatomic, copy) NSString *module_desc;
@property(nonatomic, copy) NSString *module_desc_lang1;
@property(nonatomic, copy) NSString *module_desc_lang2;
@property(nonatomic, copy) NSString *f_exec;

@end
