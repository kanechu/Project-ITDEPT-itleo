//
//  Resp_upd_image_result.h
//  itleo
//
//  Created by itdept on 14-9-30.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_upd_image_result : NSObject

@property (nonatomic, copy) NSString *unique_id;
@property (nonatomic, copy) NSString *ms_upload_queue_id;
@property (nonatomic, copy) NSString *is_upload_sucess;
@property (nonatomic, copy) NSString *error_reason;
@property (nonatomic, copy) NSString *error_date;

@end
