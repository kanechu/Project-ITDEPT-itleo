//
//  DB_ePod.h
//  itleo
//
//  Created by itdept on 14-9-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatabaseQueue;
@class Truck_order_data;

@interface DB_ePod : NSObject

@property(nonatomic,strong)DatabaseQueue *queue;

-(BOOL)fn_save_ePod_data:(Truck_order_data*)upload_ms image_ms:(NSMutableArray*)alist_image_ms;
-(NSMutableArray*)fn_select_ePod_data:(NSString*)order_no vehicle_no:(NSString*)vehicle_no;
-(NSMutableArray*)fn_select_ePod_data_no_image:(NSString*)order_no vehicle_no:(NSString*)vehicle_no;

-(NSMutableArray*)fn_select_unUpload_truck_order_data:(NSString*)isUploaded1 isUploade2:(NSString*)isUploaded2;
-(NSMutableArray*)fn_select_unUpload_ePod_data:(NSString*)is_uploaded;
-(NSMutableArray*)fn_select_unUpload_record:(NSString*)is_uploaded;
-(NSMutableArray*)fn_select_unUpload_ePod_data_amount:(NSString*)is_uploaded;
-(NSMutableArray*)fn_select_ePod_data:(NSString*)millisecond;
-(NSMutableArray*)fn_select_all_ePod_data;
-(BOOL)fn_update_epod_after_uploaded:(NSString*)unique_id is_uploaded:(NSString*)is_uploaded date:(NSString*)date result:(NSString*)result user_code:(NSString*)user_code system:(NSString*)system images:(NSSet*)alist_images_result;

-(BOOL)fn_delete_epod_data:(int)unique_id;

-(BOOL)fn_delete_all_epod_data;

@end
