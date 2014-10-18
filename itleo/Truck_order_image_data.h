//
//  Truck_order_image_data.h
//  itleo
//
//  Created by itdept on 14-9-29.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Truck_order_image_data : NSObject

@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *image_remark;
@property(nonatomic,copy)NSString *image_isUploaded;
@property(nonatomic,copy)NSString *error_reason;
@property(nonatomic,copy)NSString *img_error_date;
@property(nonatomic,assign)NSNumber *correlation_id;

@end
