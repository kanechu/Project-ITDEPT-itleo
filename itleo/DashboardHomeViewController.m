//
//  ChartViewController.m
//  itleo
//
//  Created by itdept on 14-9-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DashboardHomeViewController.h"
#import "DashboardGrp1ViewController.h"
#import "DashboardGrp2ViewController.h"
#import "DashboardGrp3ViewController.h"
#import "DB_Chart.h"
@interface DashboardHomeViewController ()

@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) NSMutableArray *alist_GrpResult;
@property (nonatomic, copy) NSString *group_id;

@end

@implementation DashboardHomeViewController
@synthesize segment;
@synthesize currentViewController;
@synthesize containerView;
@synthesize group_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fn_get_GrpResult_data];
    
    //  for adjust segment widths based on their content widths
    [self.segment setApportionsSegmentWidthsByContent:YES];
    //add viewController so you can switch them later
    UIViewController *vc=[self fn_viewControllerForSegmentIndex:segment.selectedSegmentIndex];
    [self addChildViewController:vc];
    [self.containerView addSubview:vc.view];
    self.currentViewController = vc;
  	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_get_GrpResult_data{
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    _alist_GrpResult=[db_chart fn_get_DashboardGrpDResult_data];
     
}
-(void)fn_set_group_id:(NSInteger)index{
    NSString *grp_code_value=@"";
    switch (index) {
        case 0:
            grp_code_value=@"SHIPMENT_SUMMARY";
            break;
        case 1:
            grp_code_value=@"TESTGRP2";
            break;
        case 2:
            grp_code_value=@"TESTGRP3";
            break;
            
        default:
            break;
    }
    for (NSMutableDictionary *dic in _alist_GrpResult) {
        NSString *grp_code=[dic valueForKey:@"grp_code"];
        if ([grp_code isEqualToString:grp_code_value]) {
            group_id=[dic valueForKey:@"unique_id"];
        }
    }
}
- (UIViewController *)fn_viewControllerForSegmentIndex:(NSInteger)index {
    [self fn_set_group_id:index];
    DashboardGrp1ViewController *grp1VC;
    DashboardGrp2ViewController *grp2VC;
    DashboardGrp3ViewController *grp3VC;
    switch (index) {
        case 0:
            grp1VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardGrp1ViewController"];
            grp1VC.unique_id=group_id;
            return grp1VC;
            break;
        case 1:
            grp2VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardGrp2ViewController"];
            grp2VC.unique_id=group_id;
            return grp2VC;
            break;
        case 2:
            grp3VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardGrp3ViewController"];
            grp3VC.unique_id=group_id;
            return grp3VC;
            break;
    }
    return grp1VC;
}


- (IBAction)fn_segment_valueChange:(id)sender {
    UIViewController *vc = [self fn_viewControllerForSegmentIndex:segment.selectedSegmentIndex];
    [self addChildViewController:vc];
    [self transitionFromViewController:self.currentViewController toViewController:vc duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.currentViewController.view removeFromSuperview];
        self.containerView.frame=CGRectMake(0, 64,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64);
        vc.view.frame = self.containerView.bounds;
        [self.containerView addSubview:vc.view];
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:self];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = vc;
    }];
}

@end
