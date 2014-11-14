//
//  LegendItem_view.h
//  itleo
//
//  Created by itdept on 14-11-14.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegendItem_view : UIView
@property (weak, nonatomic) IBOutlet UILabel *ilb_color;
@property (weak, nonatomic) IBOutlet UILabel *ilb_remark;//附注
+(LegendItem_view*)fn_shareInstance;

@end
