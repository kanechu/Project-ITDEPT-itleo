//
//  RangeSelectViewController.h
//  itleo
//
//  Created by itdept on 14-10-27.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, kRange_type) {
    kDate_range,
    kOrder_interval_range,
    kGPS_interval_range,
    kWhs_interval_range,
};
@interface RangeSelectViewController : UITableViewController

//标识已选取的日期范围 或 时间间隔 key
@property (nonatomic,copy)NSString *str_range;

//用于标记，是选取搜索日期范围还是传输数据间隔
@property (nonatomic,assign)kRange_type range_type;

@end
