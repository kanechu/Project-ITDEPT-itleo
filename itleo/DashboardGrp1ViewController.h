//
//  DashboardGrpViewController.h
//  itleo
//
//  Created by itdept on 14-11-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardGrp1ViewController : UIViewController

@property(nonatomic, copy) NSString *unique_id;
@property(nonatomic, copy) NSString *language;

@property (weak, nonatomic) IBOutlet UIScrollView *iscrollView;
@end
