//
//  DBManager.m
//  worldtrans
//
//  Created by itdept on 2/26/14.
//  Copyright (c) 2014 itdept. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"

static DBManager *sharedInstance = nil;
static FMDatabase *database = nil;
static int DB_VERSION = 1;

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }


@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance fn_create_db];
    } else {
        if (![database openWithFlags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FILEPROTECTION_COMPLETE]) {
            database = nil;
        }
    }
    return sharedInstance;
}


-(FMDatabase*) fn_get_db{
    return database;
}
-(NSString*)fn_get_databaseFilePath{
    NSArray *llist_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ls_documentDirectory = [llist_paths objectAtIndex:0];
    NSString *ls_dbPath = [ls_documentDirectory stringByAppendingPathComponent:@"itdept.db"];
    return ls_dbPath;
}

-(BOOL)fn_create_db{
    NSString *ls_dbPath=[self fn_get_databaseFilePath];
    BOOL lb_Success = YES;
    database= [FMDatabase databaseWithPath:ls_dbPath] ;
    if (![database open]) {
        lb_Success = NO;
        NSLog(@"Failed to open/create database");
    } else {
        return  [self fn_create_table];
    }
    return lb_Success;
}


-(BOOL)fn_create_table{
    BOOL lb_Success = YES;
    if (![database open]) {
        lb_Success = NO;
        NSLog(@"Failed to open/create database");
    } else {
       
        NSString *ls_sql_RespAppConfig = @"CREATE TABLE IF NOT EXISTS RespAppConfig( unique_id INTEGER PRIMARY KEY,company_code TEXT NOT NULL DEFAULT '',sys_name TEXT NOT NULL DEFAULT '',env TEXT NOT NULL DEFAULT '',web_addr TEXT,php_addr TEXT NOT NULL DEFAULT '')";
        NSString *ls_sql_loginInfo = @"CREATE TABLE IF NOT EXISTS loginInfo( unique_id INTEGER PRIMARY KEY,user_code TEXT NOT NULL DEFAULT '',password TEXT NOT NULL DEFAULT '',system TEXT NOT NULL DEFAULT '',user_logo TEXT NOT NULL DEFAULT '',lang_code TEXT NOT NULL DEFAULT '')";
        NSString *ls_sql_aejob_browse = @"CREATE TABLE IF NOT EXISTS aejob_browse( unique_id INTEGER PRIMARY KEY,job_no TEXT NOT NULL DEFAULT '',flight_no TEXT NOT NULL DEFAULT '',flight_date TEXT NOT NULL DEFAULT '',dish_port TEXT NOT NULL DEFAULT '',uld_type TEXT NOT NULL DEFAULT '',uld_no TEXT NOT NULL DEFAULT '',pkg TEXT NOT NULL DEFAULT '',kgs TEXT NOT NULL DEFAULT '',cbf TEXT NOT NULL DEFAULT '',no_of_hawb TEXT NOT NULL DEFAULT '',carr_name TEXT NOT NULL DEFAULT '',pallet_id TEXT NOT NULL DEFAULT '')";
        NSString *ls_sql_aejob_dtl_browse= @"CREATE TABLE IF NOT EXISTS aejob_dtl_browse( unique_id INTEGER PRIMARY KEY,pallet_id TEXT NOT NULL DEFAULT '',uld_type TEXT NOT NULL DEFAULT '',uld_no TEXT NOT NULL DEFAULT '',hbl_no TEXT NOT NULL DEFAULT '',cbl_no TEXT NOT NULL DEFAULT '',dest_port TEXT NOT NULL DEFAULT '',pkg TEXT NOT NULL DEFAULT '',kgs TEXT NOT NULL DEFAULT '',cbf TEXT NOT NULL DEFAULT '',mnf_act_weight TEXT NOT NULL DEFAULT '',shpr_name TEXT NOT NULL DEFAULT '',cnee_name TEXT NOT NULL DEFAULT '')";
        NSString *ls_sql_com_sys_code = @"CREATE TABLE IF NOT EXISTS com_sys_code( unique_id INTEGER PRIMARY KEY,sys_code TEXT NOT NULL DEFAULT '')";
        NSString *ls_sql_vehicle_no = @"CREATE TABLE IF NOT EXISTS vehicle_no( unique_id INTEGER PRIMARY KEY,vehicle_no TEXT NOT NULL DEFAULT '')";
        NSString *ls_sql_truck_order= @"CREATE TABLE IF NOT EXISTS truck_order( unique_id INTEGER PRIMARY KEY,user_code TEXT NOT NULL DEFAULT '',password TEXT NOT NULL DEFAULT '',system_name TEXT NOT NULL DEFAULT '',version TEXT NOT NULL DEFAULT '',order_no TEXT NOT NULL DEFAULT '',vehicle_no TEXT NOT NULL DEFAULT '',status TEXT NOT NULL DEFAULT '',is_uploaded TEXT NOT NULL DEFAULT '',result TEXT NOT NULL DEFAULT '',upload_date TEXT NOT NULL DEFAULT '',error_date TEXT NOT NULL DEFAULT '')";
        NSString *ls_sql_truck_order_image= @"CREATE TABLE IF NOT EXISTS truck_order_image( img_unique_id INTEGER PRIMARY KEY,image TEXT NOT NULL DEFAULT'',image_remark TEXT NOT NULL DEFAULT'',image_isUploaded TEXT NOT NULL DEFAULT'',error_reason TEXT NOT NULL DEFAULT'',img_error_date TEXT NOT NULL DEFAULT'',correlation_id INTEGER,FOREIGN KEY (correlation_id) REFERENCES truck_order(unique_id))";
        NSString *ls_sql_location=@"CREATE TABLE IF NOT EXISTS location( id_t INTEGER PRIMARY KEY,car_no TEXT NOT NULL DEFAULT'',longitude TEXT NOT NULL DEFAULT'',latitude TEXT NOT NULL DEFAULT'',log_date TEXT NOT NULL DEFAULT'',is_uploaded TEXT NOT NULL DEFAULT '')";
        NSString *ls_sql_sypara=@"CREATE TABLE IF NOT EXISTS sypara( id INTEGER PRIMARY KEY,unique_id TEXT NOT NULL DEFAULT '',para_code TEXT NOT NULL DEFAULT '',company_code TEXT NOT NULL DEFAULT '',data1 TEXT NOT NULL DEFAULT '',data2 TEXT NOT NULL DEFAULT '',data3 TEXT NOT NULL DEFAULT '',data4 TEXT NOT NULL DEFAULT '',data5 TEXT NOT NULL DEFAULT '',para_desc TEXT NOT NULL DEFAULT '',rec_crt_user TEXT NOT NULL DEFAULT '',rec_upd_user TEXT NOT NULL DEFAULT '',rec_crt_date TEXT NOT NULL DEFAULT '',rec_upd_date TEXT NOT NULL DEFAULT '',db_id TEXT NOT NULL DEFAULT '',is_ct TEXT NOT NULL DEFAULT '',crt_user TEXT NOT NULL DEFAULT '',req_user TEXT NOT NULL DEFAULT '',rmk TEXT NOT NULL DEFAULT '')";
        
        [database executeUpdate:ls_sql_RespAppConfig];
        [database executeUpdate:ls_sql_loginInfo];
        [database executeUpdate:ls_sql_aejob_browse];
        [database executeUpdate:ls_sql_aejob_dtl_browse];
        [database executeUpdate:ls_sql_com_sys_code];
        [database executeUpdate:ls_sql_vehicle_no];
        [database executeUpdate:ls_sql_truck_order];
        [database executeUpdate:ls_sql_truck_order_image];
        [database executeUpdate:ls_sql_location];
        [database executeUpdate:ls_sql_sypara];
        [database close];
        return  lb_Success;
    }
    return lb_Success;
}

- (int) fn_get_version {
    FMResultSet *resultSet = [database executeQuery:@"PRAGMA user_version"];
    int li_version = 0;
    if ([resultSet next]) {
        li_version = [resultSet intForColumnIndex:0];
    }
    return li_version;
}

- (void)fn_set_version:(int)ai_version {
    // FMDB cannot execute this query because FMDB tries to use prepared statements
    sqlite3_exec(database.sqliteHandle, [[NSString stringWithFormat:@"PRAGMA user_version = %d", ai_version] UTF8String], NULL, NULL, NULL);
}

- (BOOL)fn_chk_need_migration {
    return [self fn_get_version] < DB_VERSION;
}

- (void) fn_db_migrate {
    int version = [self fn_get_version];
    if (version >= DB_VERSION)
        return;
    
    NSLog(@"Migrating database schema from version %d to version %d", version, DB_VERSION);
    
    // ...the actual migration code...
    /*if (version < 1) {
        [[self database] executeUpdate:@"CREATE TABLE foo (...)"];
    }*/
    
    [self fn_set_version:DB_VERSION];
    NSLog(@"Database schema version after migration is %d", [self fn_get_version]);
}

@end
