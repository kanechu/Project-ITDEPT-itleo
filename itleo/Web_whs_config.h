//
//  Web_get_whs_config.h
//  itleo
//
//  Created by itdept on 14-12-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^callBack_dic)(NSMutableDictionary *dic);

@interface Web_whs_config : NSObject

@property (nonatomic, copy) NSString *str_url;

-(void)fn_get_whs_config_data:(NSString*)base_url;

-(void)fn_post_multipart_formData_to_server:(NSDictionary*)dic_parameters completionHandler:(callBack_dic)callBack;

@end
