//
//  Aejob_AdvanceSearchViewController.m
//  itleo
//
//  Created by itdept on 14-8-12.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Aejob_AdvanceSearchViewController.h"
#import "Cell_advance_search.h"
#import "Custom_textField.h"
#define TEXTFIELD_TAG 100
typedef NSString* (^passValue)(NSInteger tag);
@interface Aejob_AdvanceSearchViewController ()
@property(nonatomic,strong)NSArray *alist_prompt;
@property(nonatomic,strong)NSArray *alist_os_column;
@property(nonatomic,strong)NSMutableArray *alist_searchForm;
@property(nonatomic,strong)Custom_textField *checkText;
@property(nonatomic,strong)NSMutableDictionary *idic_searchform;
@property(nonatomic,strong)passValue pass_Value;
@property(nonatomic,strong)NSString *millisecond;
@property(nonatomic,strong)UIDatePicker *idp_datepicker;
@end

@implementation Aejob_AdvanceSearchViewController
@synthesize alist_prompt;
@synthesize alist_os_column;
@synthesize checkText;
@synthesize idic_searchform;
@synthesize alist_searchForm;
@synthesize pass_Value;
@synthesize millisecond;
@synthesize idp_datepicker;
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
    [self fn_set_button_pro];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    alist_prompt=@[@"Flight No:",@"Start Date:",@"End Date:",@"Carrier:",@"Job#:"];
    alist_os_column=@[@"flight_no",@"flight_date",@"flight_date_end",@"carr_name",@"job_no"];
    idic_searchform=[NSMutableDictionary dictionary];
    alist_searchForm=[NSMutableArray array];
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    [self fn_create_datePick];
    [self fn_custom_gestureRecognizer];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -custom gesture
-(void)fn_custom_gestureRecognizer{
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_hiden_keyboard:)];
    [self.view addGestureRecognizer:gesture];
}
-(void)fn_hiden_keyboard:(UITapGestureRecognizer*)tap{
    [self.tableview reloadData];
}
-(void)fn_set_button_pro{
    [_ibtn_search_logo setTitle:@"Search Form" forState:UIControlStateNormal];
    [_ibtn_search_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    _ibtn_cancel.layer.cornerRadius=2;
    _ibtn_cancel.layer.borderWidth=0.5;
    _ibtn_cancel.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _ibtn_clear.layer.cornerRadius=2;
    _ibtn_clear.layer.borderWidth=0.5;
    _ibtn_clear.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _ibtn_search.layer.cornerRadius=2;
    _ibtn_search.layer.borderWidth=0.5;
    _ibtn_search.layer.borderColor=[UIColor lightGrayColor].CGColor;
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_prompt count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier=@"Cell_advance_search";
    Cell_advance_search *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    __block Aejob_AdvanceSearchViewController * blockSelf=self;
    pass_Value=^NSString*(NSInteger tag){
        return blockSelf->alist_os_column[tag-TEXTFIELD_TAG];
    };
    if (!cell) {
        cell=[self.tableview dequeueReusableCellWithIdentifier:@"Cell_advance_search" forIndexPath:indexPath];
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }else{
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.il_prompt.text=[alist_prompt objectAtIndex:indexPath.row];
    cell.itf_inputdata.delegate=self;
    cell.itf_inputdata.tag=TEXTFIELD_TAG+indexPath.row;
    NSString *os_column_key=[alist_os_column objectAtIndex:indexPath.row];
    NSString *os_value_key=[idic_searchform valueForKey:os_column_key];
    
    if ([os_column_key isEqualToString:@"flight_date"]|| [os_column_key isEqualToString:@"flight_date_end"]) {
        cell.itf_inputdata.inputView=idp_datepicker;
        cell.itf_inputdata.inputAccessoryView=[self fn_create_toolbar];
        if ([os_value_key length]!=0) {
            os_value_key=[self dateFromUnixTimestamp:os_value_key];
        }
    }
    cell.itf_inputdata.text=os_value_key;
    return cell;
}
#pragma mark 毫秒转日期字符串
-(NSString*)dateFromUnixTimestamp:(NSString*)millisecond1{
    double millisecond_value=[millisecond1 doubleValue];
    NSTimeInterval timeinterval=millisecond_value/1000.0f;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timeinterval];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    return [dateformatter stringFromDate:date];
}
#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    checkText=(Custom_textField*)textField;
    [checkText fn_setLine_color:[UIColor blueColor]];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [checkText fn_setLine_color:[UIColor lightGrayColor]];
    NSString *os_column_key=pass_Value(textField.tag);
    if ([os_column_key isEqualToString:@"flight_date"]|| [os_column_key isEqualToString:@"flight_date_end"]  ) {
        if (millisecond!=nil) {
            [idic_searchform setObject:millisecond forKey:os_column_key];
            millisecond=@"";
        }
    }else{
        [idic_searchform setObject:textField.text forKey:os_column_key];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -event action
- (IBAction)fn_Search_aejob:(id)sender {
    NSEnumerator *keys=[idic_searchform keyEnumerator];
    for (NSString *str_key in keys) {
        SearchFormContract *searchForm=[[SearchFormContract alloc]init];
        if ([str_key isEqualToString:@"flight_date_end"]==NO) {
            searchForm.os_column=str_key;
            searchForm.os_value=[idic_searchform valueForKey:str_key];
            if ([searchForm.os_value length]!=0) {
                [alist_searchForm addObject:searchForm];
            }
        }
    }
    if ([[idic_searchform valueForKey:@"flight_date_end"]length]!=0) {
        for (SearchFormContract *searchform in alist_searchForm) {
            if ([searchform.os_column isEqualToString:@"flight_date"]) {
                searchform.os_dyn_1=[idic_searchform valueForKey:@"flight_date_end"];
            }
        }
    }
    if (_callback) {
        _callback(alist_searchForm);
       [self dismissViewControllerAnimated:YES completion:^(){}];
    }
}

- (IBAction)fn_clear_textfield:(id)sender {
    [alist_searchForm removeAllObjects];
    [idic_searchform removeAllObjects];
    [self.tableview reloadData];

}

- (IBAction)fn_cancel_searchAejob:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(){}];
}
#pragma mark UIDatePick
-(void)fn_create_datePick{
    //初始化UIDatePicker
    idp_datepicker=[[UIDatePicker alloc]init];
    [idp_datepicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    //设置UIDatePicker的显示模式
    [idp_datepicker setDatePickerMode:UIDatePickerModeDate];
    //当值发生改变的时候调用的方法
    [idp_datepicker addTarget:self action:@selector(fn_change_date) forControlEvents:UIControlEventValueChanged];
    
}
-(void)fn_change_date{
    //获得当前UIPickerDate所在的日期
    NSDate *id_startdate=[idp_datepicker date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval timeInterval=[id_startdate timeIntervalSince1970];
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
    [checkText resignFirstResponder];
    [self.tableview reloadData];
}

@end
