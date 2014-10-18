//
//  Cell_epod_record.h
//  itleo
//
//  Created by itdept on 14-9-16.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_epod_record : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ilb_order_no;
@property (weak, nonatomic) IBOutlet UILabel *ilb_status;
@property (weak, nonatomic) IBOutlet UILabel *ilb_error_date;
@property (weak, nonatomic) IBOutlet UILabel *ilb_delete;

@end
