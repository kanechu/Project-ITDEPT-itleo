//
//  Record_LoadPlanViewController.h
//  itleo
//
//  Created by itdept on 14-12-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_BtnGraphicMixed.h"
typedef enum {
    kWarehouse_add,
    kWarehouse_edit,
    kWarehouse_del
}KWarehouse_Operation;
typedef void (^callBack_excfsdim)(NSMutableArray *alist_result,KWarehouse_Operation op);
@interface Record_LoadPlanViewController : UIViewController<UITextFieldDelegate>

@property (strong,nonatomic)callBack_excfsdim callback;

@property (assign,nonatomic)NSInteger flag_isAdd;
@property (strong,nonatomic)NSMutableDictionary *idic_received_log;
@property (strong,nonatomic)NSMutableDictionary *idic_exsoBrowse;

@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_itleo_logo;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_delete;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_save;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_clear;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_cancel;

- (IBAction)fn_delete_data:(id)sender;
- (IBAction)fn_save_data:(id)sender;
- (IBAction)fn_clear_input_data:(id)sender;
- (IBAction)fn_cancel_input_data:(id)sender;

@end
