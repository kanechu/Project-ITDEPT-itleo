//
//  Record_LoadPlanViewController.m
//  itleo
//
//  Created by itdept on 14-12-1.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "Record_LoadPlanViewController.h"
#import "Cell_advance_search.h"

@interface Record_LoadPlanViewController ()

@property (nonatomic,strong) NSMutableArray *alist_prompts;
@property(nonatomic,strong)Custom_textField *checkText;
@end

@implementation Record_LoadPlanViewController

@synthesize alist_prompts;
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
    alist_prompts=[@[@"KGS per PKG:",@"PKG:",@"CBM:",@"Length(cm):",@"Width(cm):",@"Height(cm):",@"Remark:"]mutableCopy];
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
    [self fn_set_button_layer:_ibtn_save];
    [self fn_set_button_layer:_ibtn_clear];
    [self fn_set_button_layer:_ibtn_cancel];
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
    //self.tableview.scrollEnabled=YES;
    checkText=(Custom_textField*)textField;
    [checkText fn_setLine_color:[UIColor blueColor]];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [checkText fn_setLine_color:[UIColor lightGrayColor]];
    //self.tableview.scrollEnabled=NO;
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
    
}

- (IBAction)fn_clear_input_data:(id)sender {
    
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
    cell.il_prompt.text=[alist_prompts objectAtIndex:indexPath.row];
    cell.itf_inputdata.delegate=self;
    return cell;
}
#pragma mark -UITableViewDelegate


@end
