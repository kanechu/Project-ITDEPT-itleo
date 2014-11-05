//
//  Web_get_permit.h
//  itleo
//
//  Created by itdept on 14-11-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^call_isGetPermit)(BOOL);
@interface Web_get_permit : NSObject

-(void)fn_get_permit_data:(NSString*)base_url callBack:(call_isGetPermit)call_back;

-(NSMutableArray*)fn_get_function_module;
@end
