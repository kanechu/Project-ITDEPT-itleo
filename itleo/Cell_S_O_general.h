//
//  Cell_S_O_general.h
//  itleo
//
//  Created by itdept on 14-12-3.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_S_O_general : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ilb_title_vsl_voy;
@property (weak, nonatomic) IBOutlet UILabel *ilb_vsl_voy;
@property (weak, nonatomic) IBOutlet UILabel *ilb_title_shipper;
@property (weak, nonatomic) IBOutlet UILabel *ilb_shipper;
@property (weak, nonatomic) IBOutlet UILabel *ilb_title_consignee;
@property (weak, nonatomic) IBOutlet UILabel *ilb_consignee;
@property (weak, nonatomic) IBOutlet UILabel *ilb_title_loadPort;
@property (weak, nonatomic) IBOutlet UILabel *ilb_loadPort;
@property (weak, nonatomic) IBOutlet UILabel *ilb_title_dishPort;
@property (weak, nonatomic) IBOutlet UILabel *ilb_dishPort;
@property (weak, nonatomic) IBOutlet UILabel *ilb_title_destination;
@property (weak, nonatomic) IBOutlet UILabel *ilb_destination;

@end
