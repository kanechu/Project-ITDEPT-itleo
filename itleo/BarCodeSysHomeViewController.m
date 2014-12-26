//
//  BarCodeSysHomeViewController.m
//  itleo
//
//  Created by itdept on 14-12-22.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "BarCodeSysHomeViewController.h"
#import "SKSTableView.h"
#import "DB_whs_config.h"
#import "DB_LoginInfo.h"
#import "Cell_advance_search.h"
#import "SKSTableViewCell.h"
#import "BarCodeViewController.h"

#define FIXSPACE 15
#define TEXTFIELD_TAG 100
typedef NSString* (^passValue)(NSInteger tag);

@interface BarCodeSysHomeViewController ()<SKSTableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet SKSTableView *skstableView;
@property (strong, nonatomic) Custom_textField *checkText;
//存储组标题信息
@property (strong, nonatomic) NSMutableArray *alist_whs_headers;
@property (strong, nonatomic) NSMutableArray *alist_upload_cols;

@property (strong, nonatomic) NSMutableDictionary *idic_textfield_value;
//当前语言
@property (copy, nonatomic) NSString *lang_code;
@property (nonatomic,strong) passValue pass_Value;

@end

@implementation BarCodeSysHomeViewController
@synthesize alist_whs_headers;
@synthesize alist_upload_cols;
@synthesize idic_textfield_value;
@synthesize lang_code;

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
  
    [self fn_set_property];
    [self fn_add_right_items];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_property{
    [_ibtn_whs_logo setTitle:MY_LocalizedString(@"lbl_whs_logo", nil) forState:UIControlStateNormal];
    [_ibtn_whs_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
    NSMutableArray *arr=[db fn_get_all_LoginInfoData];
    if ([arr count]!=0) {
        lang_code=[[arr objectAtIndex:0]valueForKey:@"lang_code"];
    }
    db=nil;
    arr=nil;
    
    DB_whs_config *db_whs=[[DB_whs_config alloc]init];
    alist_whs_headers=[db_whs fn_get_group_data:@"true"];
    NSMutableArray *arr_upload_cols=[db_whs fn_get_upload_col_data];
    
    alist_upload_cols=[[NSMutableArray alloc]init];
    for (NSMutableDictionary *dic_whs_header in alist_whs_headers) {
        NSString *unique_id=[dic_whs_header valueForKey:@"unique_id"];
        NSArray *arr_filtered=[arr_upload_cols filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(unique_id==%@)",unique_id]];
        [alist_upload_cols addObject:arr_filtered];
        unique_id=nil;
        arr_filtered=nil;
    }
    arr_upload_cols=nil;
    db_whs=nil;
    self.skstableView.SKSTableViewDelegate=self;
    [self.skstableView fn_expandall];
    idic_textfield_value=[[NSMutableDictionary alloc]init];
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
}
-(void)fn_add_right_items{
    UIBarButtonItem *ibtn_save=[[UIBarButtonItem alloc]initWithTitle:MY_LocalizedString(@"ibtn_save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(fn_save_whs_data)];
    UIBarButtonItem *ibtn_space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ibtn_space.width=FIXSPACE;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,1.5,20)];
    view.backgroundColor=[UIColor lightGrayColor];
    UIBarButtonItem *ibtn_space1=[[UIBarButtonItem alloc]initWithCustomView:view];
    ibtn_space1.width=1.5;
    view=nil;
    UIBarButtonItem *ibtn_space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    ibtn_space2.width=FIXSPACE;
    UIBarButtonItem *ibtn_cancel=[[UIBarButtonItem alloc]initWithTitle:MY_LocalizedString(@"lbl_cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(fn_cancel_operation)];
    NSArray *array=@[ibtn_save,ibtn_space,ibtn_space1,ibtn_space2,ibtn_cancel];
    self.navigationItem.rightBarButtonItems=array;
    array=nil;
}
#pragma mark -event action
- (void)fn_save_whs_data{
    
}
- (void)fn_cancel_operation{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)fn_scan_the_barcode:(id)sender{
    BarCodeViewController *barCodeVC=(BarCodeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BarCodeViewController"];
    [self presentViewController:barCodeVC animated:YES completion:nil];
}
#pragma mark -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.checkText=(Custom_textField*)textField;
    [self.checkText fn_setLine_color:[UIColor blueColor]];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.checkText fn_setLine_color:[UIColor lightGrayColor]];
    NSString *os_column_key=_pass_Value(textField.tag);
    if ([textField.text length]!=0) {
        [idic_textfield_value setObject:textField.text forKey:os_column_key];
    }
    os_column_key=nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -SKSTableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_whs_headers count];
}
-(NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    NSString *numOfrow=[[alist_whs_headers objectAtIndex:indexPath.row]valueForKey:@"NUM"];
    return [numOfrow integerValue];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取每组的字典
    NSDictionary *dic=[alist_whs_headers objectAtIndex:indexPath.row];
    static NSString *cellIndentifier=@"SKSTableViewCell";
    SKSTableViewCell *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[SKSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.backgroundColor=COLOR_light_BLUE;
    cell.expandable=YES;
    cell.textLabel.text=[dic valueForKey:lang_code];
    dic=nil;
    return cell;
}
-(UITableViewCell*)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=alist_upload_cols[indexPath.row][indexPath.subRow-1];
    static NSString *cellIndentifer=@"Cell_whs_config";
    Cell_advance_search *cell=[self.skstableView dequeueReusableCellWithIdentifier:cellIndentifer];
    cell.itf_inputdata.tag=TEXTFIELD_TAG*indexPath.row+indexPath.subRow;
    cell.itf_inputdata.delegate=self;
    __block BarCodeSysHomeViewController * blockSelf=self;
    _pass_Value=^NSString*(NSInteger tag){
        NSInteger i=tag/TEXTFIELD_TAG;
        NSInteger j=tag-i*TEXTFIELD_TAG-1;
        NSMutableDictionary *idic=blockSelf->alist_upload_cols[i][j];
        NSString *col_field=[idic valueForKey:@"col_field"];
        return col_field;
    };
    NSString *col_type=[dic valueForKey:@"col_type"];
    NSInteger is_mandatory=[[dic valueForKey:@"is_mandatory"]integerValue];
    NSString *col_field=[dic valueForKey:@"col_field"];
    if (is_mandatory==0) {
        cell.il_prompt.text=[NSString stringWithFormat:@"%@:",[dic valueForKey:lang_code]];
    }else{
        cell.il_prompt.text=[NSString stringWithFormat:@"%@:*",[dic valueForKey:lang_code]];
    }
    cell.itf_inputdata.text=[idic_textfield_value valueForKey:col_field];
    if ([col_type isEqualToString:@"barcode"]) {
        UIButton *ibtn_barCode=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
        [ibtn_barCode setBackgroundImage:[UIImage imageNamed:@"barcode"] forState:UIControlStateNormal];
        [ibtn_barCode addTarget:self action:@selector(fn_scan_the_barcode:) forControlEvents:UIControlEventTouchUpInside];
        ibtn_barCode.tag=indexPath.row*10+indexPath.subRow;
        cell.accessoryView=ibtn_barCode;
        ibtn_barCode=nil;
    }else{
        cell.accessoryView=nil;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end