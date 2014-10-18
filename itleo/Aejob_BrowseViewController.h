//
//  Aejob_BrowseViewController.h
//  itleo
//
//  Created by itdept on 14-8-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "Custom_textField.h"
@interface Aejob_BrowseViewController : UIViewController<SKSTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *ibtn_search;

@property (weak, nonatomic) IBOutlet Custom_textField *itf_textfield;
@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;

- (IBAction)fn_search_aejob:(id)sender;
- (IBAction)fn_advance_search_aejob:(id)sender;
- (IBAction)fn_textfield_begin_edit:(id)sender;
- (IBAction)fn_textfield_end_edit:(id)sender;

@end
