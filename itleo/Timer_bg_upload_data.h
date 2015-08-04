//
//  Timer_bg_upload_data.h
//  itleo
//
//  Created by itdept on 14-11-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer_bg_upload_data : NSObject

+ (Timer_bg_upload_data*)fn_shareInstance;

- (void)fn_open_upload_records_thread;
- (void)fn_open_upload_GPS_thread;

- (void)fn_start_upload_records;
- (void)fn_stop_upload_records;

- (void)fn_start_upload_GPS;
- (void)fn_stop_upload_GPS;

@end
