//
//  CreatFootView.m
//  itleo
//
//  Created by itdept on 14-10-20.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "CreateFootView.h"
@implementation CreateFootView

+(UIView*)fn_create_footView:(NSString*)str_alert{
    CGRect frame=[[UIScreen mainScreen]bounds];
    UIView *bg_view=[[UIView alloc]initWithFrame:frame];
    UILabel *ilb_alert=[[UILabel alloc]initWithFrame:CGRectMake(60,20, 200, 250)];
    ilb_alert.lineBreakMode=NSLineBreakByCharWrapping;
    ilb_alert.numberOfLines=0;
    ilb_alert.textAlignment=NSTextAlignmentCenter;
    ilb_alert.font=[UIFont systemFontOfSize:24];
    ilb_alert.textColor=[UIColor grayColor];
    ilb_alert.text=str_alert;
    [bg_view addSubview:ilb_alert];
    return bg_view;
}
@end
