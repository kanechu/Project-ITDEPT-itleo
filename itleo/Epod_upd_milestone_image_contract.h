//
//  Epod_upd_milestone_image_contract.h
//  itleo
//
//  Created by itdept on 14-9-30.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Epod_upd_milestone_image_contract : NSObject

@property(nonatomic, copy) NSString *unique_id;//主键
@property(nonatomic, copy) NSString *ms_upload_queue_id;//外键
@property(nonatomic, copy) NSString *ms_imgBase64;//图片base64编码
@property(nonatomic, copy) NSString *img_remark;

@end
