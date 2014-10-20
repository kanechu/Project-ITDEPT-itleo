//
//  CheckNetWork.m
//  itleo
//
//  Created by itdept on 14-10-20.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "CheckNetWork.h"
#import "Reachability/Reachability.h"
@implementation CheckNetWork
-(BOOL)fn_check_isNetworking{
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus!=NotReachable)||([Reachability reachabilityForLocalWiFi].currentReachabilityStatus!=NotReachable)) {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)fn_isPopUp_alert;{
    if ([self fn_check_isNetworking]==NO) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ITLEO" message:MY_LocalizedString(@"msg_network_fail", nil) delegate:nil cancelButtonTitle:MY_LocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
        [alert show];
        return YES;
    }else{
        return NO;
    }
}
@end
