//
//  Web_base.m
//  worldtrans
//
//  Created by itdept on 3/25/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import "Web_base.h"
#import <RestKit/RestKit.h>
#import "Epod_upd_milestone_image_contract.h"
#import "UpdateFormContract_GPS.h"
#import "Warehouse_receive_data.h"

#import "Resp_DashboardDtlResult.h"
#import "Resp_DashboardGrpResult.h"
#import "Resp_data.h"
#import "Resp_get_chart.h"

#import "Resp_exso.h"
#import "Resp_ExsoBrowseResult.h"
#import "Resp_CTexcfsdimResult.h"
#import "Resp_DataRefresh.h"

#import "Resp_UPLOAD_COL.h"
#import "Resp_language_type.h"

#import "Resp_order_dtl_list.h"
@implementation Web_base

@synthesize il_url;
@synthesize ilist_resp_result;
@synthesize iresp_class;
@synthesize iresp_class1;
@synthesize ilist_resp_mapping;
@synthesize ilist_resp_mapping1;

- (void) fn_get_data:(RequestContract*)ao_form base_url:(NSString*)base_url{
    
    RKObjectMapping *lo_searchMapping = [RKObjectMapping requestMapping];
    [lo_searchMapping addAttributeMappingsFromArray:@[@"os_column",@"os_value",@"os_dyn_1"]];
    
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    [lo_authMapping addAttributeMappingsFromDictionary:@{ @"user_code": @"user_code",
                                                          @"password": @"password",
                                                          @"system": @"system" ,
                                                          @"version": @"version",
                                                          @"encrypted":@"encrypted",
                                                          @"com_sys_code":@"com_sys_code",
                                                          @"app_code":@"app_code",@"company_code":@"company_code"}];
    
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *searchRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"SearchForm"
                                                 toKeyPath:@"SearchForm"
                                                 withMapping:lo_searchMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:searchRelationship];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[RequestContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:iresp_class];
    
    [lo_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self fn_RK_ObjectManager:requestDescriptor :responseDescriptor ao_form:ao_form base_url:base_url];
}
- (void) fn_get_chart_data:(RequestContract *)ao_form Auth:(AuthContract*)auth base_url:(NSString *)base_url{
    //Auth
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    NSArray *arr_auth=[NSArray arrayWithPropertiesOfObject:auth];
    [lo_authMapping addAttributeMappingsFromArray:arr_auth];
    //search form
    RKObjectMapping *lo_searchMapping = [RKObjectMapping requestMapping];
    [lo_searchMapping addAttributeMappingsFromArray:@[@"os_column",@"os_value",@"os_dyn_1"]];
    
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *searchRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"SearchForm"
                                                 toKeyPath:@"SearchForm"
                                                 withMapping:lo_searchMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:searchRelationship];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[RequestContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:[Resp_get_chart class]];
    
    RKObjectMapping* lo_Grp_response_mapping = [RKObjectMapping mappingForClass:[Resp_DashboardGrpResult class]];
    
    [lo_Grp_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[Resp_DashboardGrpResult class]]];
    
    RKObjectMapping* lo_Dtl_response_mapping=[RKObjectMapping mappingForClass:[Resp_DashboardDtlResult class]];
    NSMutableArray *arr_respDtl=[[NSArray arrayWithPropertiesOfObject:[Resp_DashboardDtlResult class]]mutableCopy];
    [arr_respDtl removeLastObject];
    [lo_Dtl_response_mapping addAttributeMappingsFromArray:arr_respDtl];
    
    RKObjectMapping* lo_data_response_mapping = [RKObjectMapping mappingForClass:[Resp_data class]];
    [lo_data_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[Resp_data class]]];
    
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"DashboardGrpDResult" toKeyPath:@"DashboardGrpDResult" withMapping:lo_Grp_response_mapping]];
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"DashboardDtlResult" toKeyPath:@"DashboardDtlResult" withMapping:lo_Dtl_response_mapping]];
    [lo_Dtl_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"data" withMapping:lo_data_response_mapping]];
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self fn_RK_ObjectManager:requestDescriptor :responseDescriptor ao_form:ao_form base_url:base_url];
}
- (void) fn_get_exso_data:(RequestContract *)ao_form Auth:(AuthContract*)auth base_url:(NSString *)base_url{
    //Auth
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    NSArray *arr_auth=[NSArray arrayWithPropertiesOfObject:auth];
    [lo_authMapping addAttributeMappingsFromArray:arr_auth];
    //search form
    RKObjectMapping *lo_searchMapping = [RKObjectMapping requestMapping];
    [lo_searchMapping addAttributeMappingsFromArray:@[@"os_column",@"os_value",@"os_dyn_1"]];
    
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *searchRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"SearchForm"
                                                 toKeyPath:@"SearchForm"
                                                 withMapping:lo_searchMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:searchRelationship];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[RequestContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:[Resp_exso class]];
    
    RKObjectMapping* lo_excoBrowse_response_mapping = [RKObjectMapping mappingForClass:[Resp_ExsoBrowseResult class]];
    
    [lo_excoBrowse_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[Resp_ExsoBrowseResult class]]];
    
    RKObjectMapping* lo_cfsdim_response_mapping=[RKObjectMapping mappingForClass:[Resp_CTexcfsdimResult class]];
    [lo_cfsdim_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[Resp_CTexcfsdimResult class]]];
    
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ITLEOExsoBrowseResult" toKeyPath:@"ITLEOExsoBrowseResult" withMapping:lo_excoBrowse_response_mapping]];
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"CTexcfsdimResult" toKeyPath:@"CTexcfsdimResult" withMapping:lo_cfsdim_response_mapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self fn_RK_ObjectManager:requestDescriptor :responseDescriptor ao_form:ao_form base_url:base_url];
}
- (void) fn_get_whs_config_data:(RequestContract *)ao_form Auth:(AuthContract*)auth base_url:(NSString*)base_url{
    //Auth
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    NSArray *arr_auth=[NSArray arrayWithPropertiesOfObject:auth];
    [lo_authMapping addAttributeMappingsFromArray:arr_auth];
    
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    [lo_reqMapping addPropertyMapping:authRelationship];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[RequestContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping =[RKObjectMapping mappingForClass:iresp_class];
    
    RKObjectMapping* lo_maintform_response_mapping = [RKObjectMapping mappingForClass:iresp_class1];
    
    [lo_maintform_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping1];
    
    RKObjectMapping* lo_languge_response_mapping=[RKObjectMapping mappingForClass:[Resp_language_type class]];
    [lo_languge_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[Resp_language_type class]]];
    
    RKObjectMapping* lo_uploadCol_response_mapping=[RKObjectMapping mappingForClass:[Resp_UPLOAD_COL class]];
    NSMutableArray *alist_upload_col=[[NSArray arrayWithPropertiesOfObject:[Resp_UPLOAD_COL class]]mutableCopy];
    [alist_upload_col removeObjectAtIndex:2];
    [alist_upload_col removeObjectAtIndex:5];
    [lo_uploadCol_response_mapping addAttributeMappingsFromArray:alist_upload_col];
    
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"MaintForm" toKeyPath:@"MaintForm" withMapping:lo_maintform_response_mapping]];
    [lo_maintform_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"UPLOAD_COL" toKeyPath:@"UPLOAD_COL" withMapping:lo_uploadCol_response_mapping]];
    
    [lo_uploadCol_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"col_label" toKeyPath:@"col_label" withMapping:lo_languge_response_mapping]];
    [lo_uploadCol_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"group_name" toKeyPath:@"group_name" withMapping:lo_languge_response_mapping]];    
    [lo_maintform_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"FORMAT_NAME" toKeyPath:@"FORMAT_NAME" withMapping:lo_languge_response_mapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self fn_RK_ObjectManager:requestDescriptor :responseDescriptor ao_form:ao_form base_url:base_url];
    
}
- (void) fn_get_order_list_data:(RequestContract *)ao_form Auth:(AuthContract*)auth base_url:(NSString*)base_url{
    
    //Auth
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    NSArray *arr_auth=[NSArray arrayWithPropertiesOfObject:auth];
    [lo_authMapping addAttributeMappingsFromArray:arr_auth];
    //upload form
    RKObjectMapping *lo_updateMapping = [RKObjectMapping requestMapping];
    NSMutableArray *arr_updateform=[[NSArray arrayWithPropertiesOfObject:[UpdateForm_orderList class]]mutableCopy];
    [arr_updateform removeLastObject];
    [lo_updateMapping addAttributeMappingsFromArray:arr_updateform];
    
    RKRelationshipMapping *searchRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"UpdateForm"
                                                 toKeyPath:@"UpdateForm"
                                                 withMapping:lo_updateMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:searchRelationship];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[RequestContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:[iresp_class class]];
    [lo_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping];
    
    RKObjectMapping* lo_order_response_mapping=[RKObjectMapping mappingForClass:[iresp_class1 class]];
    [lo_order_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping1];
    
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ls_order_list" toKeyPath:@"ls_order_list" withMapping:lo_order_response_mapping]];
    
    RKObjectMapping* lo_order_dtl_response_mapping=[RKObjectMapping mappingForClass:[Resp_order_dtl_list class]];
    [lo_order_dtl_response_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[Resp_order_dtl_list class]]];
    
    [lo_order_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ls_order_dtl_list" toKeyPath:@"ls_order_dtl_list" withMapping:lo_order_dtl_response_mapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self fn_RK_ObjectManager:requestDescriptor :responseDescriptor ao_form:ao_form base_url:base_url];

}
#pragma mark -upload data
- (void) fn_uploaded_data:(UploadContract*)ao_form Auth:(AuthContract*)auth base_url:(NSString*)base_url{
    //Auth
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    NSArray *arr_auth=[NSArray arrayWithPropertiesOfObject:auth];
    [lo_authMapping addAttributeMappingsFromArray:arr_auth];
    //upload form
    RKObjectMapping *lo_updateMapping = [RKObjectMapping requestMapping];
    NSMutableArray *arr_updateform=[[NSArray arrayWithPropertiesOfObject:[UpdateFormContract class]]mutableCopy];
    [arr_updateform removeLastObject];
    [lo_updateMapping addAttributeMappingsFromArray:arr_updateform];
    //upd image form
    RKObjectMapping *lo_upd_imageMapping=[RKObjectMapping requestMapping];
    [lo_upd_imageMapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[Epod_upd_milestone_image_contract class]]];
   
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *searchRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"UpdateForm"
                                                 toKeyPath:@"UpdateForm"
                                                 withMapping:lo_updateMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    RKRelationshipMapping *upd_imageRelationship=[RKRelationshipMapping relationshipMappingFromKeyPath:@"Epod_upd_milestone_image" toKeyPath:@"Epod_upd_milestone_image" withMapping:lo_upd_imageMapping];
    [lo_updateMapping addPropertyMapping:upd_imageRelationship];
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:searchRelationship];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[UploadContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:[iresp_class class]];
    [lo_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping];
    
    RKObjectMapping* lo_image_response_mapping=[RKObjectMapping mappingForClass:[iresp_class1 class]];
    [lo_image_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping1];
   
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Epod_upd_milestone_image_Result" toKeyPath:@"Epod_upd_milestone_image_Result" withMapping:lo_image_response_mapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self fn_RK_ObjectManager:requestDescriptor :responseDescriptor ao_form:ao_form base_url:base_url];
}
- (void) fn_uploaded_GPS:(UploadGPSContract*)ao_form Auth:(AuthContract*)auth base_url:(NSString*)base_url{
    //Auth
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    NSArray *arr_auth=[NSArray arrayWithPropertiesOfObject:auth];
    [lo_authMapping addAttributeMappingsFromArray:arr_auth];
    //upload GPS form
    RKObjectMapping *lo_updateMapping = [RKObjectMapping requestMapping];
    NSMutableArray *arr_updateform=[[NSArray arrayWithPropertiesOfObject:[UpdateFormContract_GPS class]]mutableCopy];
    [lo_updateMapping addAttributeMappingsFromArray:arr_updateform];
    
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *searchRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"UpdateForm"
                                                 toKeyPath:@"UpdateForm"
                                                 withMapping:lo_updateMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:searchRelationship];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[UploadGPSContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:[iresp_class class]];
    [lo_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self fn_RK_ObjectManager:requestDescriptor :responseDescriptor ao_form:ao_form base_url:base_url];
}
- (void) fn_uploaded_warehouse_receive_data:(UploadGPSContract*)ao_form Auth:(AuthContract*)auth base_url:(NSString*)base_url{
    //Auth
    RKObjectMapping *lo_authMapping = [RKObjectMapping requestMapping];
    NSArray *arr_auth=[NSArray arrayWithPropertiesOfObject:auth];
    [lo_authMapping addAttributeMappingsFromArray:arr_auth];
    //upload warehouse data form
    RKObjectMapping *lo_updateMapping = [RKObjectMapping requestMapping];
    NSMutableArray *arr_updateform=[[NSArray arrayWithPropertiesOfObject:[Warehouse_receive_data class]]mutableCopy];
    [lo_updateMapping addAttributeMappingsFromArray:arr_updateform];
    
    RKObjectMapping *lo_reqMapping = [RKObjectMapping requestMapping];
    
    RKRelationshipMapping *searchRelationship = [RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"UpdateForm"
                                                 toKeyPath:@"UpdateForm"
                                                 withMapping:lo_updateMapping];
    
    
    RKRelationshipMapping *authRelationship = [RKRelationshipMapping
                                               relationshipMappingFromKeyPath:@"Auth"
                                               toKeyPath:@"Auth"
                                               withMapping:lo_authMapping];
    
    [lo_reqMapping addPropertyMapping:authRelationship];
    [lo_reqMapping addPropertyMapping:searchRelationship];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:lo_reqMapping
                                                                                   objectClass:[UploadGPSContract class]
                                                                                   rootKeyPath:nil method:RKRequestMethodPOST];
    
    RKObjectMapping* lo_response_mapping = [RKObjectMapping mappingForClass:[iresp_class class]];
    
    RKObjectMapping* lo_tran_response_mapping=[RKObjectMapping mappingForClass:[iresp_class1 class]];
    [lo_tran_response_mapping addAttributeMappingsFromArray:ilist_resp_mapping1];
    
    [lo_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"UploadTran" toKeyPath:@"UploadTran" withMapping:lo_tran_response_mapping]];
  
    RKObjectMapping* lo_cfsdim_resp_mapping=[RKObjectMapping mappingForClass:[Resp_CTexcfsdimResult class]];
    [lo_cfsdim_resp_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[Resp_CTexcfsdimResult class]]];
    
    [lo_tran_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"upload_response" toKeyPath:@"upload_response" withMapping:lo_cfsdim_resp_mapping]];
    /*
    RKObjectMapping* lo_dataRefresh_resp_mapping=[RKObjectMapping mappingForClass:[Resp_DataRefresh class]];
    [lo_tran_response_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"DataRefresh" toKeyPath:@"DataRefresh" withMapping:lo_dataRefresh_resp_mapping]];
    
    RKObjectMapping* lo_exso_resp_mapping=[RKObjectMapping mappingForClass:[Resp_ExsoBrowseResult class]];
    [lo_exso_resp_mapping addAttributeMappingsFromArray:[NSArray arrayWithPropertiesOfObject:[Resp_ExsoBrowseResult class]]];
    [lo_dataRefresh_resp_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"exso" toKeyPath:@"exso" withMapping:lo_exso_resp_mapping]];*/
                                                  
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lo_response_mapping
                                                                                            method:RKRequestMethodPOST
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self fn_RK_ObjectManager:requestDescriptor :responseDescriptor ao_form:ao_form base_url:base_url];
}
-(void)fn_RK_ObjectManager:(RKRequestDescriptor*)requestDescriptor :(RKResponseDescriptor*)responseDescriptor ao_form:(id)ao_form base_url:(NSString*)url{
    NSString* path = il_url;
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:url]];
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    [manager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    [manager postObject:ao_form path:path parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
                    
                    ilist_resp_result = [NSMutableArray arrayWithArray:result.array];
                    if (_callBack) {
                        _callBack(ilist_resp_result);
                    }
                    
                    
                } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    RKLogError(@"Operation failed with error: %@", error);
                    if (_callBack) {
                        _callBack(nil);
                    }
                    [SVProgressHUD dismiss];
                }];
}

@end
