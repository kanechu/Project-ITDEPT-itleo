//
//  ChartViewController.h
//  itleo
//
//  Created by itdept on 14-9-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardHomeViewController : UIViewController

@property (copy, nonatomic) NSString *language;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)fn_segment_valueChange:(id)sender;

@end
