//
//  BarCodeSysHomeViewController.m
//  itleo
//
//  Created by itdept on 14-12-29.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "BarCodeSysHomeViewController.h"
#import "BarCodeSysDetailViewController.h"
#import "DB_whs_config.h"
#import "DB_LoginInfo.h"
@interface BarCodeSysHomeViewController ()
//存储Menu item 信息
@property (strong, nonatomic) NSMutableArray *alist_whs_menus;
@property (copy, nonatomic) NSString *lang_code;
@property (assign, nonatomic) NSInteger flag_select_row;
@end

@implementation BarCodeSysHomeViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fn_set_property{
    DB_whs_config *db_whs=[[DB_whs_config alloc]init];
    _alist_whs_menus=[db_whs fn_get_group_data:@"true"];
    db_whs=nil;
    DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
    NSMutableArray *arr=[db fn_get_all_LoginInfoData];
    if ([arr count]!=0) {
        _lang_code=[[arr objectAtIndex:0]valueForKey:@"lang_code"];
    }
    db=nil;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_alist_whs_menus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer=@"cell_whs_menu";
    
    UITableViewCell *cell=[self.tableview dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    //获取menu的字典
    NSDictionary *dic=[_alist_whs_menus objectAtIndex:indexPath.row];
    UIButton *ibtn_menu=(UIButton*)[cell.contentView viewWithTag:55];
    [ibtn_menu addTarget:self action:@selector(fn_enter_next_page:) forControlEvents:UIControlEventTouchUpInside];
    ibtn_menu.tag=indexPath.row;
    NSString *str_menuItem=[dic valueForKey:_lang_code];
    [ibtn_menu setTitle:str_menuItem forState:UIControlStateNormal];
    return cell;
}

- (void)fn_enter_next_page:(id)sender{
    UIButton *ibtn=(UIButton*)sender;
    _flag_select_row=ibtn.tag;
    [self performSegueWithIdentifier:@"segue_barCodeSysDel" sender:self];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSMutableDictionary *dic=[_alist_whs_menus objectAtIndex:_flag_select_row];
    BarCodeSysDetailViewController *VC=(BarCodeSysDetailViewController*)[segue destinationViewController];
    VC.lang_code=_lang_code;
    VC.unique_id=[dic valueForKey:@"unique_id"];
    VC.logo_title=[dic valueForKey:_lang_code];
}


@end
