//
//  Web_get_chart_data.h
//  itleo
//
//  Created by itdept on 14-11-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^call_back)(void);
@interface Web_get_chart_data : NSObject

@property(nonatomic,strong)call_back callBack;

- (void) fn_get_chart_data:(NSString*)base_url;

@end

