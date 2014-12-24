//
//  DB_whs_config.m
//  itleo
//
//  Created by itdept on 14-12-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DB_whs_config.h"
#import "DatabaseQueue.h"
@implementation DB_whs_config
@synthesize queue;

- (id)init{
    self=[super init];
    if (self) {
        queue=[DatabaseQueue fn_sharedInstance];
    }
    return self;
}

@end
