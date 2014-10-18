//
//  Menu_home.h
//  itleo
//
//  Created by itdept on 14-8-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu_home : NSObject

@property(nonatomic,copy) NSString *is_label;
@property(nonatomic,copy) NSString *is_image;
@property(nonatomic,copy) NSString *is_segue;

+ (id)fn_create_item:(NSString*)as_label image:(NSString*)as_image segue:(NSString*)as_segue;

@end
