//
//  Aejob_BrowseViewController.m
//  itleo
//
//  Created by itdept on 14-8-11.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Aejob_BrowseViewController.h"
#import "Web_base.h"
#import "RespAejob_browse.h"
#import "DB_RespAejob_browse.h"
#import "DB_LoginInfo.h"
#import "DB_RespAppConfig.h"
#import "Cell_aejob_browse.h"
#import "SKSTableViewCell.h"
#import "Aejob_dtl_BrowseViewController.h"
#import "Aejob_AdvanceSearchViewController.h"
#import "CreateFootView.h"
#import "CheckNetWork.h"

static NSMutableArray *alist_groupAndnum;
static NSMutableArray *alist_filtered_data;
@interface Aejob_BrowseViewController ()
//从服务器请求回来的数据
@property (nonatomic,strong)NSMutableArray *alist_aejob_browse;
@property (nonatomic,strong)UIDatePicker *idp_datePicker;
@property (nonatomic,copy)NSString *millisecond;

@property (nonatomic,strong)Aejob_dtl_BrowseViewController *aejobVC;

@end

@implementation Aejob_BrowseViewController
@synthesize alist_aejob_browse;
@synthesize idp_datePicker;
@synthesize millisecond;
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
    self.skstableView.SKSTableViewDelegate=self;
    self.skstableView.separatorColor=[UIColor lightGrayColor];
    [self setExtraCellLineHidden];
    if ([alist_filtered_data count]==0) {
        [self fn_show_alert];
        [self.skstableView setScrollEnabled:NO];
    }
   
    [self fn_create_datePick];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fn_textfield_begin_edit:(id)sender {
    _itf_textfield.inputView=idp_datePicker;
    _itf_textfield.inputAccessoryView=[self fn_create_toolbar];
    [_itf_textfield fn_setLine_color:[UIColor blueColor]];
}

- (IBAction)fn_textfield_end_edit:(id)sender {
    [_itf_textfield fn_setLine_color:[UIColor lightGrayColor]];
}

- (IBAction)fn_search_aejob:(id)sender {
    SearchFormContract *searchForm=[[SearchFormContract alloc]init];
    searchForm.os_column=@"flight_date";
    searchForm.os_value=millisecond;//用户选择
    NSArray *alist_searchform=[NSArray arrayWithObject:searchForm];
    DB_RespAppConfig *db=[[DB_RespAppConfig alloc]init];
    NSString *base_url=[db fn_get_field_content:kWeb_addr];
    db=nil;
    CheckNetWork *obj=[[CheckNetWork alloc]init];
    if ([obj fn_isPopUp_alert]==NO) {
        [self fn_get_aejob_browse_data:base_url searchForm:alist_searchform];
        [self.skstableView setScrollEnabled:NO];
    }else{
        [self.skstableView setScrollEnabled:NO];
    }

}
- (IBAction)fn_advance_search_aejob:(id)sender {
    Aejob_AdvanceSearchViewController *VC=(Aejob_AdvanceSearchViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Aejob_AdvanceSearchViewController"];
    VC.callback=^(NSMutableArray *arr_result){
        DB_RespAppConfig *db=[[DB_RespAppConfig alloc]init];
        NSString *base_url=[db fn_get_field_content:kWeb_addr];
        CheckNetWork *obj=[[CheckNetWork alloc]init];
        if ([obj fn_isPopUp_alert]==NO) {
            [self fn_get_aejob_browse_data:base_url searchForm:arr_result];
        }
        obj=nil;
        db=nil;
    };
    [self presentViewController:VC animated:YES completion:^(){}];
}
#pragma mark 获取Aejob_browse数据
-(void)fn_get_aejob_browse_data:(NSString*)base_url searchForm:(NSArray*)alist_searchForm{
    [self setExtraCellLineHidden];
    [SVProgressHUD showWithStatus:@"Loading,please wait!"];
    RequestContract *req_form=[[RequestContract alloc]init];
    DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db fn_get_RequestAuth];
    req_form.Auth=auth;
    req_form.SearchForm=[NSSet setWithArray:alist_searchForm];
    Web_base *web_base=[[Web_base alloc]init];
    web_base.il_url=STR_AEJOB_BROWSE_URL;
    web_base.ilist_resp_mapping=[NSArray arrayWithPropertiesOfObject:[RespAejob_browse class]];
    web_base.iresp_class=[RespAejob_browse class];
    web_base.callBack=^(NSMutableArray* arr_resp_result){
        if ([arr_resp_result count]==0) {
            [self fn_show_alert];
            [self.skstableView setScrollEnabled:NO];
        }else{
            [self.skstableView setScrollEnabled:YES];
            [self.skstableView setTableFooterView:nil];
        }
        [SVProgressHUD dismiss];
        [self fn_refresh_skstableview:arr_resp_result];
    };
    [web_base fn_get_data:req_form base_url:base_url];
    req_form=nil;
    db=nil;
    web_base=nil;
}
#pragma mark 请求一次服务器，就更新一下Tableview
-(void)fn_refresh_skstableview:(NSMutableArray*)arr_resp_result{
    DB_RespAejob_browse *db=[[DB_RespAejob_browse alloc]init];
    [db fn_delete_aejob_browse_data];
    alist_filtered_data=[[NSMutableArray alloc]init];
    //保存数据
    [db fn_save_aejob_browse_data:arr_resp_result];
    
    alist_aejob_browse=[db fn_get_all_aejob_browse_data];
    alist_groupAndnum=[db fn_get_groupData_num];
    
    for (NSMutableDictionary *dic in alist_groupAndnum) {
        NSString *str_flight_no=[dic valueForKey:@"flight_no"];
        NSString *str_job_no=[dic valueForKey:@"job_no"];
        NSString *str_carr_name=[dic valueForKey:@"carr_name"];
        NSArray *arr=[self fn_filtered_criteriaData:str_flight_no job_no:str_job_no carr_name:str_carr_name];
        if (arr!=nil && [arr count]!=0) {
            [alist_filtered_data addObject:arr];
        }
    }
    self.skstableView.expandableCells=nil;
    [self.skstableView reloadData];
    db=nil;
}
#pragma mark -No Data Alert
-(void)fn_show_alert{
    UIView *view=[CreateFootView fn_create_footView:@"No Load plan data!"];
    [self.skstableView setTableFooterView:view];
    
}


#pragma mark SKSTableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_groupAndnum count];
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numOfrow=[[alist_groupAndnum objectAtIndex:indexPath.row]valueForKey:@"num"];
    return [numOfrow integerValue];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取每组的字典
    NSMutableDictionary *dic=[alist_groupAndnum objectAtIndex:indexPath.row];
    static NSString *CellIdentifier=@"SKSTableViewCell";
    SKSTableViewCell *cell=[self.skstableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[self.skstableView dequeueReusableCellWithIdentifier:@"SKSTableViewCell"];
    }
    cell.expandable=YES;
    cell.accessoryView=nil;
    
    NSString *str_flight_no=[dic valueForKey:@"flight_no"];
    cell.il_flight.text=[NSString stringWithFormat:@"%@/%@/To:%@",str_flight_no,[dic valueForKey:@"flight_date"],[dic valueForKey:@"dish_port"]];
    cell.il_carr_name.text=[dic valueForKey:@"carr_name"];
    cell.il_kgs.text=[NSString stringWithFormat:@"%@(KGS)",[dic valueForKey:@"kgs"]];
    cell.il_pkg.text=[NSString stringWithFormat:@"%@(PKG)",[dic valueForKey:@"pkg"]];
    cell.il_cbf.text=[NSString stringWithFormat:@"%@(CBF)",[dic valueForKey:@"cbf"]];
    cell.il_job_no.text=[NSString stringWithFormat:@"Job#:%@",[dic valueForKey:@"job_no"]];
    return cell;
}
-(UITableViewCell*)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    //提取每行的数据
    NSMutableDictionary *dic=alist_filtered_data[indexPath.row][indexPath.subRow-1];
    NSString *uld_type=[dic valueForKey:@"uld_type"];
    NSString *uld_no=[dic valueForKey:@"uld_no"];
    NSString *no_of_hawb=[NSString stringWithFormat:@"%@HAWBs",[dic valueForKey:@"no_of_hawb"]];
    NSString *pkg=[NSString stringWithFormat:@"%@(PKG)",[dic valueForKey:@"pkg"]];
    NSString *kgs=[NSString stringWithFormat:@"%@(KGS)",[dic valueForKey:@"kgs"]];
    NSString *cbf=[NSString stringWithFormat:@"%@(CBF)",[dic valueForKey:@"cbf"]];
    static NSString *cellIndentifier=@"Cell_aejob_browse";
    Cell_aejob_browse *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    if (!cell) {
        cell=[self.skstableView dequeueReusableCellWithIdentifier:@"Cell_aejob_browse" forIndexPath:indexPath];
    }
    if ((indexPath.subRow-1)%2==0) {
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }else{
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }
    cell.imag_aejob.image=[UIImage imageNamed:@"ic_uld"];
    cell.il_uld_no.text=uld_no;
    cell.il_uld_type.text=uld_type;
    cell.il_no_of_hawb.text=no_of_hawb;
    cell.il_pkg.text=pkg;
    cell.il_cbf.text=cbf;
    cell.il_kgs.text=kgs;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segue_aejob_dtl_browse" sender:self];
    NSMutableDictionary *dic=alist_filtered_data[indexPath.row][indexPath.subRow-1];
    _aejobVC.idic_aejob_browse=dic;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier]isEqualToString:@"segue_aejob_dtl_browse"]) {
        _aejobVC=(Aejob_dtl_BrowseViewController*)segue.destinationViewController;
    }
}

#pragma mark 过滤数组
-(NSArray*)fn_filtered_criteriaData:(NSString*)key job_no:(NSString*)job_no carr_name:(NSString*)carr_name{
    NSArray *filtered=[alist_aejob_browse filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(flight_no==%@)",key]];
    filtered=[filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(job_no==%@)",job_no]];
    filtered=[filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(carr_name==%@)",carr_name]];
    return filtered;
}
- (void)setExtraCellLineHidden
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.skstableView setTableFooterView:view];
}
#pragma mark UIDatePick
-(void)fn_create_datePick{
    //初始化UIDatePicker
    idp_datePicker=[[UIDatePicker alloc]init];
    [idp_datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [idp_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:[Conversion_helper fn_get_lang_code]]];
    //设置UIDatePicker的显示模式
    [idp_datePicker setDatePickerMode:UIDatePickerModeDate];
    //当值发生改变的时候调用的方法
    [idp_datePicker addTarget:self action:@selector(fn_change_date) forControlEvents:UIControlEventValueChanged];
    NSDate *id_startdate=[idp_datePicker date];
    [self fn_date_transform:id_startdate];
}
-(void)fn_change_date{
    //获得当前UIPickerDate所在的日期
    NSDate *id_startdate=[idp_datePicker date];
    [self fn_date_transform:id_startdate];
}
-(void)fn_date_transform:(NSDate*)date{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    _itf_textfield.text=[dateformatter stringFromDate:date];
    NSTimeInterval timeInterval=[date timeIntervalSince1970];
    NSTimeInterval interval=timeInterval*1000;
    millisecond=[NSString stringWithFormat:@"%0.0lf",interval];
}
#pragma mark create toolbar
-(UIToolbar*)fn_create_toolbar{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(fn_Click_done:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    return toolbar;
}
-(void)fn_Click_done:(id)sender{
    [_itf_textfield resignFirstResponder];
}

@end
