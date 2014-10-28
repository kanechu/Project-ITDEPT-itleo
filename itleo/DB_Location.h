//
//  DB_Location.h
//  itleo
//
//  Created by itdept on 14-9-24.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseQueue.h"
@interface DB_Location : NSObject
@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_loaction_data:(NSString*)longitude latitude:(NSString*)latitude car_no:(NSString*)car_no;

-(NSMutableArray*)fn_get_location_data:(NSString*)is_uploaded;

-(BOOL)fn_update_isUploaded_status:(NSString*)unique isUploaded:(NSString*)is_uploaded;

-(BOOL)fn_delete_location_data;

@end
