//
//  EPODDetailViewController.m
//  itleo
//
//  Created by itdept on 14-9-6.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "EPODDetailViewController.h"
#import "ManageImageViewController.h"
#import "Web_update_epod.h"
#import "Cell_status_list.h"
#import "DB_ePod.h"
#import "Conversion_helper.h"
#import "IsAuto_upload_data.h"
#import "Truck_order_data.h"
#import "Truck_order_image_data.h"
#import "DB_LoginInfo.h"
#import "RespEpod_updmilestone.h"
#import "Epod_upd_milestone_image_contract.h"
#import "Order_InfoViewController.h"
@interface EPODDetailViewController ()
//存储显示的配置单状态
@property(nonatomic,strong) NSMutableArray *arr_status;
//存储上传到服务器的配置单状态标识
@property(nonatomic,strong) NSArray *arr_status_flag;
//“其他”状态的说明
@property(nonatomic,copy) NSString *status_explain;
//客户选择的配载单状态
@property(nonatomic,copy) NSString *flag_status;
//用于标记，说明输入框，是否可用
@property(nonatomic,assign)NSInteger flag_enable;
//配置单信息
@property(nonatomic,strong)Truck_order_data *truck_order_data;
//存储图片的信息
@property(nonatomic,strong)NSMutableArray *alist_image_ms;
//区分不同的文本框
@property(nonatomic,assign)NSInteger flag_textfield;

@end

@implementation EPODDetailViewController
@synthesize flag_status;
@synthesize flag_enable;
@synthesize flag_textfield;
@synthesize alist_image_ms;
@synthesize arr_status_flag;
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
    _arr_status=[NSMutableArray arrayWithObjects:MY_LocalizedString(@"lbl_start", nil),MY_LocalizedString(@"lbl_arrive", nil),MY_LocalizedString(@"lbl_complete", nil),MY_LocalizedString(@"lbl_other", nil), nil];
    arr_status_flag=@[@"pod1",@"pod2",@"pod3",@"pod4"];
    flag_enable=0;
    
    [self fn_set_control_pro];
    [self fn_custom_gestureRecognizer];
    
    [KeyboardNoticeManager sharedKeyboardNoticeManager];
    

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fn_set_control_pro{
    self.title=MY_LocalizedString(@"lbl_epod_set_title", nil);
    
    _ilb_order_no.text=[NSString stringWithFormat:@"%@:",MY_LocalizedString(@"lbl_order_no", nil)];
    
    _itf_order_no.layer.cornerRadius=4;
    _itf_order_no.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _itf_order_no.layer.borderWidth=1;
    _itf_order_no.delegate=self;
    
    [_ibtn_check_info setTitle:MY_LocalizedString(@"lbl_check_order", nil) forState:UIControlStateNormal];
    [_ibtn_manage setTitle:MY_LocalizedString(@"ibtn_image_mang", nil) forState:UIControlStateNormal];
    [_ibtn_uploading setTitle:MY_LocalizedString(@"ibtn_upload", nil) forState:UIControlStateNormal];
    
    [self fn_set_style:_ibtn_check_info];
    [self fn_set_style:_ibtn_manage];
    [self fn_set_style:_ibtn_uploading];
    
    self.tableview.layer.cornerRadius=8;
    self.tableview.layer.borderColor=COLOR_light_BLUE.CGColor;
    self.tableview.layer.borderWidth=1.5;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
    _ilb_show_picture_nums.text=[NSString stringWithFormat:@"%@:0",MY_LocalizedString(@"lbl_image_num", nil)];
}
-(void)fn_set_style:(id)sender{
    UIButton *ibtn=(UIButton*)sender;
    ibtn.layer.cornerRadius=5;
    ibtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    ibtn.layer.borderWidth=1;
}
#pragma mark -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_itf_order_no.editing) {
        flag_textfield=1;
    }else{
        flag_textfield=2;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{

    if (flag_enable==1 && flag_textfield==2) {
        _status_explain=textField.text;
    }else{
        _status_explain=@"";
        DB_ePod *db=[[DB_ePod alloc]init];
        NSMutableArray *alist_result=[db fn_select_ePod_data:_itf_order_no.text vehicle_no:_vehicle_no];
        if ([alist_result count]!=0) {
            flag_status=[[alist_result objectAtIndex:0]valueForKey:@"status"];
            NSInteger flag_isOther=0;
            for (NSString *status in arr_status_flag) {
                if ([flag_status isEqualToString:status]) {
                    flag_isOther=1;
                }
            }
            if (flag_isOther==0) {
                _status_explain=flag_status;
                flag_status=@"pod4";
            }
        }
        [self fn_get_epod_ms];
        _ilb_show_picture_nums.text=[NSString stringWithFormat:@"%@:%d",MY_LocalizedString(@"lbl_image_num", nil),[alist_result count]];
        [self.tableview reloadData];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_itf_order_no resignFirstResponder];
    return YES;
}

#pragma mark -add GestureRecognizer
- (void)fn_custom_gestureRecognizer{
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fn_hiden_keyboard:)];
    [self.view addGestureRecognizer:gesture];
}
- (void)fn_hiden_keyboard:(UITapGestureRecognizer*)gesture{
    [_itf_order_no resignFirstResponder];
    [self.tableview reloadData];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arr_status count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *is_status=[_arr_status objectAtIndex:indexPath.row];
    NSString *is_status_flag=[arr_status_flag objectAtIndex:indexPath.row];
    if ([is_status_flag isEqualToString:@"pod4"]) {
        static NSString *cellIndentifier=@"Cell_status_list";
        Cell_status_list *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier];
        [cell.ibtn_radio setTitle:is_status forState:UIControlStateNormal];
        cell.ibtn_radio.delegate=self;
        
        cell.itf_declare.delegate=self;
    cell.itf_declare.placeholder=MY_LocalizedString(@"lbl_desc", nil);
        cell.itf_declare.text=_status_explain;
        
        cell.flag_enable=flag_enable;
        if ([flag_status isEqualToString:is_status_flag]) {
            cell.ibtn_radio.checked=YES;
        }
        return cell;

    }else{
        static NSString *cellIndentifier=@"UITableViewCell";
        UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
        }
        UILabel *il_status_prompt=(UILabel*)[cell.contentView viewWithTag:100];
        QRadioButton *ibtn=(QRadioButton*)[cell.contentView viewWithTag:200];
        
        [ibtn setTitle:is_status  forState:UIControlStateNormal];
        ibtn.delegate=self;
        if (indexPath.row==0) {
            il_status_prompt.text=MY_LocalizedString(@"lbl_status", nil);
        }else{
            il_status_prompt.text=@"";
        }
        if ([is_status_flag isEqualToString:flag_status]) {
            ibtn.checked=YES;
        }
        return cell;
    }
    return nil;
}
#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *is_status=[_arr_status objectAtIndex:indexPath.row];
    if ([is_status isEqualToString:MY_LocalizedString(@"lbl_other", nil)]){
        return 70;
    }else{
        return 28;
    }
}
#pragma mark -QRadioButtonDelegate
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    flag_status=radio.titleLabel.text;
    NSInteger index=[_arr_status indexOfObject:flag_status];
    flag_status=[arr_status_flag objectAtIndex:index];
    if ([flag_status isEqualToString:@"pod4"]) {
        flag_enable=1;
    }else{
        flag_enable=0;
    }
    [self.tableview reloadData];
}
#pragma mark -event action

- (IBAction)fn_check_info:(id)sender {
    if ([_itf_order_no.text length]==0) {
        [self fn_Pop_up_alertView];
    }else{
        Order_InfoViewController *VC=(Order_InfoViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Order_InfoViewController"];
        VC.car_no=_vehicle_no;
        VC.order_no=_itf_order_no.text;
        [self presentViewController:VC animated:YES completion:nil];
    }
}

- (IBAction)fn_manage_picture:(id)sender {
    if ([_itf_order_no.text length]==0) {
        [self fn_Pop_up_alertView];
    }else{
        [self performSegueWithIdentifier:@"segue_manage" sender:self];
    }
    
}
-(void)fn_Pop_up_alertView{
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:MY_LocalizedString(@"order_empty_prompt", nil) delegate:self cancelButtonTitle:MY_LocalizedString(@"lbl_ok", nil) otherButtonTitles:nil, nil];
    [alertview show];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ManageImageViewController *VC=(ManageImageViewController*)[segue destinationViewController];
    VC.alist_image_ms=alist_image_ms;
    VC.is_order_no=_itf_order_no.text;
    VC.callBack=^(NSMutableArray *alist_image){
        alist_image_ms=alist_image;
        _ilb_show_picture_nums.text=[NSString stringWithFormat:@"%@:%d",MY_LocalizedString(@"lbl_image_num", nil),[alist_image count]];
        
    };
    
}
/**
 *  输入配载单号后，获取改配载单号的信息
 */
-(void)fn_get_epod_ms{
    DB_ePod *db=[[DB_ePod alloc]init];
    NSMutableArray *alist_result=[db fn_select_ePod_data:_itf_order_no.text vehicle_no:_vehicle_no];
    NSMutableArray *arr_images_ms=[NSMutableArray array];
    for (NSMutableDictionary *dic in alist_result) {
        Truck_order_image_data *uploaded_image_ms=[[Truck_order_image_data alloc]init];
        uploaded_image_ms.image=[dic valueForKey:@"image"];
        uploaded_image_ms.image_remark=[dic valueForKey:@"image_remark"];
        uploaded_image_ms.image_isUploaded=[dic valueForKey:@"image_isUploaded"];
        [arr_images_ms addObject:uploaded_image_ms];
    }
    alist_image_ms=arr_images_ms;
}

#pragma mark -uploading data

- (IBAction)fn_uploading_epod:(id)sender {
    
    if ([_itf_order_no.text length]!=0) {
        Truck_order_data *upload_ms=[self fn_set_upload_data];
        
        DB_ePod *db=[[DB_ePod alloc]init];
        [db fn_save_ePod_data:upload_ms image_ms:alist_image_ms];
        [SVProgressHUD showWithStatus:MY_LocalizedString(@"upload_prompt", nil)];
        if ([self fn_check_network]) {
            UpdateFormContract *updateform=[[UpdateFormContract alloc]init];
            
            if ([alist_image_ms count]==0) {
                NSMutableArray *arr_result=[db fn_select_ePod_data_no_image:_itf_order_no.text vehicle_no:_vehicle_no];
                for (NSMutableDictionary *idic in arr_result) {
                    updateform.unique_id=[idic valueForKey:@"unique_id"];
                    updateform.order_no=[idic valueForKey:@"order_no"];
                    updateform.ms_status=[idic valueForKey:@"status"];
                    updateform.vehicle_no=[idic valueForKey:@"vehicle_no"];
                }
            }else{
                NSMutableArray *arr_result=[db fn_select_ePod_data:_itf_order_no.text vehicle_no:_vehicle_no];
                NSMutableArray *arr_image=[NSMutableArray array];
                for (NSMutableDictionary *idic in arr_result) {
                    updateform.unique_id=[idic valueForKey:@"unique_id"];
                    updateform.order_no=[idic valueForKey:@"order_no"];
                    updateform.ms_status=[idic valueForKey:@"status"];
                    updateform.vehicle_no=[idic valueForKey:@"vehicle_no"];
                    Epod_upd_milestone_image_contract *upd_imageForm=[[Epod_upd_milestone_image_contract alloc]init];
                    upd_imageForm.unique_id=[idic valueForKey:@"img_unique_id"];
                    upd_imageForm.ms_upload_queue_id=[idic valueForKey:@"correlation_id"];
                    upd_imageForm.ms_imgBase64=[idic valueForKey:@"image"];
                    NSString *image_remark=[idic valueForKey:@"image_remark"];
                    if ([image_remark length]!=0) {
                        upd_imageForm.img_remark=image_remark;
                    }
                    [arr_image addObject:upd_imageForm];
                }
                updateform.Epod_upd_milestone_image=[NSSet setWithArray:arr_image];
            }
            
            DB_LoginInfo *db_loginInfo=[[DB_LoginInfo alloc]init];
            AuthContract *auth=[db_loginInfo fn_get_RequestAuth];
            Web_update_epod *upload_obj=[[Web_update_epod alloc]init];
            [upload_obj fn_upload_epod_data:updateform Auth:auth back_result:^(NSMutableArray* arr_result){
                if ([arr_result count]!=0) {
                    RespEpod_updmilestone *respEpod=[arr_result objectAtIndex:0];
                    NSSet *resp_upd_images=respEpod.Epod_upd_milestone_image_Result;
                    NSString *unique_id=respEpod.unique_id;
                    NSString *is_upload_sucess=respEpod.is_upload_sucess;
                    NSString *upload_date=respEpod.upload_date;
                    NSString *error_reason=respEpod.error_reason;
                    NSString *error_date=respEpod.error_date;
                    if ([is_upload_sucess isEqualToString:@"true"]) {
                        [db fn_update_epod_after_uploaded:unique_id is_uploaded:@"1" date:upload_date result:@"isuccess" user_code:auth.user_code system:auth.system  images:resp_upd_images];
                        
                        [SVProgressHUD dismissWithSuccess:MY_LocalizedString(@"upload_success", nil)];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [db fn_update_epod_after_uploaded:unique_id is_uploaded:@"2" date:error_date result:error_reason user_code:auth.user_code system:auth.system  images:resp_upd_images];
                        [SVProgressHUD dismissWithError:MY_LocalizedString(@"upload_fail", nil) afterDelay:2.0];
                    }
                }
            }];
        }
    }else{
        
        [self fn_Pop_up_alertView];
    }
    
}
-(Truck_order_data*)fn_set_upload_data{
    DB_LoginInfo *db_loginInfo=[[DB_LoginInfo alloc]init];
    AuthContract *auth=[db_loginInfo fn_get_RequestAuth];
    Truck_order_data *upload_data=[[Truck_order_data alloc]init];
    upload_data.user_code=auth.user_code;
    upload_data.password=auth.password;
    upload_data.system_name=auth.system;
    upload_data.version=auth.version;
    upload_data.vehicle_no=_vehicle_no;
    upload_data.order_no=_itf_order_no.text;
    if (flag_enable==0) {
        upload_data.status=flag_status;
    }else{
        upload_data.status=_status_explain;
    }
    return upload_data;
}
-(NSString*)fn_get_current_date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[NSDate date];
    NSString *str_date=[dateFormatter stringFromDate:date];
    return str_date;
}
/**
 *  检查网络是否连接，如果没有连接，把数据存储下来
 *
 *  @return bool值
 */
-(BOOL)fn_check_network{
    IsAuto_upload_data *obj=[[IsAuto_upload_data alloc]init];
    if ([obj fn_check_isNetworking]) {
        return YES;
    }else{
        [SVProgressHUD dismissWithError:MY_LocalizedString(@"msg_network_fail", nil) afterDelay:2.0f];
        DB_ePod *db=[[DB_ePod alloc]init];
        Truck_order_data *upload_ms=[self fn_set_upload_data];
        upload_ms.result=@"ianomaly";
        upload_ms.is_uploaded=@"0";
        if (flag_enable==0) {
            upload_ms.status=flag_status;
        }else{
            upload_ms.status=_status_explain;
        }
        upload_ms.error_date=[self fn_get_current_date];
        [db fn_save_ePod_data:upload_ms image_ms:alist_image_ms];
        return NO;
    }
}

@end
