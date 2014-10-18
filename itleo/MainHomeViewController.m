//
//  MainHomeViewController.m
//  itleo
//
//  Created by itdept on 14-8-9.
//  Copyright (c) 2014年 itdept. All rights reserved.
//

#import "MainHomeViewController.h"
#import "LEOLoginViewController.h"
#import "Menu_home.h"
#import "Cell_menu_item.h"
#import "DB_LoginInfo.h"
#import "DB_single_field.h"
#import "DB_RespAppConfig.h"
#import "DB_Location.h"

@interface MainHomeViewController ()
@property(strong,nonatomic)NSMutableArray *alist_menu;
@property(strong,nonatomic)Menu_home *menu_item;
@end

@implementation MainHomeViewController
@synthesize alist_menu;
@synthesize menu_item;
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
    [self fn_users_isLogin];
    [self fn_set_nav_left_item];
    [self fn_create_menu];
    [self fn_show_different_language];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark show different languge
-(void) fn_show_different_language{

    [_ibtn_logout setTitle:MY_LocalizedString(@"lbl_logout", nil) forState:UIControlStateNormal];
}
#pragma mark creat menu item
-(void) fn_create_menu{
    alist_menu=[[NSMutableArray alloc]init];
    [alist_menu addObject:[Menu_home fn_create_item:@"Air Load Plan" image:@"ic_airloadplan" segue:@"segue_aejob_browse"]];
    [alist_menu addObject:[Menu_home fn_create_item:@"Chart" image:@"ic_itdept_logo" segue:@"segue_chart"]];
    [alist_menu addObject:[Menu_home fn_create_item:@"EPOD" image:@"ic_itdept_logo" segue:@"segue_epod"]];
    self.icollectionView.delegate=self;
    self.icollectionView.dataSource=self;
    [self.icollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell_menu"];
}
-(void)fn_set_nav_left_item{
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:MY_LocalizedString(@"lbl_home", nil)
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:nil
                                                                          action:nil];
    [self.navigationItem setHidesBackButton:YES];
    [_ibtn_home_logo setTitle:MY_LocalizedString(@"lbl_home", nil) forState:UIControlStateNormal];
    [_ibtn_home_logo setImage:[UIImage imageNamed:@"itdept_itleo"] forState:UIControlStateNormal];
}
-(void)fn_users_isLogin{
    LEOLoginViewController *VC=(LEOLoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LEOLoginViewController"];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSInteger login_flag=[userDefaults integerForKey:@"isLogin"];
    if (login_flag==0) {
        [self presentViewController:VC animated:NO completion:^(){}];
    }else{
        NSString *lang=[self fn_get_lang_code];
        [[MY_LocalizedString getshareInstance]fn_setLanguage_type:lang];
    }
    
}
-(NSString*)fn_get_lang_code{
    DB_LoginInfo *db=[[DB_LoginInfo alloc]init];
    NSMutableArray *arr=[db fn_get_all_LoginInfoData];
    NSString *lang_code=@"";
    if ([arr count]!=0) {
        lang_code=[[arr objectAtIndex:0]valueForKey:@"lang_code"];
        if ([lang_code isEqualToString:@"EN"]) {
            lang_code=@"en";
        }
        if ([lang_code isEqualToString:@"CN"]) {
            lang_code=@"zh-Hans";
        }
        if ([lang_code isEqualToString:@"TCN"]) {
            lang_code=@"zh-Hant";
        }
    }
    return lang_code;
}
- (IBAction)fn_logout_itleo:(id)sender {
    DB_single_field *db=[[DB_single_field alloc]init];
    [db fn_delete_all_data:@"vehicle_no"];
    DB_Location *db_location=[[DB_Location alloc]init];
    [db_location fn_delete_location_data];
    DB_LoginInfo *db_logininfo=[[DB_LoginInfo alloc]init];
    [db_logininfo fn_delete_LoginInfo_data];
    DB_RespAppConfig *db_config=[[DB_RespAppConfig alloc]init];
    [db_config fn_delete_all_RespAppConfig_data];
    LEOLoginViewController *VC=(LEOLoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LEOLoginViewController"];
    VC.refresh=^(){
        [self viewDidLoad];
    };
    [self presentViewController:VC animated:YES completion:^(){}];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:@"isLogin"];
    [userDefaults synchronize];
}

- (IBAction)fn_click_menu:(id)sender {
    UIButton *ibtn=(UIButton*)sender;
    menu_item=[alist_menu objectAtIndex:ibtn.tag];
    [self performSegueWithIdentifier:menu_item.is_segue sender:self];
}
#pragma mark UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [alist_menu count];
}
// 一个collectionView中的分区数
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Cell_menu_item *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_menu_item" forIndexPath:indexPath];
    int  li_item=[indexPath item];
    menu_item=[alist_menu objectAtIndex:li_item];
    cell.il_title.text=menu_item.is_label;
    [cell.ibtn_image setImage:[UIImage imageNamed:menu_item.is_image] forState:UIControlStateNormal];
    cell.ibtn_image.tag=indexPath.item;
    return cell;
}
#pragma mark – UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(15, 0, 0, 0);
}
@end
