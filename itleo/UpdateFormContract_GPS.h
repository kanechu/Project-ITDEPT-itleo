//
//  UpdateFormContract_GPS.h
//  itleo
//
//  Created by itdept on 14-10-28.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateFormContract_GPS : NSObject

@property (nonatomic, copy) NSString *unique_id;
@property (nonatomic, copy) NSString *car_no;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, copy) NSString *log_date;

@end
