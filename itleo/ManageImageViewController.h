//
//  ManageImageViewController.h
//  itleo
//
//  Created by itdept on 14-9-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom_Button.h"
typedef void (^callBack_image)(NSMutableArray*);
@interface ManageImageViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)callBack_image callBack;
@property(nonatomic,copy)NSString *is_order_no;
//存储每张图片的信息（一条记录）
@property(nonatomic,strong)NSMutableArray *alist_image_ms;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_backItem;
@property (weak, nonatomic) IBOutlet UILabel *ilb_order_no;
@property (weak, nonatomic) IBOutlet UITextField *itf_order_no;

@property (weak, nonatomic) IBOutlet UILabel *ilb_imges;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_delete_all;

@property (weak, nonatomic) IBOutlet UICollectionView *conllectionview;

@property (weak, nonatomic) IBOutlet Custom_Button *ibtn_photograph;
@property (weak, nonatomic) IBOutlet Custom_Button *ibtn_receiving;
@property (weak, nonatomic) IBOutlet Custom_Button *ibtn_select_picture;

- (IBAction)fn_delete_image:(id)sender;
- (IBAction)fn_back_previous_page:(id)sender ;
@end
