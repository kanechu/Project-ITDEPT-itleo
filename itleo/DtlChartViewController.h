//
//  DtlChartViewController.h
//  itleo
//
//  Created by itdept on 14-11-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DtlChartViewController : UIViewController

@property (copy,nonatomic)NSString *chart_type;//图表类型
@property (strong,nonatomic)NSArray *alist_values;//图表值
@property (strong,nonatomic)NSArray *alist_options;//图表选项

@property (strong,nonatomic)NSArray *alist_remarks;//图例项附注
@property (strong,nonatomic)NSArray *alist_colors;//图例项颜色
@property (copy,nonatomic)NSString *chartTitle;//图表标题
@end
