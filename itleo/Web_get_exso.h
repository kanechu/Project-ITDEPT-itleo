//
//  Web_get_exso.h
//  itleo
//
//  Created by itdept on 14-12-8.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Web_base.h"
@interface Web_get_exso : NSObject

@property (nonatomic,strong)callBack_resp_result callBack_exso;

-(void)fn_get_exso_data:(NSString*)so_no;

@end
