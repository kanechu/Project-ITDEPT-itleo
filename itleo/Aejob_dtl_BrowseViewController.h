//
//  Aejob_dtl_BrowseViewController.h
//  itleo
//
//  Created by itdept on 14-8-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"DetailView.h"

@interface Aejob_dtl_BrowseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSMutableDictionary *idic_aejob_browse;

@property (weak, nonatomic) IBOutlet DetailView *iv_detailView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
