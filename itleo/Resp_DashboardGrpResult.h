//
//  Resp_DashboardGrpResult.h
//  itleo
//
//  Created by itdept on 14-11-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_DashboardGrpResult : NSObject

@property (nonatomic, copy) NSString *unique_id;
@property (nonatomic, copy) NSString *grp_code;
@property (nonatomic, copy) NSString *grp_desc;
@property (nonatomic, copy) NSString *grp_title_en;
@property (nonatomic, copy) NSString *grp_title_cn;
@property (nonatomic, copy) NSString *grp_title_big5;
@property (nonatomic, copy) NSString *rec_crt_usr;
@property (nonatomic, copy) NSString *rec_upd_usr;
@property (nonatomic, copy) NSString *rec_crt_date;
@property (nonatomic, copy) NSString *rec_upd_date;

@end
