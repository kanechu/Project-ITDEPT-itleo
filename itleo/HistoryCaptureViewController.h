//
//  HistoryCaptureViewController.h
//  itleo
//
//  Created by itdept on 15/3/3.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBack_images)(NSMutableArray *);
@interface HistoryCaptureViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *alist_image_ms;
@property (nonatomic, strong) callBack_images callBack;
@end
