//
//  ChartViewController.m
//  itleo
//
//  Created by itdept on 14-9-5.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "DashboardHomeViewController.h"
#import "DtlChartViewController.h"
#import "Cell_summary_chart.h"
#import "Conversion_helper.h"
#import "ChartView_frame.h"
#import "ChartData_handler.m"
#import "DB_Chart.h"
#import "DB_LoginInfo.h"
@interface DashboardHomeViewController ()

@property (nonatomic, strong) NSMutableArray *alist_GrpResult;
@property (nonatomic, strong) NSMutableArray *alist_DtlResult;
@property (nonatomic, strong) NSMutableArray *alist_chartView;
@property (nonatomic, assign) NSInteger flag_select_item;

@end

@implementation DashboardHomeViewController
@synthesize segment;
@synthesize alist_chartView;
@synthesize alist_GrpResult;
@synthesize alist_DtlResult;

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
    [self fn_set_segmentControl_title];
    [self fn_get_DtlResult_data:[self fn_get_group_id:segment.selectedSegmentIndex]];
    [self fn_create_chartView];
    [self fn_set_collectionView_pro];
  	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(NSString*)fn_get_group_id:(NSInteger)index{
    NSString *group_id=@"";
    if (index<[alist_GrpResult count]) {
        NSMutableDictionary *dic=[alist_GrpResult objectAtIndex:index];
        group_id=[dic valueForKey:@"unique_id"];
    }
    return group_id;
}
-(void)fn_get_DtlResult_data:(NSString*)unique_id{
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    alist_DtlResult=[db_chart fn_get_DashboardDtlResult:unique_id];
    alist_DtlResult=[Conversion_helper fn_sort_the_array:alist_DtlResult key:@"unique_id"];
}
- (IBAction)fn_segment_valueChange:(id)sender {
    [self fn_get_DtlResult_data:[self fn_get_group_id:segment.selectedSegmentIndex]];
    [self fn_create_chartView];
    [self.collectionview reloadData];
}

-(void)fn_create_chartView{
    alist_chartView=[[NSMutableArray alloc]initWithCapacity:1];
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
        ChartView_frame *chartView=[ChartView_frame fn_shareInstance];
        chartView.chart_type=_chart_type;
        chartView.ilb_chartTitle.text=chart_title;
        if ([_chart_type isEqualToString:@"PIE"] || [_chart_type isEqualToString:@"GRID"]) {
            chartView.alist_values=[ChartData_handler fn_get_chartData_value:unique_id type:kChartDataSerieValues];
            chartView.alist_options=[ChartData_handler fn_get_chartData_value:unique_id type:kChartDataYoptions];
            chartView.alist_colors=[ChartData_handler fn_get_chartData_value:unique_id type:kChartDataColors];
        }else{
            chartView.alist_values=[ChartData_handler fn_get_arr_value:unique_id type:kChartDataXvalues];
            chartView.alist_options=[ChartData_handler fn_get_arr_value:unique_id type:kChartDataYoptions];
            chartView.alist_colors=[ChartData_handler fn_get_arr_value:unique_id type:kChartDataColors];
        }
        chartView.alist_remarks=[ChartData_handler fn_get_arr_value:unique_id type:kChartDataRemarks];
        chartView.frame=CGRectMake(0, 0, 320, 480);
        i++;
        [alist_chartView addObject:chartView];
    }
}


#pragma mark -set collectionView pro
-(void)fn_set_collectionView_pro{
    self.collectionview.delegate=self;
    self.collectionview.dataSource=self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell_summary_chart"];
    
}
#pragma mark -UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [alist_chartView count];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Cell_summary_chart *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_summary_chart1" forIndexPath:indexPath];
    UIImage *img_chart=(UIImage*)[Conversion_helper fn_imageWithView:[alist_chartView objectAtIndex:indexPath.item]];
    cell.img_summary_chart.image=img_chart;
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

@end
