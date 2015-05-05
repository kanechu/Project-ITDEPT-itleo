//
//  reqExhblContract.h
//  worldtrans
//
//  Created by itdept on 2/18/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateForm_orderList.h"
@interface RequestContract : NSObject

@property(nonatomic, strong) NSSet *SearchForm;

@property(nonatomic, strong) AuthContract *Auth;

@property(nonatomic, strong) UpdateForm_orderList *UpdateForm;

@end
