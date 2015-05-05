//
//  UploadContract.h
//  itleo
//
//  Created by itdept on 14-9-30.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadContract : NSObject

@property(nonatomic, strong) AuthContract *Auth;

@property(nonatomic, strong) UpdateFormContract *UpdateForm;

@end
