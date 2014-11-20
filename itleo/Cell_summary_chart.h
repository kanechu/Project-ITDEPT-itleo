//
//  Cell_summary_chart.h
//  itleo
//
//  Created by itdept on 14-11-20.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell_summary_chart : UICollectionViewCell
@property(nonatomic,assign)NSInteger flag_summary_type;
@property (weak, nonatomic) IBOutlet UIImageView *img_summary_chart;

@end
