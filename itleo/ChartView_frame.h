//
//  ChartView_frame.h
//  itleo
//
//  Created by itdept on 14-11-14.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView_frame : UIView<UITableViewDataSource,UITableViewDelegate>

@property (copy,nonatomic)NSString *chart_type;//图表类型
@property (strong,nonatomic)NSArray *alist_values;//图表值
@property (strong,nonatomic)NSArray *alist_options;//图表选项

@property (strong,nonatomic)NSArray *alist_remarks;//图例项附注
@property (strong,nonatomic)NSArray *alist_colors;//图例项颜色

@property (weak, nonatomic) IBOutlet UILabel *ilb_chartTitle;//图表标题
@property (weak, nonatomic) IBOutlet UIView *iv_chart;//装载图表

+(ChartView_frame*)fn_shareInstance;

@end
