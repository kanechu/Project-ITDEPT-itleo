//
//  Cell_load_plan.h
//  itleo
//
//  Created by itdept on 14-12-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_load_plan : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ilb_kgs_per_pkg;
@property (weak, nonatomic) IBOutlet UILabel *ilb_pkg;
@property (weak, nonatomic) IBOutlet UILabel *ilb_cbm;
@property (weak, nonatomic) IBOutlet UILabel *ilb_length;
@property (weak, nonatomic) IBOutlet UILabel *ilb_width;
@property (weak, nonatomic) IBOutlet UILabel *ilb_height;
@property (weak, nonatomic) IBOutlet UILabel *ilb_remark;

@end
