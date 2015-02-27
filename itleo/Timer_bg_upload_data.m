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
        dispatch_async(dispatch_get_main_queue(),^{
            record_timer=[NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:obj selector:@selector(fn_Automatically_upload_data) userInfo:nil repeats:YES];
        });
    });
}
-(void)fn_open_upload_GPS_thread{
    IsAuto_upload_data *obj=[[IsAuto_upload_data alloc]init];
    dispatch_queue_t my_Queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(my_Queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            GPS_timer=[NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:obj selector:@selector(fn_Auto_upload_GPS) userInfo:nil repeats:YES];
        });
    });
}
-(void)fn_start_upload_records{
    [record_timer setFireDate:[NSDate distantPast]];
}
-(void)fn_stop_upload_records{
    [record_timer setFireDate:[NSDate distantFuture]];
}
-(void)fn_start_upload_GPS{
    [GPS_timer setFireDate:[NSDate distantPast]];
}
-(void)fn_stop_upload_GPS{
    [GPS_timer setFireDate:[NSDate distantFuture]];
}

@end
