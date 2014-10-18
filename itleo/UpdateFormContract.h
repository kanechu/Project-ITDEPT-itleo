//
//  UpdateFormContract.h
//  itleo
//
//  Created by itdept on 14-9-30.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateFormContract : NSObject

@property(nonatomic, copy) NSString *unique_id;//主表的主键
@property(nonatomic, copy) NSString *order_no;//配载单号
@property(nonatomic, copy) NSString *ms_status;//配载单状态
@property(nonatomic, copy) NSString *vehicle_no;//车牌号
@property(nonatomic, copy) NSSet *Epod_upd_milestone_image;

@end
