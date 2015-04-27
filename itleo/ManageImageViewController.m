//
//  ManageImageViewController.m
//  itleo
//
//  Created by itdept on 14-9-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "ManageImageViewController.h"
#import "PopSignUtil.h"
#import "Cell_show_picture.h"
#import "image_magnify_shrink.h"
#import "AddRemarkViewController.h"
#import "HistoryCaptureViewController.h"
#import "PopViewManager.h"
#import "Truck_order_image_data.h"
#import "Custom_BtnGraphicMixed.h"
#import "Identifi_bridgeViewController.h"

@interface ManageImageViewController (){
    UIView *background;
}
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_title_logo;
@property(nonatomic,assign)NSInteger flag_item;
//标识弹出的警告
@property(nonatomic,assign)NSInteger flag_alert;

@end

@implementation ManageImageViewController
@synthesize flag_item;
@synthesize alist_image_ms;

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
    [self fn_set_control_pro];
    [self fn_set_collectionView_pro];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_set_control_pro{
    if (alist_image_ms==nil) {
        alist_image_ms=[NSMutableArray array];
    }
    [_ibtn_backItem setTitle:MY_LocalizedString(@"lbl_back", nil)];
    [_ibtn_title_logo setTitle:MY_LocalizedString(@"ibtn_image_mang", nil) forState:UIControlStateNormal];
    [_ibtn_title_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    
    _ilb_order_no.text=[NSString stringWithFormat:@"%@:",MY_LocalizedString(@"lbl_order_no", nil)];
    _itf_order_no.text=_is_order_no;
    _itf_order_no.layer.borderColor=[UIColor lightGrayColor].CGColor;

    _ilb_imges.text=MY_LocalizedString(@"lbl_pictures", nil);
    [_ibtn_delete_all setTitle:MY_LocalizedString(@"ibtn_delete_all", nil) forState:UIControlStateNormal];
        
    _ibtn_photograph.left_icon=[UIImage imageNamed:@"ic_camera"];
    [_ibtn_photograph setTitle:MY_LocalizedString(@"ibtn_photo", nil) forState:UIControlStateNormal];
    [_ibtn_photograph addTarget:self
                         action:@selector(fn_take_a_picture:) forControlEvents:UIControlEventTouchUpInside];
    
    _ibtn_receiving.left_icon=[UIImage imageNamed:@"ic_signature"];
    [_ibtn_receiving setTitle:MY_LocalizedString(@"ibtn_sign", nil) forState:UIControlStateNormal];
    [_ibtn_receiving addTarget:self action:@selector(fn_signature:) forControlEvents:UIControlEventTouchUpInside];
    
    _ibtn_select_picture.left_icon=[UIImage imageNamed:@"ibtn_add"];
    [_ibtn_select_picture setTitle:MY_LocalizedString(@"ibtn_choose", nil) forState:UIControlStateNormal];
    [_ibtn_select_picture addTarget:self action:@selector(fn_select_picture:) forControlEvents:UIControlEventTouchUpInside];
    
    _ibtn_history_capture.left_icon=[UIImage imageNamed:@"ic_history"];
    [_ibtn_history_capture setTitle:MY_LocalizedString(@"ibtn_history_capture", nil) forState:UIControlStateNormal];
    [_ibtn_history_capture addTarget:self action:@selector(fn_look_history_capture:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(Truck_order_image_data*)fn_set_upload_image_ms:(UIImage*)image{
    Truck_order_image_data *upload_image_ms=[[Truck_order_image_data alloc]init];
    upload_image_ms.image=[Conversion_helper fn_image_convert_base64Str:image];
    upload_image_ms.image_isUploaded=@"0";
    return upload_image_ms;
}

#pragma mark -event action
//拍照
-(void)fn_take_a_picture:(id)sender{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    imagePicker.sourceType=sourceType;
    imagePicker.allowsEditing=YES;
    [self presentViewController:imagePicker animated:YES completion:^(){}];
}
//签收
-(void)fn_signature:(id)sender{

    [PopSignUtil getSignWithVC:self bgImage:nil withOk:^(UIImage *image) {
        [PopSignUtil closePop];
        [alist_image_ms addObject:[self fn_set_upload_image_ms:image]];
        [self.conllectionview reloadData];
    } withVerify:^(UIImage *verifyImage){

        UINavigationController *nav_vc=[self.storyboard instantiateViewControllerWithIdentifier:@"navigation"];
        NSArray *root=[nav_vc viewControllers];
        Identifi_bridgeViewController *identifiVC=[root firstObject];
        identifiVC.client_image=verifyImage;
        identifiVC.dic_order=_dic_order;
        [self presentViewController:nav_vc animated:YES completion:nil];
    }withCancel:^{
        
        [PopSignUtil closePop];
    }];
}
//选取
-(void)fn_select_picture:(id)sender{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    imagePicker.sourceType=sourceType;
    imagePicker.allowsEditing=YES;
    [self presentViewController:imagePicker animated:YES completion:^(){}];
    
}
//查看历史采集的数据
-(void)fn_look_history_capture:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_history_capture" sender:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"selectImg" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_add_image:) name:@"selectImg" object:nil];
}

- (IBAction)fn_back_previous_page:(id)sender {
    if (_callBack) {
        _callBack(alist_image_ms);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fn_delete_image:(id)sender {
    _flag_alert=1;
    [self fn_popUp_alertView:MY_LocalizedString(@"delete_all_image", nil)];
}
//在放大模式选择图片后，触发的方法
- (void)fn_add_image:(NSNotification*)notification{
    Truck_order_image_data *img_ms=(Truck_order_image_data*)[notification object];
    if (img_ms!=nil) {
        [alist_image_ms addObject:img_ms];
        [self.conllectionview reloadData];
    }
    img_ms=nil;
}
#pragma mark -UIImagePickerControllerDelegate
//选择完毕
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^(){}];
    UIImage *image=[info valueForKey:UIImagePickerControllerOriginalImage];
    [alist_image_ms addObject:[self fn_set_upload_image_ms:image]];
    [self.conllectionview reloadData];
}

#pragma mark -show picture
-(void)fn_set_collectionView_pro{
    self.conllectionview.delegate=self;
    self.conllectionview.dataSource=self;
    [self.conllectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell_picture"];
}
#pragma mark UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [alist_image_ms count];
}
// 一个collectionView中的分区数
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Cell_show_picture *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_show_picture" forIndexPath:indexPath];
    NSInteger  li_item=[indexPath item];
    Truck_order_image_data *upload_image_ms=[alist_image_ms objectAtIndex:li_item];
    UIImage *image=[Conversion_helper fn_base64Str_convert_image:upload_image_ms.image];
    cell.i_image.image=image;
    cell.i_UploadedImage.hidden=YES;
    cell.i_UploadedImage.image=[UIImage imageNamed:@"selected"];
    return cell;
}
#pragma mark -UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet *my_sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:MY_LocalizedString(@"lbl_magnigy", nil),MY_LocalizedString(@"lbl_delete_img", nil),MY_LocalizedString(@"lbl_text_remark", nil),MY_LocalizedString(@"lbl_draw_remark", nil), nil];
    //重置上载状态MY_LocalizedString(@"lbl_reset", nil)

    [my_sheet showInView:self.view];
    flag_item=indexPath.item;
}
#pragma mark – UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(10, 0, 0, 0);
}
#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=[actionSheet cancelButtonIndex]) {
        Truck_order_image_data *upload_image_ms=(Truck_order_image_data*)[alist_image_ms objectAtIndex:flag_item];
        if (buttonIndex==0) {
            [self fn_image_magnify:flag_item];
        }
        if (buttonIndex==1) {
            _flag_alert=2;
            [self fn_popUp_alertView:MY_LocalizedString(@"delete_image", nil)];
        }
        if (buttonIndex==2) {
            AddRemarkViewController *remarkVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AddRemarkViewController"];
            remarkVC.remarked=upload_image_ms.image_remark;
            remarkVC.callback=^(NSString *remark){
                if ([remark length]!=0) {
                    upload_image_ms.image_remark=remark;
                }
            };
            PopViewManager *pop_obj=[[PopViewManager alloc]init];
            [pop_obj fn_PopupView:remarkVC Size:CGSizeMake(220, 220) uponView:self];
            
        }
        if (buttonIndex==3) {
            UIImage *image=[Conversion_helper fn_base64Str_convert_image:upload_image_ms.image];
            [PopSignUtil getSignWithVC:self bgImage:image withOk:^(UIImage *image) {
                [PopSignUtil closePop];
                upload_image_ms.image=[Conversion_helper fn_image_convert_base64Str:image];
                [self.conllectionview reloadData];
            } withVerify:^(UIImage *image){
                
            } withCancel:^{
                
                [PopSignUtil closePop];
            }];
        }
        /*重置上载状态
        if (buttonIndex==4) {
            upload_image_ms.image_isUploaded=@"0";
            [self.conllectionview reloadData];
        }*/
    }
}
-(void)deleteItemsFromDataSourceAtIndexPaths:(NSArray  *)itemPaths
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *itemPath  in itemPaths) {
        [indexSet addIndex:itemPath.row];
        
    }
    [self.alist_image_ms removeObjectsAtIndexes:indexSet]; // self.alist_image is my data source
}
#pragma mark  -pop up alertView
-(void)fn_popUp_alertView:(NSString*)str_prompt{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:str_prompt delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_cancel", nil) otherButtonTitles:MY_LocalizedString(@"lbl_ok", nil), nil];
    [alertView show];
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (_flag_alert==1) {
            [alist_image_ms removeAllObjects];
            [self.conllectionview reloadData];
        }
        if (_flag_alert==2) {
            NSArray *selectedItemsIndexPaths=[self.conllectionview indexPathsForSelectedItems];
            [self deleteItemsFromDataSourceAtIndexPaths:selectedItemsIndexPaths];
            [self.conllectionview deleteItemsAtIndexPaths:selectedItemsIndexPaths];
        }
    }
}
#pragma mark -图片放大 or 缩小
- (void)fn_image_magnify:(NSInteger)flag_item1{
    image_magnify_shrink *image_ctrl=[[image_magnify_shrink alloc]init];
    Truck_order_image_data *obj=[alist_image_ms objectAtIndex:flag_item1];
    UIImage *image=[Conversion_helper fn_base64Str_convert_image:obj.image];
    background=[image_ctrl fn_image_magnify:self image:image];
}
- (void)fn_image_shrink{
    [background removeFromSuperview];
}
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier]isEqualToString:@"segue_history_capture"]) {
        HistoryCaptureViewController *historyCaptureVC=(HistoryCaptureViewController*)[segue destinationViewController];
        historyCaptureVC.alist_image_ms=_alist_historyImage_ms;
        historyCaptureVC.callBack=^(NSMutableArray *alist_images){
            if (alist_images!=nil) {
                [alist_image_ms addObjectsFromArray:alist_images];
                [self.conllectionview reloadData];
            }
        };
    }
}
@end
