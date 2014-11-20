//
//  ChartViewController.h
//  itleo
//
//  Created by itdept on 14-9-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartData_handler.m"

@interface DashboardHomeViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
- (IBAction)fn_segment_valueChange:(id)sender;


@end
