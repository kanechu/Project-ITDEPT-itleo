//
//  LocationManager.m
//  LocationDemo
//
//  Created by itdept on 14-9-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "LocationManager.h"
#import "DB_Location.h"
@interface LocationManager()<CLLocationManagerDelegate>
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,strong)CLLocation *currentLocation;

@end
@implementation LocationManager

+(LocationManager*)fn_shareManager{
    static LocationManager *shareManager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager=[[LocationManager alloc]init];
    });
    return shareManager;
}
//手机服务定位是否已经开启
- (BOOL)fn_isLocationServiceOn{
    return [CLLocationManager locationServicesEnabled];
}
//app服务定位是否开启
- (BOOL)fn_isCurrentAppLocatonServiceOn
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        return NO;
    } else {
        return YES;
    }
}
/**
 *  当前app服务定位是否已确定
 *
 *  @return
 */
- (BOOL)fn_isLocationServiceDetermined
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusNotDetermined == status) {
        return NO;
    } else {
        return YES;
    }
    
}
- (void)fn_startUpdating{
    self.locationManager=[[CLLocationManager alloc]init];
    //设置CLLocationManager实例委托
    self.locationManager.delegate=self;
    //要求定位的精确度
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //设置距离筛选器distanceFilter，下面表示设备至少移动1000米，才通知委托更新
   // self.locationManager.distanceFilter=1000.0f;
    //或者没有筛选器的默认设置：
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    self.locationManager.pausesLocationUpdatesAutomatically=YES;
    //启动请求
    [self.locationManager startUpdatingLocation];
}
- (CLLocation*)getCurrentLoaction{
    return self.currentLocation;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation=[locations lastObject];
    NSString *str_latitude=[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    NSString *str_longitude=[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    DB_Location *db=[[DB_Location alloc]init];
    [db fn_save_loaction_data:str_longitude latitude:str_latitude];

}
- (void)fn_stopUpdating{
    [self.locationManager stopUpdatingLocation];
}
@end
