//
//  DrawSignView.h
//  YRF
//
//  Created by jun.wang on 14-5-28.
//  Copyright (c) 2014年 王军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyView.h"

typedef void(^SignCallBackBlock) (UIImage*);
typedef void(^CallBackBlock) ();

@interface DrawSignView : UIView

@property(nonatomic,copy)SignCallBackBlock signCallBackBlock;
@property(nonatomic,copy) SignCallBackBlock verifyCallBackBlock;
@property(nonatomic,copy)CallBackBlock cancelBlock;


-(void)fn_set_bgImage:(UIImage*)image;

@end
