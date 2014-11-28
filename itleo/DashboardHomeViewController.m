//
//  ChartViewController.m
//  itleo
//
//  Created by itdept on 14-9-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DashboardHomeViewController.h"
#import "DtlChartViewController.h"
#import "SelectHistoryDataViewController.h"
#import "PopViewManager.h"
#import "Cell_summary_chart.h"
#import "Conversion_helper.h"
#import "ChartView_frame.h"
#import "ChartData_handler.m"
#import "DB_Chart.h"
#import "DB_LoginInfo.h"
#import "Web_get_chart_data.h"
#define FIXSPACE 15
typedef NS_ENUM(NSUInteger, AlertType) {
    kRefresh_ALL,
    kRefresh_one,
};
@interface DashboardHomeViewController ()

@property (nonatomic, strong) NSMutableArray *alist_GrpResult;
@property (nonatomic, strong) NSMutableArray *alist_DtlResult;
@property (nonatomic, strong) NSMutableArray *alist_chartView;
@property (nonatomic, strong) NSMutableArray *alist_chartImg;
@property (nonatomic, strong) NSMutableDictionary *idic_chartViews;
@property (nonatomic, assign) NSInteger flag_select_item;

@property (nonatomic, assign) AlertType alertType;

@end

@implementation DashboardHomeViewController
@synthesize segment;
@synthesize alist_chartView;
@synthesize alist_chartImg;
@synthesize alist_GrpResult;
@synthesize alist_DtlResult;
@synthesize idic_chartViews;

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
    [self fn_add_right_items];
    [self fn_set_segmentControl_title];
    [self fn_get_all_chartViews];
    alist_chartView=[idic_chartViews valueForKey:[NSString stringWithFormat:@"%ld",(long)segment.selectedSegmentIndex]];
    [self fn_get_chartImg];
    
    [self fn_set_collectionView_pro];
  	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_add_right_items{
    UIBarButtonItem *ibtn_setting=[[UIBarButtonItem alloc]initWithTitle:MY_LocalizedString(@"lbl_set", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(fn_setting_chart_summary_type)];
    UIBarButtonItem *ibtn_space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ibtn_space.width=FIXSPACE;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,1.5,20)];
    view.backgroundColor=[UIColor lightGrayColor];
    UIBarButtonItem *ibtn_space1=[[UIBarButtonItem alloc]initWithCustomView:view];
    ibtn_space1.width=1.5;
    UIBarButtonItem *ibtn_space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ibtn_space2.width=FIXSPACE;
    UIBarButtonItem *ibtn_refresh=[[UIBarButtonItem alloc]initWithTitle:MY_LocalizedString(@"lbl_refresh", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(fn_refresh_chartView)];
    NSArray *array=@[ibtn_setting,ibtn_space,ibtn_space1,ibtn_space2,ibtn_refresh];
    self.navigationItem.rightBarButtonItems=array;
}
-(void)fn_refresh_chartView{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:MY_LocalizedString(@"lbl_refresh_title", nil) message:MY_LocalizedString(@"lbl_refresh_alert", nil) delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_cancel", nil) otherButtonTitles:MY_LocalizedString(@"lbl_ok",nil), nil];
    [alert show];
    _alertType=kRefresh_ALL;
}

-(void)fn_setting_chart_summary_type{
    NSMutableArray *alist_type=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",nil
    ];
    SelectHistoryDataViewController *VC=(SelectHistoryDataViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectHistoryDataViewController"];
    VC.alist_sys_code=alist_type;
    VC.flag_type=1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fn_update_chart_summary_type:) name:@"chart_summary_type" object:nil];
    PopViewManager *pop_obj=[[PopViewManager alloc]init];
    [pop_obj fn_PopupView:VC Size:CGSizeMake(230, 300) uponView:self];
}
-(void)fn_update_chart_summary_type:(NSNotification*)notification{
    NSString *key=(NSString*)[notification object];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:key forKey:@"chart_summary_type"];
    [userDefaults synchronize];
    [self.collectionview reloadData];
    
}
#pragma mark -UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        Web_get_chart_data *web_obj=[[Web_get_chart_data alloc]init];
        [SVProgressHUD showWithStatus:MY_LocalizedString(@"lbl_refreshing", nil)];
        if (_alertType==kRefresh_ALL) {
            [web_obj fn_get_chart_data:nil uid:nil type:kRequestAll];
            web_obj.callBack=^(){
                [self fn_set_segmentControl_title];
                [self fn_get_all_chartViews];
                NSString *key=[NSString stringWithFormat:@"%ld",(long)segment.selectedSegmentIndex];
                alist_chartView=[idic_chartViews valueForKey:key];
                [self fn_get_chartImg];
                [self.collectionview reloadData];
                [SVProgressHUD dismissWithSuccess:MY_LocalizedString(@"lbl_refresh_success", nil) afterDelay:2.0f];
            };
        }
        if (_alertType==kRefresh_one) {
            NSMutableDictionary *dic=[alist_DtlResult objectAtIndex:_flag_select_item];
            NSString *uid=[dic valueForKey:@"unique_id"];
            [web_obj fn_get_chart_data:nil uid:uid type:kRequestOne];
            web_obj.callBack=^(){
                [self fn_get_all_chartViews];
                NSString *key=[NSString stringWithFormat:@"%ld",(long)segment.selectedSegmentIndex];
                alist_chartView=[idic_chartViews valueForKey:key];
                [self fn_get_chartImg];
                [self.collectionview reloadData];
                [SVProgressHUD dismissWithSuccess:MY_LocalizedString(@"lbl_refresh_success", nil) afterDelay:2.0f];
            };
        }
    }
}


-(void)fn_set_segmentControl_title{
    //  for adjust segment widths based on their content widths
    [self.segment setApportionsSegmentWidthsByContent:YES];
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    alist_GrpResult=[db_chart fn_get_DashboardGrpDResult_data];
    //根据unique_id给数组升序排序
    alist_GrpResult=[Conversion_helper fn_sort_the_array:alist_GrpResult key:@"unique_id"];
    NSString *lang_code=[self fn_get_language_type];
    NSInteger i=0;
    for (NSMutableDictionary *dic in alist_GrpResult) {
        NSString *grp_title=@"";
        if ([lang_code isEqualToString:@"EN"]) {
            grp_title=[dic valueForKey:@"grp_title_en"];
        }
        if ([lang_code isEqualToString:@"CN"]) {
            grp_title=[dic valueForKey:@"grp_title_cn"];
        }
        if ([lang_code isEqualToString:@"TCN"]) {
            grp_title=[dic valueForKey:@"grp_title_big5"];
        }
        [segment setTitle:grp_title forSegmentAtIndex:i];
        i++;
    }
     
}
-(NSString*)fn_get_language_type{
    DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
    NSMutableArray *arr=[db fn_get_all_LoginInfoData];
    NSString *lang_code=@"";
    if ([arr count]!=0) {
        lang_code=[[arr objectAtIndex:0]valueForKey:@"lang_code"];
    }
    return lang_code;
}
/*
-(NSString*)fn_get_group_id:(NSInteger)index{
    NSString *group_id=@"";
    if (index<[alist_GrpResult count]) {
        NSMutableDictionary *dic=[alist_GrpResult objectAtIndex:index];
        group_id=[dic valueForKey:@"unique_id"];
    }
    return group_id;
}*/
-(void)fn_get_all_chartViews{
    idic_chartViews=[[NSMutableDictionary alloc]init];
    NSInteger i=0;
    for (NSMutableDictionary *dic in alist_GrpResult) {
        NSString *unique_id=[dic valueForKey:@"unique_id"];
        [self fn_get_DtlResult_data:unique_id];
        NSMutableArray *arr_chartView=[self fn_create_chartView];
        if ([arr_chartView count]!=0) {
            [idic_chartViews setObject:arr_chartView forKey:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        i++;
    }
    
}
-(void)fn_get_chartImg{
    if ([alist_chartImg count]!=0) {
        [alist_chartImg removeAllObjects];
    }else{
        alist_chartImg=[[NSMutableArray alloc]init];
    }
    for (ChartView_frame *chartView in alist_chartView) {
        UIImage *img=[Conversion_helper fn_imageWithView:chartView];
        [alist_chartImg addObject:img];
        img=nil;
    }
}
#pragma mark -获取对应组，图表详细数据
-(void)fn_get_DtlResult_data:(NSString*)unique_id{
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    alist_DtlResult=[db_chart fn_get_DashboardDtlResult:unique_id];
    alist_DtlResult=[Conversion_helper fn_sort_the_array:alist_DtlResult key:@"unique_id"];
}
- (IBAction)fn_segment_valueChange:(id)sender {
    NSString *key=[NSString stringWithFormat:@"%ld",(long)segment.selectedSegmentIndex];
    alist_chartView=[idic_chartViews valueForKey:key];
    [self fn_get_chartImg];
    [self.collectionview reloadData];
}
#pragma mark -创建该组的图表视图
-(NSMutableArray*)fn_create_chartView{
    NSMutableArray *  arr_chartViews=[[NSMutableArray alloc]initWithCapacity:1];
    NSInteger i=0;
    NSString *_language=[self fn_get_language_type];
    for (NSMutableDictionary *dic in alist_DtlResult) {
        NSString *_chart_type=[dic valueForKey:@"chart_type"];
        NSString *unique_id=[dic valueForKey:@"unique_id"];
        NSString *chart_title=@"";
        if ([_language isEqualToString:@"EN"]) {
            chart_title=[dic valueForKey:@"chart_title_en"];
        }
        if ([_language isEqualToString:@"CN"]) {
            chart_title=[dic valueForKey:@"chart_title_cn"];
        }
        if ([_language isEqualToString:@"TCN"]) {
            chart_title=[dic valueForKey:@"chart_title_big5"];
        }
        ChartView_frame *chartView=[ChartView_frame fn_shareInstance];
        chartView.chart_type=_chart_type;
        chartView.ilb_chartTitle.text=chart_title;
        if ([_chart_type isEqualToString:@"PIE"]|| [_chart_type isEqualToString:@"GRID"]) {
            chartView.alist_values=[ChartData_handler fn_gets_the_chart_Data:unique_id arr_type:kChartDataSerieValues chart_type:_chart_type];
        }else{
            chartView.alist_values=[ChartData_handler fn_gets_the_chart_Data:unique_id arr_type:kChartDataXvalues chart_type:_chart_type];
        }
        chartView.alist_options=[ChartData_handler fn_gets_the_chart_Data:unique_id arr_type:kChartDataYoptions chart_type:_chart_type];
        chartView.alist_colors=[ChartData_handler fn_gets_the_chart_Data:unique_id arr_type:kChartDataColors chart_type:_chart_type];
        chartView.alist_remarks=[ChartData_handler fn_gets_the_chart_Data:unique_id arr_type:kChartDataRemarks chart_type:_chart_type];
        chartView.frame=CGRectMake(0, 0, 320, 480);
        i++;
        [arr_chartViews addObject:chartView];
    }
    return arr_chartViews;
}


#pragma mark -set collectionView pro
-(void)fn_set_collectionView_pro{
    self.collectionview.delegate=self;
    self.collectionview.dataSource=self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell_summary_chart"];
    
}
#pragma mark -UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [alist_chartImg count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Cell_summary_chart *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_summary_chart1" forIndexPath:indexPath];
   
   
    cell.img_summary_chart.image=[alist_chartImg objectAtIndex:indexPath.item];
    cell.img_summary_chart.tag=indexPath.item;
    UILongPressGestureRecognizer *longGestureRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(fn_update_chart_data:)];
    [cell addGestureRecognizer:longGestureRecognizer];
    return cell;
}
#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _flag_select_item=indexPath.item;
    [self performSegueWithIdentifier:@"segue_dtl" sender:self];
}
#pragma mark – UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(10, 0, 0, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *summary_type=[userDefaults valueForKey:@"chart_summary_type"];
    if ([summary_type integerValue]==1) {
        return CGSizeMake(300, 450);
    }
    if ([summary_type integerValue]==2) {
        return CGSizeMake(150, 225);
    }
    if ([summary_type integerValue]==3) {
        return CGSizeMake(100, 150);
    }
    return CGSizeMake(100, 150);
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    DtlChartViewController *dtlVC=(DtlChartViewController*)[segue destinationViewController];
    ChartView_frame *chartView=(ChartView_frame*)[alist_chartView objectAtIndex:_flag_select_item];
    dtlVC.alist_options=chartView.alist_options;
    dtlVC.alist_values=chartView.alist_values;
    dtlVC.chart_type=chartView.chart_type;
    dtlVC.alist_colors=chartView.alist_colors;
    dtlVC.alist_remarks=chartView.alist_remarks;
    dtlVC.chartTitle=chartView.ilb_chartTitle.text;
    
    // Pass the selected object to the new view controller.
}
-(void)fn_update_chart_data:(UILongPressGestureRecognizer*)gestureRecognizer{
    _alertType=kRefresh_one;
    Cell_summary_chart *cell=(Cell_summary_chart*)[gestureRecognizer view];
    _flag_select_item=cell.img_summary_chart.tag;
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"是否更新该图表？" message:MY_LocalizedString(@"lbl_refresh_alert", nil) delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_cancel", nil) otherButtonTitles:MY_LocalizedString(@"lbl_ok",nil), nil];
        [alert show];
    }
    
}
@end
