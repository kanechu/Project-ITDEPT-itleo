//
//  Resp_get_status.h
//  itleo
//
//  Created by itdept on 15-1-5.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_get_status : NSObject

@property (nonatomic, copy) NSString *status_code;
@property (nonatomic, copy) NSString *status_desc_en;
@property (nonatomic, copy) NSString *status_desc_sc;
@property (nonatomic, copy) NSString *status_desc_tc;

@end
