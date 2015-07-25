//
//  Web_order_list.h
//  itleo
//
//  Created by itdept on 15/4/18.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Web_base.h"

//触发的事件类型
typedef NS_ENUM(NSUInteger, kAction_type) {
    kGet_order_list_all,
    kConfirm_all_order_list,
    kGet_order_list,
    kConfirm_order_list,
    kCheck_order_list,
};
@interface Web_order_list : NSObject

@property (nonatomic, strong) callBack_resp_result callback;
@property (nonatomic, copy) NSString *vehicle_no;

-(void)fn_handle_order_list_data:(NSSet*)set_uid_list type:(kAction_type)action_type;


@end
