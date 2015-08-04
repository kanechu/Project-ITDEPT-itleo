//
//  RespEpod_updmilestone.h
//  itleo
//
//  Created by itdept on 14-9-30.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RespEpod_updmilestone : NSObject

@property (nonatomic, copy) NSString *unique_id;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *is_upload_sucess;
@property (nonatomic, copy) NSString *upload_date;
@property (nonatomic, copy) NSString *error_reason;
@property (nonatomic, copy) NSString *error_date;
@property (nonatomic, strong) NSSet *Epod_upd_milestone_image_Result;

@end
