//
//  AppDelegate.m
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
@implementation AppDelegate

-(void)fn_reachabilityChanged:(NSNotification*)note{
    Reachability *curReach=[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status=[curReach currentReachabilityStatus];
    if (status==NotReachable) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ITLEO" message:MY_LocalizedString(@"msg_network_fail", nil) delegate:nil cancelButtonTitle:MY_LocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //監測網絡情況
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    hostReach=[Reachability reachabilityForInternetConnection];
    [hostReach startNotifier];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
