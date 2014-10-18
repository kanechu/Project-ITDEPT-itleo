//
//  Order_InfoViewController.h
//  itleo
//
//  Created by itdept on 14-10-4.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Order_InfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (copy, nonatomic) NSString *order_no;
@property (copy, nonatomic) NSString *car_no;

@property (weak, nonatomic) IBOutlet UILabel *ilb_order_title;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *ibtn_back;
- (IBAction)fn_back_previons_page:(id)sender;

@end
