//
//  Timer_bg_upload_data.m
//  itleo
//
//  Created by itdept on 14-11-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Timer_bg_upload_data.h"
#import "IsAuto_upload_data.h"

static NSTimer *record_timer=nil;
static NSTimer *GPS_timer=nil;
#define  TIMEINTERVAL 60.0f

@implementation Timer_bg_upload_data

+(Timer_bg_upload_data*)fn_shareInstance{
    static Timer_bg_upload_data *obj=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj=[[Timer_bg_upload_data alloc]init];
    });
    return obj;
}
-(void)fn_open_upload_records_thread{
    IsAuto_upload_data *obj=[[IsAuto_upload_data alloc]init];
    //获取全局的并发队列
    dispatch_queue_t my_Queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(my_Queue, ^{
        if (record_timer==nil) {
            record_timer=[NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:obj selector:@selector(fn_Automatically_upload_data) userInfo:nil repeats:YES];
            //定时器要加入runloop中才能执行
            [[NSRunLoop currentRunLoop]run];
        }
    });
}
-(void)fn_open_upload_GPS_thread{
    IsAuto_upload_data *obj=[[IsAuto_upload_data alloc]init];
    dispatch_queue_t my_Queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(my_Queue, ^{
        if (GPS_timer==nil) {
            GPS_timer=[NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:obj selector:@selector(fn_Auto_upload_GPS) userInfo:nil repeats:YES];
            //定时器要加入runloop中才能执行
            [[NSRunLoop currentRunLoop]run];
        }
    });
}
-(NSTimer*)fn_get_record_timer{
    return record_timer;
}
-(NSTimer*)fn_get_GPS_timer{
    return GPS_timer;
}

@end
