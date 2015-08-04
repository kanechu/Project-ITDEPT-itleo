//
//  LocationManager.h
//  LocationDemo
//
//  Created by itdept on 14-9-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^callBack)(NSString *longitude,NSString *latitude);
@interface LocationManager : NSObject

@property(nonatomic,strong)callBack call_value;

+ (LocationManager*)fn_shareManager;
- (BOOL)fn_isLocationServiceOn;
- (BOOL)fn_isCurrentAppLocatonServiceOn;
- (BOOL)fn_isLocationServiceDetermined;
- (void)fn_startUpdating;
- (void)fn_stopUpdating;
- (CLLocation*)getCurrentLoaction;
@end
