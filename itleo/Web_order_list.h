//
//  Web_order_list.h
//  itleo
//
//  Created by itdept on 15/4/18.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Web_base;

typedef NS_ENUM(NSUInteger, kAction_type) {
    kGet_all_order,
    kGet_order_list,
    kConfirm_order_list,
    kCheck_order_list,
};
@interface Web_order_list : NSObject

-(void)fn_handle_order_list_data:(NSString*)base_url uid_list:(NSArray*)alist_uids type:(kAction_type)action_type;


@end
