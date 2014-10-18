//
//  DetailView.h
//  itleo
//
//  Created by itdept on 14-8-14.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imag_detail_icon;
@property (weak, nonatomic) IBOutlet UILabel *il_uld_type;
@property (weak, nonatomic) IBOutlet UILabel *il_uld_no;
@property (weak, nonatomic) IBOutlet UILabel *il_pkg;
@property (weak, nonatomic) IBOutlet UILabel *il_kgs;
@property (weak, nonatomic) IBOutlet UILabel *il_cbf;
@property (weak, nonatomic) IBOutlet UILabel *il_flight;
@property (weak, nonatomic) IBOutlet UILabel *il_airline;
@property (weak, nonatomic) IBOutlet UILabel *il_job_no;
@end
