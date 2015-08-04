//
//  MainHomeViewController.h
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_BtnGraphicMixed.h"
@interface MainHomeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *icollectionView;
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_home_logo;

- (IBAction)fn_click_menu:(id)sender;

@end
