//
//  AppDelegate.h
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability *hostReach;
}

@property (strong, nonatomic) UIWindow *window;

@end
