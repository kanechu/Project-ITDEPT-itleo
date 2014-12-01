//
//  Web_get_chart_data.m
//  itleo
//
//  Created by itdept on 14-11-10.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Web_get_chart_data.h"
#import "Web_base.h"
#import "DB_LoginInfo.h"
#import "DB_Chart.h"
#import "Conversion_helper.h"
#import "ChartData_handler.h"
#import "ChartView_frame.h"
static NSMutableDictionary *idic_ChartImages=nil;
@implementation Web_get_chart_data

+ (Web_get_chart_data*)fn_shareInstance{
    __strong static Web_get_chart_data *web_obj=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        web_obj=[[Web_get_chart_data alloc]init];
    });
    return web_obj;
}
- (void) fn_get_chart_data:(NSString*)base_url uid:(NSString*)unique_id type:(RequestType)requestType{
    unique_id=[Conversion_helper fn_cut_whitespace:unique_id];
    RequestContract *request_form=[[RequestContract alloc]init];
    DB_LoginInfo *login_obj=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[login_obj fn_get_RequestAuth];
    auth.app_code=APP_CODE;
    auth.system=@"ITNEW";
    request_form.Auth=auth;
#warning neet fix
    base_url=@"http://192.168.1.17/kie_web_api/";//这里也先写死，日后记住改过来
    if (requestType==kRequestAll) {
        SearchFormContract *searchform=[[SearchFormContract alloc]init];
        searchform.os_column=@"type";
        searchform.os_value=@"ALL";
        request_form.SearchForm=[NSSet setWithObject:searchform];
    }
    if (requestType==kRequestOne) {
        SearchFormContract *searchform=[[SearchFormContract alloc]init];
        searchform.os_column=@"type";
        searchform.os_value=@"CHART";
        SearchFormContract *searchform1=[[SearchFormContract alloc]init];
        searchform1.os_column=@"uid";
        searchform1.os_value=unique_id;
        request_form.SearchForm=[NSSet setWithObjects:searchform,searchform1, nil];
    }
    
    Web_base *web_obj=[[Web_base alloc]init];
    web_obj.il_url=STR_GET_CHART_URL;
    web_obj.callBack=^(NSMutableArray *arr_resp_result){
        DB_Chart *db=[[DB_Chart alloc]init];
        if (requestType==kRequestAll) {
            [db fn_delete_all_chart_data];
            [db fn_save_chart_data:arr_resp_result];
            if (_callBack) {
                _callBack();
            }
        }
        if (requestType==kRequestOne) {
            [db fn_update_chart_data:arr_resp_result uid:unique_id];
            if (_callBack) {
                _callBack();
            }
        }
        
    };
    [web_obj fn_get_chart_data:request_form Auth:auth base_url:base_url];
}
- (NSMutableDictionary*)fn_get_ChartImages{
    return idic_ChartImages;
}
- (void)fn_asyn_get_all_charts{
    dispatch_queue_t my_Queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(my_Queue, ^{
        [self fn_ChartView_convert_chartImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}
- (void)fn_ChartView_convert_chartImage{
    idic_ChartImages=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *idic_chartViews=[self fn_get_all_chartViews];
    NSInteger i=0;
    for (NSMutableArray *alist_chartViews in [idic_chartViews allValues]) {
        NSMutableArray *alist_chartImgs=[[NSMutableArray alloc]init];
        for (ChartView_frame *chartView in alist_chartViews) {
            UIImage *img=[Conversion_helper fn_imageWithView:chartView];
            [alist_chartImgs addObject:img];
            img=nil;
        }
        [idic_ChartImages setObject:alist_chartImgs forKey:[NSString stringWithFormat:@"%ld",(long)i]];
        i++;
    }
}

- (NSMutableDictionary*)fn_get_all_chartViews{
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    NSMutableArray *alist_GrpResult=[db_chart fn_get_DashboardGrpDResult_data];
    //根据unique_id给数组升序排序
    alist_GrpResult=[Conversion_helper fn_sort_the_array:alist_GrpResult key:@"unique_id"];
    NSMutableDictionary *idic_chartViews=[[NSMutableDictionary alloc]init];
    NSInteger i=0;
    for (NSMutableDictionary *dic in alist_GrpResult) {
        NSString *unique_id=[dic valueForKey:@"unique_id"];
       NSMutableArray *alist_DtlResult=[self fn_get_DtlResult_data:unique_id];
        NSMutableArray *arr_chartView=[self fn_create_chartView:alist_DtlResult];
        if ([arr_chartView count]!=0) {
            [idic_chartViews setObject:arr_chartView forKey:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        i++;
    }
    return idic_chartViews;
}
- (NSMutableArray*)fn_get_DtlResult_data:(NSString*)unique_id{
    DB_Chart *db_chart=[[DB_Chart alloc]init];
    NSMutableArray *alist_DtlResult=[db_chart fn_get_DashboardDtlResult:unique_id];
    alist_DtlResult=[Conversion_helper fn_sort_the_array:alist_DtlResult key:@"unique_id"];
    return alist_DtlResult;
}
#pragma mark -创建该组的图表视图
- (NSMutableArray*)fn_create_chartView:(NSMutableArray*)alist_DtlResult{
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
- (NSString*)fn_get_language_type{
    DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
    NSMutableArray *arr=[db fn_get_all_LoginInfoData];
    NSString *lang_code=@"";
    if ([arr count]!=0) {
        lang_code=[[arr objectAtIndex:0]valueForKey:@"lang_code"];
    }
    return lang_code;
}

@end
