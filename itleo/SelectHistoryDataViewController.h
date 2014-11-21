//
//  SelectHistoryDataViewController.h
//  itleo
//
//  Created by itdept on 14-8-28.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBack_code)(NSMutableDictionary*);
@interface SelectHistoryDataViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)callBack_code callback;
@property (strong,nonatomic)NSMutableArray *alist_sys_code;
@property (copy,nonatomic)NSString *field_name;
@property (assign,nonatomic)NSInteger flag_type;
@property (weak, nonatomic) IBOutlet UILabel *ilb_title;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)fn_cancel_select_data:(id)sender;

@end
