//
//  Web_get_chart_data.h
//  itleo
//
//  Created by itdept on 14-11-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^call_back)(void);
typedef enum : NSUInteger {
    kRequestAll,
    kRequestOne,
} RequestType;

@interface Web_get_chart_data : NSObject

@property(nonatomic,strong)call_back callBack;

+ (Web_get_chart_data*)fn_shareInstance;

- (void) fn_get_chart_data:(NSString*)base_url uid:(NSString*)unique_id type:(RequestType)requestType;

- (void)fn_asyn_get_all_charts;

- (NSMutableDictionary*)fn_get_ChartImages;

- (NSString*)fn_get_language_type;

- (NSMutableArray*)fn_get_DtlResult_data:(NSString*)unique_id;

@end

