//
//  EnlargeImageViewController.m
//  itleo
//
//  Created by itdept on 15/3/6.
//  Copyright (c) 2015年 itdept. All rights reserved.
//

#import "EnlargeImageViewController.h"
#import "ManageImageViewController.h"
#import "Truck_order_image_data.h"
@interface EnlargeImageViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_back_item;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ibtn_ok_item;

@property (assign, nonatomic) NSInteger flag_image;

@end

@implementation EnlargeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fn_set_control_property];
    [self fn_set_scrollView];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_control_property{
    _flag_image=_flag_item;
    [_ibtn_back_item setTitle:MY_LocalizedString(@"lbl_back", nil)];
    [_ibtn_back_item setAction:@selector(fn_back_manageImage_page:)];
    
    [_ibtn_ok_item setTitle:MY_LocalizedString(@"lbl_ok", nil)];
    [_ibtn_ok_item setAction:@selector(fn_determine_selectImg:)];

    self.title=[NSString stringWithFormat:@"%@ of %@",@(_flag_item+1),@(_alist_image_ms.count)];
}
- (void)fn_set_scrollView{
    _scrollView.contentSize=CGSizeMake(_alist_image_ms.count*self.view.frame.size.width,_scrollView.frame.size.height);
    _scrollView.delegate=self;
    //为滚动视图添加子视图
    for (NSInteger i=0; i<_alist_image_ms.count; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*_scrollView.frame.size.width,0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        Truck_order_image_data *obj=[_alist_image_ms objectAtIndex:i];
        
        UIImage *img=[Conversion_helper fn_base64Str_convert_image:obj.image];
        imageView.image=img;
        [_scrollView addSubview:imageView];
        imageView=nil;
    }
    //滑动到指定的position
    CGPoint position=CGPointMake(_flag_item*self.view.frame.size.width,0);
    [_scrollView setContentOffset:position animated:NO];
}
#pragma mark -event action
- (IBAction)fn_back_manageImage_page:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)fn_determine_selectImg:(id)sender {
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
    Truck_order_image_data *image_data=[_alist_image_ms objectAtIndex:_flag_image];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectImg" object:image_data];
    image_data=nil;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth=_scrollView.frame.size.width;
    //计算当前页码
    NSInteger page=floor((_scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    _flag_image=page;
    self.title=[NSString stringWithFormat:@"%@ of %@",@(page+1),@(_alist_image_ms.count)];}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
