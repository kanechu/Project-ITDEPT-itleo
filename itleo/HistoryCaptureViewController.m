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
#import "EnlargeImageViewController.h"
@interface HistoryCaptureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak, nonatomic) IBOutlet Custom_BtnGraphicMixed *ibtn_history_logo;
@property (weak, nonatomic) IBOutlet UIButton *ibtn_select;
//存储多选的图片信息
@property (strong, nonatomic) NSMutableArray *alist_history_img;
@property (assign, nonatomic) NSInteger flag_item;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_back_item;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_ok_item;

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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *alist_indexPaths=[self.collectionview indexPathsForSelectedItems];
    for (NSIndexPath *obj in alist_indexPaths) {
        [self.collectionview deselectItemAtIndexPath:obj animated:NO];
    }
    alist_indexPaths=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_control_property{
 
    [_ibtn_history_logo setTitle:MY_LocalizedString(@"ibtn_history_capture", nil) forState:UIControlStateNormal];
    [_ibtn_history_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    
    [_ibtn_select setTitle:MY_LocalizedString(@"lbl_enable_multi_select", nil) forState:UIControlStateNormal];
    [_ibtn_select setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateSelected];
    
    [_ibtn_back_item setTitle:MY_LocalizedString(@"lbl_back", nil)];
    [_ibtn_back_item setAction:@selector(fn_back_manageImage_page:)];
    
    [_ibtn_ok_item setTitle:MY_LocalizedString(@"lbl_ok", nil)];
    [_ibtn_ok_item setAction:@selector(fn_determine_selection:)];
    _ibtn_ok_item.enabled=NO;
    
    alist_history_img=[[NSMutableArray alloc]init];
}
#pragma mark -event action

- (IBAction)fn_make_multiple_select_enable:(id)sender {
    _ibtn_select.selected=!_ibtn_select.selected;
    if (_ibtn_select.selected) {
        self.collectionview.allowsMultipleSelection=YES;
        [_ibtn_history_logo setTitle:MY_LocalizedString(@"lbl_hitory_capture_logo", nil) forState:UIControlStateNormal];
        
    }else{
        self.collectionview.allowsMultipleSelection=NO;
        [_ibtn_history_logo setTitle:MY_LocalizedString(@"ibtn_history_capture", nil) forState:UIControlStateNormal];
        [alist_history_img removeAllObjects];
        NSArray *alist_indexPaths=[self.collectionview indexPathsForSelectedItems];
        for (NSIndexPath *obj in alist_indexPaths) {
            [self.collectionview deselectItemAtIndexPath:obj animated:NO];
        }
        alist_indexPaths=nil;
        _ibtn_ok_item.enabled=NO;
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
        if ([alist_history_img count]!=0) {
            _ibtn_ok_item.enabled=YES;
        }
    }else{
        _flag_item=indexPath.item;
        [self performSegueWithIdentifier:@"segue_enlarge_img" sender:self];
    }

}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.collectionview.allowsMultipleSelection==YES) {
        Truck_order_image_data *img_data=[alist_image_ms objectAtIndex:indexPath.item];
        [alist_history_img removeObject:img_data];
        if ([alist_history_img count]==0) {
            _ibtn_ok_item.enabled=NO;
        }
    }
}
#pragma mark – UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(10, 0, 0, 0);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    EnlargeImageViewController *enlargeImgVc=(EnlargeImageViewController*)[segue destinationViewController];
    enlargeImgVc.alist_image_ms=alist_image_ms;
    enlargeImgVc.flag_item=_flag_item;
}


- (IBAction)ibtn_back_item:(id)sender {
}
@end
