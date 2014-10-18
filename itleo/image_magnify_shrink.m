//
//  image_magnify_shrink.m
//  ImageMagnifyDemo
//
//  Created by itdept on 14-9-15.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "image_magnify_shrink.h"
#import <QuartzCore/QuartzCore.h>
#define mainBounds [[UIScreen mainScreen]bounds]
#define BIG_IMG_WIDTH  300.0
#define BIG_IMG_HEIGHT 300.0
@interface image_magnify_shrink ()
{
    UIView *background;
}
@end

@implementation image_magnify_shrink

- (UIView*)fn_image_magnify:(UIViewController*)VC image:(UIImage*)image{
   
    //创建灰色背景，使其背后内容不可操作
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, mainBounds.size.width, mainBounds.size.height)];
    background=bgView;
    [bgView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7]];
    [VC.view addSubview:bgView];
    //创建边框视图
    UIView *borderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, BIG_IMG_WIDTH+16, BIG_IMG_HEIGHT+16)];
    borderView.backgroundColor=[UIColor whiteColor];
    //将图层的边框设置为圆角
    borderView.layer.cornerRadius=5;
    borderView.layer.masksToBounds=YES;
    //给图层添加一个有色边框
    borderView.layer.borderWidth = 6;
    borderView.layer.borderColor = [[UIColor colorWithRed:0.9
                                                    green:0.9
                                                     blue:0.9
                                                    alpha:0.7]CGColor];
    [borderView setCenter:bgView.center];
    [bgView addSubview:borderView];
    
    //创建显示图像视图
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, BIG_IMG_WIDTH, BIG_IMG_HEIGHT)];
    [imgView setImage:image];
    [borderView addSubview:imgView];
    [self fn_shakeToShow:borderView];//放大过程中的动画
    imgView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:VC action:@selector(fn_image_shrink)];
    [imgView addGestureRecognizer:tapGesture];
   
    //动画效果
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:2.0];//动画时间长度，单位秒，浮点数
    [VC.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [UIView setAnimationDelegate:bgView];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:nil];
    [UIView commitAnimations];
    return background;
    
}
- (void)fn_image_shrink{
    [background removeFromSuperview];
}
- (void)fn_shakeToShow:(UIView*)view{
         CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
         animation.duration = 0.5;
         
         NSMutableArray *values = [NSMutableArray array];
         [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
         [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
         animation.values = values;
         [view.layer addAnimation:animation forKey:nil];
}

@end
