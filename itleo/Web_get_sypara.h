//
//  Web_get_sypara.h
//  worldtrans
//
//  Created by itdept on 14-10-22.
//  Copyright (c) 2014年 Worldtrans Logistics Services Ltd. . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Web_get_sypara : NSObject

-(void)fn_get_sypara_data:(NSString*)base_url;

-(NSInteger)fn_isShow_GPS_function;

-(BOOL)fn_isShow_order_list_AndVertify;

@end
