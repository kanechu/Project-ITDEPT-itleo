//
//  LocationManager.h
//  LocationDemo
//
//  Created by itdept on 14-9-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationManager : NSObject

+(LocationManager*)fn_shareManager;
- (BOOL)fn_isLocationServiceOn;
- (BOOL)fn_isCurrentAppLocatonServiceOn;
- (BOOL)fn_isLocationServiceDetermined;
- (void)fn_start;
- (CLLocation*)getCurrentLoaction;
@end
