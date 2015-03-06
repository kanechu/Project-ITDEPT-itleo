//
//  HistoryCaptureViewController.m
//  itleo
//
//  Created by itdept on 15/3/3.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "HistoryCaptureViewController.h"
#import "Cell_show_picture.h"
#import "Truck_order_image_data.h"
#import "Custom_BtnGraphicMixed.h"

@interface HistoryCaptureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_history_logo;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_select;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_back;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_ok;

@property (strong,nonatomic) NSMutableArray *alist_history_img;

@end

@implementation HistoryCaptureViewController
@synthesize alist_image_ms;
@synthesize alist_history_img;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fn_set_control_property];
    [self fn_set_collectionView_pro];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_control_property{
 
    [_ibtn_history_logo setTitle:MY_LocalizedString(@"ibtn_history_capture", nil) forState:UIControlStateNormal];
    [_ibtn_history_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    
    [_ibtn_select setTitle:MY_LocalizedString(@"lbl_select", nil) forState:UIControlStateNormal];
    [_ibtn_select setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateSelected];
    
    [_ibtn_back setTitle:MY_LocalizedString(@"lbl_back", nil) forState:UIControlStateNormal];
    _ibtn_back.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _ibtn_back.layer.borderWidth=1;
    _ibtn_back.layer.cornerRadius=4;
    
    [_ibtn_ok setTitle:MY_LocalizedString(@"lbl_ok", nil) forState:UIControlStateNormal];
    _ibtn_ok.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _ibtn_ok.layer.borderWidth=1;
    _ibtn_ok.layer.cornerRadius=4;
    
    alist_history_img=[[NSMutableArray alloc]init];
    
}
#pragma mark -event action

- (IBAction)fn_make_multiple_select_enable:(id)sender {
    _ibtn_select.selected=!_ibtn_select.selected;
    if (_ibtn_select.selected) {
        self.collectionview.allowsMultipleSelection=YES;
        [_ibtn_history_logo setTitle:@"选择图片" forState:UIControlStateNormal];
    }else{
        self.collectionview.allowsMultipleSelection=NO;
        [_ibtn_history_logo setTitle:MY_LocalizedString(@"ibtn_history_capture", nil) forState:UIControlStateNormal];
        [alist_history_img removeAllObjects];
    }
}
- (IBAction)fn_back_manageImage_page:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)fn_determine_selection:(id)sender {
    if ([alist_history_img count]!=0) {
        if (_callBack) {
            _callBack(alist_history_img);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -show picture
-(void)fn_set_collectionView_pro{
    self.collectionview.delegate=self;
    self.collectionview.dataSource=self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell_history"];
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
    Cell_show_picture *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_history_capture" forIndexPath:indexPath];
    NSInteger  li_item=[indexPath item];
    Truck_order_image_data *upload_image_ms=[alist_image_ms objectAtIndex:li_item];
    UIImage *image=[Conversion_helper fn_base64Str_convert_image:upload_image_ms.image];
    cell.i_image.image=image;
    if ([upload_image_ms.image_isUploaded isEqualToString:@"true"]) {
        cell.i_UploadedImage.hidden=NO;
    }else{
        cell.i_UploadedImage.hidden=YES;
    }
    
    cell.i_UploadedImage.image=[UIImage imageNamed:@"selected"];
    return cell;
}
#pragma mark -UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.collectionview.allowsMultipleSelection==YES) {
        [alist_history_img addObject:[alist_image_ms objectAtIndex:indexPath.item]];
    }

}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.collectionview.allowsMultipleSelection==YES) {
        Truck_order_image_data *img_data=[alist_image_ms objectAtIndex:indexPath.item];
        [alist_history_img removeObject:img_data];
    }
}
#pragma mark – UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(10, 0, 0, 0);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
