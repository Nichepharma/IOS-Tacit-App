//
//  DBManager.m
//  SQLLight
//
//  Created by Yahia on 2/15/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "DBManager.h"
#import "Header.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;


@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance startCreateDB];
    }
    return sharedInstance;
}


-(void)startCreateDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSLog(@"docsDir %@",docsDir);
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"tacit.db"]];
    bool login ,doc , sync,notif ;
    
    login= [sharedInstance createDB_Login];
    doc= [sharedInstance createDB_Doc];
    sync=  [sharedInstance createDB_Sync];
    notif =[sharedInstance createDB_Notifications];
    if (login) {
        NSLog(@"Login Table Created");
    }
    if (doc) {
        NSLog(@"Doctors Table Created");
        
    }  if (sync) {
        NSLog(@"sync Table Created");
        
    }if (notif) {
        NSLog(@"Notifications Table Created");
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}

-(BOOL)createDB_Login{
    
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt= "create table if not exists login (user_id,user_name text primary key, password text , company text)";
            
            
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return isSuccess;
}

-(BOOL)createDB_Doc{
    
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt= "create table if not exists doctors (docID text primary key, doc_Name text, doc_Spec text)";
            
            
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return isSuccess;
}

-(BOOL)createDB_Sync{
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists sync (time_visit text ,sync_totalTime text , acc_time text, doc_id text, doc_name text, doc_spec text,call_inquiry text,call_objection text,call_remark text,doc_notice text,sample_drop text , app_id text , app_name text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)!= SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return isSuccess;
}





- (BOOL) saveSync :(NSString*)sync_Id
   sync_totalTime :(NSString *)sync_totalTime
          acc_time:(NSString*)acc_time
            doc_id:(NSString*)doc_id
          doc_name:(NSString*)doc_Name
          doc_spec:(NSString*)doc_spec
      call_inquiry:(NSString*)call_inquiry
    call_objection:(NSString*)call_objection
       call_remark:(NSString*)call_remark
        doc_notice:(NSString*)doc_notice
       sample_drop:(NSString *)sample_drop


{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into sync (time_visit , sync_totalTime , acc_time, doc_id, doc_name,doc_spec ,call_inquiry ,call_objection,call_remark,doc_notice ,sample_drop ,app_id , app_name) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")"
                               ,sync_Id,sync_totalTime,acc_time,doc_id,doc_Name,doc_spec,call_inquiry,call_objection,call_remark,doc_notice,sample_drop,[[ApplicationData getSharedInstance] getApplicationID] , [[ApplicationData getSharedInstance] getAppName]
                               ];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
     //   NSLog(@"insert is %@",insertSQL);

        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        }else {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return NO;
        }
        //  sqlite3_reset(statement);
        
    }
    return NO;
}




- (BOOL) saveData:(NSString*)doc_ID
             name:(NSString*)doc_Name
             spec:(NSString*)doc_Spec
{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into doctors (docID,doc_Name, doc_Spec) values (\"%@\",\"%@\", \"%@\")",
                               doc_ID,doc_Name,doc_Spec];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return YES;
        }else {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return NO;
        }
        //   sqlite3_reset(statement);
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return NO;
}


- (BOOL) saveUsername :(NSString*)userName
              password:(NSString*)password
              userID:(NSString*)uid
              company:(NSString*)str_comp
    {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSLog(@">%@ < %@",userName , password);
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO login (user_id, user_name , password , company) VALUES ('%@','%@','%@' , '%@')",
                              uid , userName,password,str_comp];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
    }
    
    BOOL success =((sqlite3_step(statement) == SQLITE_DONE) ?YES : NO);
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    return success;
    
    
}

-(NSString *)getUsername{
    NSString *str_username ;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from login"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                str_username = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
            }
            else{
                NSLog(@"Not found");
                sqlite3_finalize(statement);
                sqlite3_close(database);
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    
  
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return str_username ;
    
}


-(NSString *)getUserId{
    NSString *str_userId;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from login"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                str_userId = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,0)];
                
            }
            else{
                NSLog(@"Not found");
                sqlite3_finalize(statement);
                sqlite3_close(database);
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    
 
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return str_userId ;
    
}



-(NSString *)getUserCompany{
    NSString *str_Company ;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select company from login"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                str_Company = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
            }
            else{
                NSLog(@"Not found");
                sqlite3_finalize(statement);
                sqlite3_close(database);
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return str_Company ;
    
}








- (NSMutableDictionary*) getAllDoctors   {
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from doctors ORDER BY doc_Name ASC"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *result_docName = [[NSMutableArray alloc]init];
        NSMutableArray *result_docId = [[NSMutableArray alloc]init];
        NSMutableArray *result_docSpec = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //                        NSString *doc_id = [[NSString alloc] initWithUTF8String:
                //                                          (const char *) sqlite3_column_text(statement, 0)];
                //
                //                        [resultArray addObject:doc_id];
                //
                //                        NSString *doc_Name = [[NSString alloc] initWithUTF8String:
                //                                                (const char *) sqlite3_column_text(statement, 1)];
                //                        [resultArray addObject:doc_Name];
                //
                //                        NSString *doc_Spec = [[NSString alloc]initWithUTF8String:
                //                                          (const char *) sqlite3_column_text(statement, 2)];
                //
                //                        [resultArray addObject:doc_Spec];
                //
                
                
                NSString *doc_ID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *doc_Name = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 1)];
                
                
                NSString *doc_Spec = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                [result_docId addObject:doc_ID];
                [result_docName addObject:doc_Name];
                [result_docSpec addObject:doc_Spec];
                
            }
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        NSMutableDictionary *getAllDoctors =[[NSMutableDictionary alloc] init];
        [getAllDoctors setValue:result_docId forKey:@"did"];
        [getAllDoctors setValue:result_docName forKey:@"name"];
        [getAllDoctors setValue:result_docSpec forKey:@"spec"];
        
        
        
        return getAllDoctors;
        
        
    }
    
    return nil;
}




















- (NSMutableDictionary*) getAllSyncSessionByAppID :(NSString *)str_appID {
    
    
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
//        NSLog(@"applicationID = %@" , [[ApplicationData getSharedInstance] getApplicationID] );
        NSString *querySQL ;
        if(![str_appID isEqualToString:@""] )
            querySQL = [NSString stringWithFormat:@"select * from sync  WHERE app_id = %@ ORDER BY sync.time_visit desc ",[[ApplicationData getSharedInstance] getApplicationID] ];
        else
            querySQL = [NSString stringWithFormat:@"select * from sync  ORDER BY sync.time_visit desc"];
        const char *query_stmt = [querySQL UTF8String];
        
        
        NSMutableArray *result_docName = [[NSMutableArray alloc]init];
        NSMutableArray *result_docId = [[NSMutableArray alloc]init];
        NSMutableArray *result_docSpec = [[NSMutableArray alloc]init];
        NSMutableArray *result_sync_Id= [[NSMutableArray alloc]init];
        NSMutableArray * result_sync_totalTime= [[NSMutableArray alloc]init];
        NSMutableArray *result_acc_time= [[NSMutableArray alloc]init];
        NSMutableArray *result_call_inquiry= [[NSMutableArray alloc]init];
        NSMutableArray *result_call_objection= [[NSMutableArray alloc]init];
        NSMutableArray *result_call_remark= [[NSMutableArray alloc]init];
        NSMutableArray *result_doc_notice= [[NSMutableArray alloc]init];
        NSMutableArray *result_sample_drop= [[NSMutableArray alloc]init];
        NSMutableArray *result_app_id= [[NSMutableArray alloc]init];
        NSMutableArray *result_app_name = [[NSMutableArray alloc]init];

        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                //   NSLog(@"%@",[self sqlite3StmtToString:statement]);
                //  sync_Id,sync_totalTime,acc_time,doc_id,doc_Name,doc_spec,call_inquiry,call_objection,call_remark,doc_notice,sample_drop
                NSString *sync_Id = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
                
                NSString *sync_totalTime = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 1)];
                
                
                NSString *acc_time = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                NSString *doc_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 3)];
                
                NSString *doc_Name = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 4)];
                
                NSString *doc_Spec = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 5)];
                
                NSString *call_inquiry = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 6)];
                
                NSString *call_objection = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 7)];
                
                NSString *call_remark = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 8)];
                
                NSString *doc_notice = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 9)];
                
                NSString *sample_drop = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 10)];
                NSString *app_id      = [[NSString alloc] initWithUTF8String:
                                                    (const char *) sqlite3_column_text(statement, 11)];
                NSString *app_name      = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 12)];

                [result_sync_Id addObject:sync_Id];
                [result_sync_totalTime addObject:sync_totalTime];
                [result_acc_time addObject:acc_time];
                [result_docId addObject:doc_id];
                [result_docName addObject:doc_Name];
                [result_docSpec addObject:doc_Spec];
                [result_call_inquiry addObject:call_inquiry];
                [result_call_objection addObject:call_objection];
                [result_call_remark addObject:call_remark];
                [result_doc_notice addObject:doc_notice];
                [result_sample_drop addObject:sample_drop];
                [result_app_id addObject:app_id];
                [result_app_name addObject:app_name];
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            
            NSMutableDictionary *getAllSync =[[NSMutableDictionary alloc] init];
            [getAllSync setValue:result_sync_Id forKey:@"sync_id"];
            [getAllSync setValue:result_sync_totalTime forKey:@"total_time"];
            [getAllSync setValue:result_acc_time forKey:@"acc_time"];
            
            [getAllSync setValue:result_docId forKey:@"did"];
            [getAllSync setValue:result_docName forKey:@"name"];
            [getAllSync setValue:result_docSpec forKey:@"spec"];
            
            [getAllSync setValue:result_call_inquiry forKey:@"call_inquiry"];
            [getAllSync setValue:result_call_objection forKey:@"call_objection"];
            [getAllSync setValue:result_call_remark forKey:@"call_remark"];
            [getAllSync setValue:result_doc_notice forKey:@"doc_notice"];
            [getAllSync setValue:result_sample_drop forKey:@"sample_drop"];
            [getAllSync setValue:result_app_id forKey:@"app_id"];
            [getAllSync setValue:result_app_name forKey:@"app_name"];
            
            return getAllSync;
            
            
        }
    }
    return nil;
}

- (NSMutableArray*) getOneSyncSesstion :(NSString *)_SyncID {
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
//  NSString *querySQL = [NSString stringWithFormat:@"select acc_time,time_visit,sync_totalTime,doc_id,doc_notice,sample_drop,call_remark,call_inquiry,call_objection, doc_name,doc_spec from sync where time_visit ='%@' and app_id = %@",_SyncID,[[ApplicationData getSharedInstance] getApplicationID]];

        NSString *querySQL = [NSString stringWithFormat:@"select acc_time,time_visit,sync_totalTime,doc_id,doc_notice,sample_drop,call_remark,call_inquiry,call_objection, doc_name,doc_spec from sync where time_visit ='%@'",_SyncID];
        const char *query_stmt = [querySQL UTF8String];

        NSMutableArray *result_Sesstion = [[NSMutableArray alloc]init];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
        
            
                NSString *acc_time = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 0)];
                [result_Sesstion addObject:acc_time];
         
                NSString *sync_Id = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 1)];
                [result_Sesstion addObject:sync_Id];
                
                NSString *sync_totalTime = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 2)];
                 [result_Sesstion addObject:sync_totalTime];
                
                NSString *doc_id = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 3)];
                 [result_Sesstion addObject:doc_id];
                
                NSString *doc_notice = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 4)];
                [result_Sesstion addObject:doc_notice];
                
                NSString *sample_drop = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 5)];
                [result_Sesstion addObject:sample_drop];
                
                NSString *call_remark = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement, 6)];
                [result_Sesstion addObject:call_remark];
                
                
                NSString *call_inquiry = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 7)];
                 [result_Sesstion addObject:call_inquiry];
                
                NSString *call_objection = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 8)];
                 [result_Sesstion addObject:call_objection];
            
            
                NSString *doc_Name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                [result_Sesstion addObject:doc_Name];
                
                NSString *doc_Spec = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                [result_Sesstion addObject:doc_Spec];
    
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
          

            
            
            
            return result_Sesstion;
            
            
        }
    }
    return nil;
}

-(NSMutableArray *)getDetailsSesttionData :(NSString *)_dSyncID {
    //not use now
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        // NSString *querySQL = [NSString stringWithFormat:@"select doc_name,doc_spec,sync_totalTime from sync where time_visit ='%@' and app_id = '%@' ",_dSyncID , [[ApplicationData getSharedInstance] getApplicationID] ];

        NSString *querySQL = [NSString stringWithFormat:@"select doc_name,doc_spec,sync_totalTime from sync where time_visit ='%@' ",_dSyncID ];
        const char *query_stmt = [querySQL UTF8String];
        
        NSMutableArray *result_Sesstion = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //while (sqlite3_step(statement) == SQLITE_ROW) {
   
            NSString *doc_Name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            [result_Sesstion addObject:doc_Name];
                
            NSString *doc_Spec = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                [result_Sesstion addObject:doc_Spec];
                
            NSString *doc_due= [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            [result_Sesstion addObject:doc_due];
            
          //  }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            

            return result_Sesstion;
            
            
        }
    }
    return nil;
}

-(BOOL)chekLogin{
    int count = 0;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select count(user_name) from login"];
        const char *query_stmt = [querySQL UTF8String];
        
        
        if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    
    
    if (count==0)  return false ;   else return true;
    
}
//if want to be print result
-(NSMutableString*) sqlite3StmtToString:(sqlite3_stmt*) statement {
    NSMutableString *s = [NSMutableString new];
    [s appendString:@"{\"statement\":["];
    for (int c = 0; c < sqlite3_column_count(statement); c++){
        [s appendFormat:@"{\"column\":\"%@\",\"value\":\"%@\"}",[NSString stringWithUTF8String:(char*)sqlite3_column_name(statement, c)],[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, c)]];
        if (c < sqlite3_column_count(statement) - 1)
            [s appendString:@","];
    }
    [s appendString:@"]}"];
    return s;

}

-(void)deleteDB:(NSString *)str_tableName{
    //if str equal d >> doctor table
    // if str equal l >> login table
    // if str equal s >> sync table
    // if str equal all >> drop all table
    
    
    
    NSString  *querySQL = [NSString stringWithFormat:@""];
    
    if ([str_tableName isEqualToString:@"d"]) {
        querySQL=@"delete from doctors";
    }else if ([str_tableName isEqualToString:@"l"]) {
        querySQL=@"delete from login";
    }else if ([str_tableName isEqualToString:@"s"]) {
        querySQL=@" delete from sync";
    }else if ([str_tableName isEqualToString:@"all"]) {
        for (int i =0; i<3; i++) {
            switch (i) {
                case 0:
                    NSLog(@"%hhd",[self deleteFromTable:@"delete from doctors"]);
                    break;
                case 1:
                    NSLog(@"%hhd",[self deleteFromTable:@"delete from sync"]);
                    break;
                case 2:
                    NSLog(@"%hhd",[self deleteFromTable:@"delete from login"]);
                    break;
            }
        }
    }
    
    
    
}

-(BOOL)deleteFromTable :(NSString *)query{
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *insert_stmt = [query UTF8String];
        sqlite3_prepare_v2(database,insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE) NSLog(@"Delete successfully");
        else NSLog(@"Delete not successfully");
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return true ;
    }else
        return false ;
}

-(BOOL)updateSyncData :(NSMutableArray *)_DataVisit{
    
    sqlite3_stmt    *statement;
    NSString  *querySQL = [NSString stringWithFormat:@""];
    querySQL=[[NSString alloc] initWithFormat:@"update sync set sample_drop ='%@' ,call_remark='%@',call_objection='%@' where time_visit='%@'",
                            [_DataVisit objectAtIndex:0],[_DataVisit objectAtIndex:1],[_DataVisit objectAtIndex:2],[_DataVisit objectAtIndex:3]];
  //  NSLog(@"Query %@",querySQL);
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *insert_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(database,insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE) NSLog(@"update successfully");
        else NSLog(@"update not successfully");
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return true ;
    }else
        return false ;
}

-(BOOL)deleteSyncData:(NSString *)_visitsDate {
    
    NSString *str_QuerySQL=[[NSString alloc] initWithFormat:@"DELETE FROM sync WHERE time_visit='%@'",_visitsDate];
    
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *insert_stmt = [str_QuerySQL UTF8String];
        sqlite3_prepare_v2(database,insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE) NSLog(@"Delete successfully");
        else NSLog(@"Delete not successfully");
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return true ;
    }else
        return false ;

}

-(BOOL)update_e_SyncData:(NSMutableDictionary *)e_visitsDate {
    
    
    sqlite3_stmt    *statement;
    NSString  *querySQL = [NSString stringWithFormat:@""];
   
    querySQL=[[NSString alloc] initWithFormat:@"update sync set doc_id ='%@' ,doc_name='%@',doc_spec='%@' where time_visit='%@'",
              [e_visitsDate objectForKey:@"did"],[e_visitsDate objectForKey:@"dname"],[e_visitsDate objectForKey:@"dspec"],[e_visitsDate objectForKey:@"visit"]];
    NSLog(@"querySQl %@",querySQL);
    NSLog(@"Query %@",querySQL);
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *insert_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(database,insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE) NSLog(@"update successfully");
        else NSLog(@"update not successfully");
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return true ;
    }else
        return false ;
    
}


//---------Notifications ----------------//
#pragma Notofications API


-(BOOL)createDB_Notifications{
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists noti (noti_id INTEGER PRIMARY KEY   AUTOINCREMENT  , noti_string text ,noti_sender text , noti_date text )";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)!= SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return isSuccess;
}


-(BOOL)insertNotificationWithStringMessage:(NSString*)str_msg
                    sender:(NSString*)sender
               noti_Daye:(NSString *)str_noti_Date

{
       // NSLog(@">> %@ <<<<  %@",str_msg,sender);
   // if (![message_id isEqualToString:@"(null)"] ||! [str_msg isEqualToString:@"(null)"]||![sender isEqualToString:@"(null)"]) {
    

    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
          //
        NSString *insertSQL = [NSString stringWithFormat:@"insert into noti ( noti_string , noti_sender , noti_date ) values (\"%@\",\"%@\",\"%@\")" ,
                               str_msg,sender ,str_noti_Date];
        
       
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
      
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_finalize(statement);
            sqlite3_close(database);
             NSLog(@"SQL  is %@",insertSQL);
            return YES;
        }else {
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return NO;
        }
        //  sqlite3_reset(statement);
        
   // }
   }
    return NO;

}
-(BOOL)deleteNotif {
    
    NSString *str_QuerySQL=[[NSString alloc] initWithFormat:@"DELETE FROM noti "];
    
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *insert_stmt = [str_QuerySQL UTF8String];
        sqlite3_prepare_v2(database,insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE) NSLog(@"Delete successfully");
        else NSLog(@"Delete not successfully");
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return true ;
    }else
        return false ;
    
}

- (NSMutableDictionary*) getNotifications   {
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select * from noti  ORDER BY noti_id DESC"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *result_notiID = [[NSMutableArray alloc]init];
        NSMutableArray *result_notiString = [[NSMutableArray alloc]init];
       NSMutableArray *result_notiSender= [[NSMutableArray alloc]init];
        NSMutableArray *result_notiDate = [[NSMutableArray alloc]init];
        
        
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                
                NSString *noti_ID = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];
             
                
                NSString *noti_Name = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *noti_Sender = [[NSString alloc] initWithUTF8String:
                                       (const char *) sqlite3_column_text(statement,2)];
                NSString *noti_Date = [[NSString alloc] initWithUTF8String:
                                         (const char *) sqlite3_column_text(statement,3)];
                [result_notiID addObject:noti_ID];
                [result_notiString addObject:noti_Name];
                [result_notiSender addObject:noti_Sender];
                [result_notiDate addObject:noti_Date];
            }    sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        
        NSMutableDictionary *getNotifications =[[NSMutableDictionary alloc] init];
        [getNotifications setValue:result_notiID forKey:@"noti_id"];
        [getNotifications setValue:result_notiString forKey:@"noti_string"];
        [getNotifications setValue:result_notiSender forKey:@"noti_sender"];
        [getNotifications setValue:result_notiDate forKey:@"noti_date"];
        
        return getNotifications;
        
        
    }
    
    return nil;
}




@end