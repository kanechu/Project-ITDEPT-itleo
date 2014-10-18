//
//  Cell_ShowRecords.h
//  itleo
//
//  Created by itdept on 14-9-23.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Checkbox;
@interface Cell_ShowRecords : UITableViewCell

@property(nonatomic,strong)Checkbox *ibox_Delete;
@property (weak, nonatomic) IBOutlet UILabel *ilb_vehicle_no;
@property (weak, nonatomic) IBOutlet UILabel *ilb_order_no;
@property (weak, nonatomic) IBOutlet UILabel *ilb_status;

@property (weak, nonatomic) IBOutlet UILabel *ilb_result;
@property (weak, nonatomic) IBOutlet UILabel *ilb_date;
@property (weak, nonatomic) IBOutlet UILabel *ilb_delete;



@end
