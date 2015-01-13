//
//  Cell_advance_search.h
//  itleo
//
//  Created by itdept on 14-8-13.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_textField.h"
typedef enum {
    kNum_keyboard,
    kDecimal_keyboard,
    kDefault_keyboard
}keyBoard_type;
@interface Cell_advance_search : UITableViewCell
@property (weak, nonatomic) IBOutlet Custom_textField *itf_inputdata;
@property (weak, nonatomic) IBOutlet UILabel *il_prompt;
@property (assign, nonatomic) NSInteger flag_enable;
@property (assign, nonatomic) keyBoard_type keyboardType;
@end
