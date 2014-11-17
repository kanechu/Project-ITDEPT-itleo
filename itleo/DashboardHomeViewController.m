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
#import "Conversion_helper.h"
#import "DB_Chart.h"
#import "DB_LoginInfo.h"
@interface DashboardHomeViewController ()

@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) NSMutableArray *alist_GrpResult;

@end

@implementation DashboardHomeViewController
@synthesize segment;
@synthesize currentViewController;
@synthesize containerView;

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
    [self fn_set_segmentControl_title];
    
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
-(void)fn_set_segmentControl_title{
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    _alist_GrpResult=[db_chart fn_get_DashboardGrpDResult_data];
    //根据unique_id给数组升序排序
    _alist_GrpResult=[Conversion_helper fn_sort_the_array:_alist_GrpResult key:@"unique_id"];
    NSString *lang_code=[self fn_get_language_type];
    NSInteger i=0;
    for (NSMutableDictionary *dic in _alist_GrpResult) {
        NSString *grp_title=@"";
        if ([lang_code isEqualToString:@"EN"]) {
            grp_title=[dic valueForKey:@"grp_title_en"];
        }
        if ([lang_code isEqualToString:@"CN"]) {
            grp_title=[dic valueForKey:@"grp_title_cn"];
        }
        [segment setTitle:grp_title forSegmentAtIndex:i];
        i++;
    }
     
}
-(NSString*)fn_get_language_type{
    DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
    NSMutableArray *arr=[db fn_get_all_LoginInfoData];
    NSString *lang_code=@"";
    if ([arr count]!=0) {
        lang_code=[[arr objectAtIndex:0]valueForKey:@"lang_code"];
    }
    return lang_code;
}
-(NSString*)fn_get_group_id:(NSInteger)index{
    NSString *group_id=@"";
    if (index<[_alist_GrpResult count]) {
        NSMutableDictionary *dic=[_alist_GrpResult objectAtIndex:index];
        group_id=[dic valueForKey:@"unique_id"];
    }
    return group_id;
}
#pragma mark -get relate ViewController
- (UIViewController *)fn_viewControllerForSegmentIndex:(NSInteger)index {
    NSString *group_id=[self fn_get_group_id:index];
    DashboardGrp1ViewController *grp1VC;
    DashboardGrp2ViewController *grp2VC;
    DashboardGrp3ViewController *grp3VC;
    switch (index) {
        case 0:
            grp1VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardGrp1ViewController"];
            grp1VC.unique_id=group_id;
            grp1VC.language=[self fn_get_language_type];
            return grp1VC;
            break;
        case 1:
            grp2VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardGrp2ViewController"];
            grp2VC.unique_id=group_id;
            grp2VC.language=[self fn_get_language_type];
            return grp2VC;
            break;
        case 2:
            grp3VC = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardGrp3ViewController"];
            grp3VC.unique_id=group_id;
            grp3VC.language=[self fn_get_language_type];
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
