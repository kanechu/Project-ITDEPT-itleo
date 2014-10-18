//
//  Truck_order_data.h
//  itleo
//
//  Created by itdept on 14-9-26.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Truck_order_data : NSObject

@property (nonatomic,copy)NSString *user_code;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *system_name;
@property (nonatomic,copy)NSString *version;
@property (nonatomic,copy)NSString *order_no;
@property (nonatomic,copy)NSString *vehicle_no;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *is_uploaded;
@property (nonatomic,copy)NSString *result;
@property (nonatomic,copy)NSString *upload_date;
@property (nonatomic,copy)NSString *error_date;

@end
