//
//  Timer_bg_upload_data.h
//  itleo
//
//  Created by itdept on 14-11-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer_bg_upload_data : NSObject

+(Timer_bg_upload_data*)fn_shareInstance;
-(void)fn_open_upload_records_thread;
-(void)fn_open_upload_GPS_thread;
-(NSTimer*)fn_get_record_timer;
-(NSTimer*)fn_get_GPS_timer;
@end
