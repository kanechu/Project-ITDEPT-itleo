//
//  Aejob_AdvanceSearchViewController.h
//  itleo
//
//  Created by itdept on 14-8-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_BtnGraphicMixed.h"
typedef void (^callBack_arr)( NSMutableArray*);
@interface Aejob_AdvanceSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) callBack_arr callback;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_search_logo;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_search;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_clear;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;

- (IBAction)fn_Search_aejob:(id)sender;
- (IBAction)fn_clear_textfield:(id)sender;
- (IBAction)fn_cancel_searchAejob:(id)sender;

@end
