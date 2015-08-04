//
//  Resp_DashboardDtlResult.h
//  itleo
//
//  Created by itdept on 14-11-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resp_DashboardDtlResult : NSObject

@property (nonatomic, copy) NSString *unique_id;
@property (nonatomic, copy) NSString *chart_seq;
@property (nonatomic, copy) NSString *dhb_group_id;
@property (nonatomic, copy) NSString *chart_title_en;
@property (nonatomic, copy) NSString *chart_title_cn;
@property (nonatomic, copy) NSString *chart_title_big5;
@property (nonatomic, copy) NSString *chart_desc;
@property (nonatomic, copy) NSString *chart_type;
@property (nonatomic, copy) NSString *x_title_en;
@property (nonatomic, copy) NSString *x_title_cn;
@property (nonatomic, copy) NSString *x_title_big5;
@property (nonatomic, copy) NSString *y_title_en;
@property (nonatomic, copy) NSString *y_title_cn;
@property (nonatomic, copy) NSString *y_title_big5;
@property (nonatomic, copy) NSString *rec_crt_usr;
@property (nonatomic, copy) NSString *rec_upd_usr;
@property (nonatomic, copy) NSString *rec_crt_date;
@property (nonatomic, copy) NSString *rec_upd_date;
@property (nonatomic, strong) NSSet *data;

@end
