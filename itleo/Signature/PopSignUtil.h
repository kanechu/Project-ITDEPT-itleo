//
//  PopSignUtil.h
//  YRF
//
//  Created by jun.wang on 14-5-28.
//  Copyright (c) 2014年 王军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawSignView.h"



@interface PopSignUtil : UIView
@property(nonatomic,copy)CallBackBlock noB;

+(void)getSignWithVC:(UIViewController *)VC
             bgImage:(UIImage*)bgImage
              withOk:(SignCallBackBlock)signCallBackBlock
          withVerify:(SignCallBackBlock)verifyCallBackBlock
          withCancel:(CallBackBlock)callBackBlock;
+(void)closePop;
@end
