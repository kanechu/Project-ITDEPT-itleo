//
//  Record_LoadPlanViewController.m
//  itleo
//
//  Created by itdept on 14-12-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Record_LoadPlanViewController.h"
#import "Cell_advance_search.h"
#define TEXTFIELD_TAG 100
typedef NSString* (^passValue)(NSInteger tag);
@interface Record_LoadPlanViewController ()
//存储输入内容的提示
@property (nonatomic,strong) NSMutableArray *alist_prompts;
@property (nonatomic,strong) NSMutableArray *alist_columns;
@property (nonatomic,strong) NSMutableDictionary *idic_load_datas;
@property (nonatomic,strong) Custom_textField *checkText;
@property (nonatomic,strong) passValue pass_Value;
@end

@implementation Record_LoadPlanViewController

@synthesize alist_prompts;
@synthesize alist_columns;
@synthesize idic_load_datas;
@synthesize checkText;

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
    alist_prompts=[@[MY_LocalizedString(@"lbl_kgs_per_pkg", nil),MY_LocalizedString(@"lbl_so_pkg", nil),MY_LocalizedString(@"lbl_so_cbm", nil),MY_LocalizedString(@"lbl_length", nil),MY_LocalizedString(@"lbl_width", nil),MY_LocalizedString(@"lbl_height", nil),MY_LocalizedString(@"lbl_remark", nil)]mutableCopy];
    alist_columns=[@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]mutableCopy];
    idic_load_datas=[[NSMutableDictionary alloc]init];
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    [self fn_custom_gestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fn_set_control_pro{
    
#warning -neet fix
    [_ibtn_itleo_logo setTitle:@"Load plan" forState:UIControlStateNormal];
    [_ibtn_itleo_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
    [_ibtn_delete setTitle:MY_LocalizedString(@"lbl_delete", nil)];
    if (_flag_isAdd==1) {
        [_ibtn_delete setTitle:@""];
    }
    [self fn_set_button_layer:_ibtn_save];
    [self fn_set_button_layer:_ibtn_clear];
    [self fn_set_button_layer:_ibtn_cancel];
    [_ibtn_save setTitle:MY_LocalizedString(@"ibtn_save", nil) forState:UIControlStateNormal];
    [_ibtn_clear setTitle:MY_LocalizedString(@"ibtn_clear", nil) forState:UIControlStateNormal];
    [_ibtn_cancel setTitle:MY_LocalizedString(@"lbl_cancel", nil) forState:UIControlStateNormal];
}
-(void)fn_set_button_layer:(id)sender{
    UIButton *ibtn=(UIButton*)sender;
    ibtn.layer.cornerRadius=2;
    ibtn.layer.borderWidth=0.5;
    ibtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
}
#pragma mark -custom gesture
-(void)fn_custom_gestureRecognizer{
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_hiden_keyboard:)];
    [self.view addGestureRecognizer:gesture];
}
-(void)fn_hiden_keyboard:(UITapGestureRecognizer*)tap{
    [self.tableview reloadData];
}
#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   
    checkText=(Custom_textField*)textField;
    [checkText fn_setLine_color:[UIColor blueColor]];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [checkText fn_setLine_color:[UIColor lightGrayColor]];
     NSString *os_column_key=_pass_Value(textField.tag);
    if ([textField.text length]!=0) {
        [idic_load_datas setObject:textField.text forKey:os_column_key];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
#pragma mark -event action
- (IBAction)fn_delete_data:(id)sender {
    
}
- (IBAction)fn_save_data:(id)sender {
    NSLog(@"%@",idic_load_datas);
}

- (IBAction)fn_clear_input_data:(id)sender {
    [idic_load_datas removeAllObjects];
    [self.tableview reloadData];
}

- (IBAction)fn_cancel_input_data:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [alist_prompts count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer=@"Cell_add_row";
    Cell_advance_search *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifer forIndexPath:indexPath];
    if (indexPath.row%2==0) {
        cell.backgroundColor=COLOR_LIGHT_BLUE;
    }else{
        cell.backgroundColor=COLOR_LIGHT_GRAY;
    }
    if (indexPath.row==[alist_prompts count]-1) {
        cell.itf_inputdata.keyboardType=UIKeyboardTypeDefault;
    }else{
        cell.itf_inputdata.keyboardType=UIKeyboardTypeDecimalPad;
    }
    __block Record_LoadPlanViewController * blockSelf=self;
    _pass_Value=^NSString*(NSInteger tag){
        return blockSelf->alist_columns[tag-TEXTFIELD_TAG];
    };
    cell.il_prompt.text=[alist_prompts objectAtIndex:indexPath.row];
    cell.itf_inputdata.delegate=self;
    cell.itf_inputdata.tag=TEXTFIELD_TAG+indexPath.row;
    NSString *os_column_key=[alist_columns objectAtIndex:indexPath.row];
    cell.itf_inputdata.text=[idic_load_datas valueForKey:os_column_key];
    
    return cell;
}
#pragma mark -UITableViewDelegate


@end
