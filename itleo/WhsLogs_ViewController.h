//
//  WhsLogs_ViewController.h
//  itleo
//
//  Created by itdept on 15-1-2.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhsLogs_ViewController : UIViewController

@property (copy, nonatomic) NSString *str_upload_type;
//存储UPLOAD_COL
@property (nonatomic, nonatomic) NSMutableArray *alist_cols;
@property (copy, nonatomic) NSString *lang_code;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
