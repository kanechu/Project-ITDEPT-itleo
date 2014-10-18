//
//  Cell_status_list.h
//  itleo
//
//  Created by itdept on 14-9-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
@interface Cell_status_list : UITableViewCell

@property (assign,nonatomic)NSInteger flag_enable;
@property (weak, nonatomic) IBOutlet QRadioButton *ibtn_radio;
@property (weak, nonatomic) IBOutlet UITextField *itf_declare;

@end
