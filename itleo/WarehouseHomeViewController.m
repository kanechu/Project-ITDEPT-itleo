//
//  WarehouseHomeViewController.m
//  itleo
//
//  Created by itdept on 14-12-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "WarehouseHomeViewController.h"
#import "Record_LoadPlanViewController.h"
@interface WarehouseHomeViewController ()

@end

@implementation WarehouseHomeViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)fn_add_load_plan_row:(id)sender {
    Record_LoadPlanViewController *record_VC=(Record_LoadPlanViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Record_LoadPlanViewController"];
    [self presentViewController:record_VC animated:YES completion:nil];
}
@end
