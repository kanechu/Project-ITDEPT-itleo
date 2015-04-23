//
//  Cell_order_detail_list.h
//  itleo
//
//  Created by itdept on 15/4/16.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_order_detail_list : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView_detail;

@property (nonatomic, strong) NSDictionary *dic_order_dtl;

@property (nonatomic, assign) CGFloat height;

@end
