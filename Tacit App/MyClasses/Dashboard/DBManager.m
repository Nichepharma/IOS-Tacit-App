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
        [sharedInstance openDB];
    }
    return sharedInstance;
}


- (BOOL) saveSync :(NSString*)sync_Id
   sync_totalTime :(NSString *)sync_totalTime
          acc_time:(NSString*)acc_time
            doc_id:(NSString*)doc_id
           doc_cid:(NSString *)cid
          doc_name:(NSString*)doc_Name
          doc_spec:(NSString*)doc_spec
      call_inquiry:(NSString*)call_inquiry
    call_objection:(NSString*)call_objection
       call_remark:(NSString*)call_remark
        doc_notice:(NSString*)doc_notice
       sample_drop:(NSString *)sample_drop
        visitType : (NSString *)visitType

{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"insert into sync (time_visit , sync_totalTime , acc_time, doc_id, doc_name,doc_spec ,call_inquiry ,call_objection,call_remark,doc_notice ,sample_drop ,app_id , app_name , visitType , doc_CID) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\" , \"%@\", \"%@\")",
                                    sync_Id ,
                                    sync_totalTime ,
                                    acc_time ,
                                    doc_id ,
                                    doc_Name,
                                    doc_spec,
                                    call_inquiry,
                                    call_objection,
                                    call_remark,
                                    doc_notice,
                                    sample_drop,
                                    [[ApplicationData getSharedInstance] getApplicationID] ,
                                    [[ApplicationData getSharedInstance] getAppName] ,
                                    visitType ,
                                    cid
                                    ];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
//       NSLog(@"insert is %@",   [[ApplicationData getSharedInstance] getApplicationID]);

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


-(BOOL)saveDoctors:(NSDictionary*)doctorsInfo ;

{
    NSString *_SQL_DATA = @"" ;
    for (NSDictionary *doc in doctorsInfo) {
        NSString *docType = @"0";
        if ( [doc objectForKey:@"type"] ) {
            docType =   [doc objectForKey:@"type"] ;

        }
        _SQL_DATA = [NSString stringWithFormat:@"%@('%@','%@','%@','%@','%@','%@')," , _SQL_DATA ,
                     [doc objectForKey:@"cid"]  ,
                     [doc objectForKey:@"did"]   ,
                     [[[doc objectForKey:@"FullName"] stringByReplacingOccurrencesOfString:@"'" withString:@"`"] capitalizedString],
                     [doc objectForKey:@"speciality"] ,
                     [doc objectForKey:@"area"] ,
                     docType
                     ] ;
    }

    
    _SQL_DATA  = [_SQL_DATA substringToIndex:[_SQL_DATA length] - 1];
    NSString *insertSQL   = [NSString stringWithFormat:@"INSERT INTO doctors (doc_CID , docID, doc_name , doc_spec , doc_loc, doc_type) VALUES %@ ", _SQL_DATA ];
//    NSLog(@"insertSQL %@ ",insertSQL);
    return [self iudStatementWithSQL_String: insertSQL ];
}


#pragma save Hospitals List
- (BOOL) saveHospitals:(NSDictionary*)hospitalsInfo {

    NSString *_SQL_DATA = @"" ;
    
    for (NSDictionary *hospital in hospitalsInfo) {
        NSString *hospital_name = [[[hospital objectForKey:@"FullName"] stringByReplacingOccurrencesOfString:@"'" withString:@"`"] stringByReplacingOccurrencesOfString:@"\"" withString:@"`"] ;
        
        NSString *hospital_area = [[[hospital objectForKey:@"area"] stringByReplacingOccurrencesOfString:@"'" withString:@"`"] stringByReplacingOccurrencesOfString:@"\"" withString:@"`"] ;
        
        _SQL_DATA = [NSString stringWithFormat:@"%@(\"%@\",\"%@\",\"%@\")," , _SQL_DATA ,
                     [hospital objectForKey:@"cid"]  ,
                     [hospital_name capitalizedString],
                     [hospital_area capitalizedString]
                     ];
        [[DBManager getSharedInstance] saveDoctors:[hospital objectForKey:@"doctors"]];
    }
    
    _SQL_DATA  = [_SQL_DATA substringToIndex:[_SQL_DATA length] - 1];
    NSString *insertSQL   = [NSString stringWithFormat:@"INSERT INTO hospitals (hospital_ID, hospital_Name , hospital_Area) VALUES %@ ", _SQL_DATA ];
//    NSLog(@"insertSQL %@ ",insertSQL);
    return [self iudStatementWithSQL_String: insertSQL ];
}

#pragma save Pharmacies List
- (BOOL) savePharmacies:(NSDictionary *)pharmciesInfo {
    NSString *_SQL_DATA = @"" ;
    for (NSDictionary *doc in pharmciesInfo) {
        NSString *cid = @"" ;
        if ( [doc objectForKey:@"cid"] ) {
            cid =   [doc objectForKey:@"cid"] ;
        }
        _SQL_DATA = [NSString stringWithFormat:@"%@(\"%@\",\"%@\",\"%@\", \"%@\")," , _SQL_DATA , 
                     cid  ,
                     [doc objectForKey:@"pharmID"]  ,
                     [[[doc objectForKey:@"pharmName"] stringByReplacingOccurrencesOfString:@"'" withString:@"`"] capitalizedString],
                     [doc objectForKey:@"pharmArea"]
                     ] ;
    }
    
    _SQL_DATA  = [_SQL_DATA substringToIndex:[_SQL_DATA length] - 1];
    NSString *insertSQL   = [NSString stringWithFormat:@"INSERT INTO Pharmacies (pharmacy_CID , pharmacy_ID, pharmacy_Name , pharmacy_Area) VALUES %@ ", _SQL_DATA ];
//    NSLog(@"insertSQL %@ ",insertSQL);
    return [self iudStatementWithSQL_String: insertSQL ];
}

//================# Get Doctors , Hospital and Pharmacies Data From DataBase #================//

#pragma get Doctors
- (NSMutableDictionary*) getAllDoctors   {
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select doc_CID, docID ,doc_Name, doc_Spec,doc_type, doc_Loc from doctors ORDER BY doc_Name ASC"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *result_doc_Cid = [[NSMutableArray alloc]init];
        NSMutableArray *result_docId = [[NSMutableArray alloc]init];
        NSMutableArray *result_docName = [[NSMutableArray alloc]init];
        NSMutableArray *result_docSpec = [[NSMutableArray alloc]init];
        NSMutableArray *result_doc_Loc = [[NSMutableArray alloc]init];

        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {

                NSString *doc_CID = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];

                NSString *doc_ID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];
                
                NSString *doc_Name = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];
                
                
                NSString *doc_Spec = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 3)];

                NSString *doc_Loc = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 4)];

                [result_doc_Cid addObject:doc_CID];
                [result_docId addObject:doc_ID];
                [result_docName addObject:doc_Name];
                [result_docSpec addObject:doc_Spec];
                [result_doc_Loc addObject:doc_Loc];


            }
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        NSMutableDictionary *getAllDoctors =[[NSMutableDictionary alloc] init];
        [getAllDoctors setValue:result_doc_Cid forKey:@"cid"];
        [getAllDoctors setValue:result_docId forKey:@"did"];
        [getAllDoctors setValue:result_docName forKey:@"name"];
        [getAllDoctors setValue:result_docSpec forKey:@"spec"];
        [getAllDoctors setValue:result_doc_Loc forKey:@"loc"];
        
        
//        NSLog(@"create table if not exists doctors  %@ " , querySQL );
        return getAllDoctors;
        
        
    }
    
    return nil;
}

#pragma get Doctors When Company is Chiesi
- (NSMutableDictionary*) getAllDoctors :(NSString *)type :(NSString *)hospital_id {

    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL ;
        if ([type isEqualToString:@"0"]) {
            querySQL= [NSString stringWithFormat:@"select docID,doc_cid,doc_name,doc_spec,doc_Loc from doctors where doc_type='%@' ORDER BY doc_Name  ASC",type];

        }else if([type isEqualToString:@"2"]){
            querySQL= [NSString stringWithFormat:@"select docID,doc_cid,doc_name,doc_spec,doc_Loc from doctors where doc_type='%@' and doc_cid='%@' ORDER BY doc_Name ASC ",type,hospital_id];
        }

//      NSLog(@"%@ >>> ",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *result_doc_Cid = [[NSMutableArray alloc]init];
        NSMutableArray *result_docId = [[NSMutableArray alloc]init];
        NSMutableArray *result_docName = [[NSMutableArray alloc]init];
        NSMutableArray *result_docSpec = [[NSMutableArray alloc]init];
        NSMutableArray *result_doc_Loc = [[NSMutableArray alloc]init];

        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {

                NSString *doc_CID = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 0)];


                NSString *doc_ID = [[NSString alloc] initWithUTF8String:
                                    (const char *) sqlite3_column_text(statement, 1)];

                NSString *doc_Name = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 2)];


                NSString *doc_Spec = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 3)];

                NSString *doc_Loc = [[NSString alloc] initWithUTF8String:
                                     (const char *) sqlite3_column_text(statement, 4)];

                [result_doc_Cid addObject:doc_CID];
                [result_docId addObject:doc_ID];
                [result_docName addObject:doc_Name];
                [result_docSpec addObject:doc_Spec];
                [result_doc_Loc addObject:doc_Loc];
            }
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        NSMutableDictionary *getAllDoctors =[[NSMutableDictionary alloc] init];
        [getAllDoctors setValue:result_doc_Cid forKey:@"cid"];
        [getAllDoctors setValue:result_docId forKey:@"did"];
        [getAllDoctors setValue:result_docName forKey:@"name"];
        [getAllDoctors setValue:result_docSpec forKey:@"spec"];
        [getAllDoctors setValue:result_doc_Loc forKey:@"loc"];

//        NSLog(@"getAllDoctors %@ " , getAllDoctors);

        return getAllDoctors;


    }

    return nil;
}







#pragma get Hospitals
- (NSMutableDictionary*) getAllHospitals   {

    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT hospital_ID , hospital_Name , hospital_Area FROM hospitals ORDER BY hospital_Name ASC"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *result_hospName = [[NSMutableArray alloc]init];
        NSMutableArray *result_hospId = [[NSMutableArray alloc]init];
        NSMutableArray *result_hospArea = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *hosp_ID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];

                NSString *hosp_Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];

                NSString *hosp_Spec = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];

                [result_hospId addObject:hosp_ID];
                [result_hospName addObject:hosp_Name];
                [result_hospArea addObject:hosp_Spec];

            }
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        NSMutableDictionary *getAllHospitals =[[NSMutableDictionary alloc] init];
        [getAllHospitals setValue:result_hospId forKey:@"did"];
        [getAllHospitals setValue:result_hospName forKey:@"name"];
        [getAllHospitals setValue:result_hospArea forKey:@"spec_or_loc"];

        return getAllHospitals;


    }

    return nil;
}

#pragma get Pharmacies
- (NSMutableDictionary*) getAllPharmacies   {

    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select pharmacy_CID ,pharmacy_ID, pharmacy_Name , pharmacy_Area from Pharmacies ORDER BY pharmacy_Name ASC"];
        const char *query_stmt = [querySQL UTF8String];

        NSMutableArray *result_pharmCID = [[NSMutableArray alloc]init];
        NSMutableArray *result_pharmId = [[NSMutableArray alloc]init];
        NSMutableArray *result_pharmName = [[NSMutableArray alloc]init];
        NSMutableArray *result_pharmArea = [[NSMutableArray alloc]init];


        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *pharm_CID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement,0)];
                NSString *pharm_ID = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *pharm_Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *pharm_Spec = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                [result_pharmCID addObject:pharm_CID];
                [result_pharmName addObject:pharm_Name];
                [result_pharmId addObject:pharm_ID];
                [result_pharmArea addObject:pharm_Spec];

            }
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        NSMutableDictionary *getAllHospitals =[[NSMutableDictionary alloc] init];

        [getAllHospitals setValue:result_pharmCID forKey:@"cid"];
        [getAllHospitals setValue:result_pharmId forKey:@"did"];
        [getAllHospitals setValue:result_pharmName forKey:@"name"];
        [getAllHospitals setValue:result_pharmArea forKey:@"spec_or_loc"];



        return getAllHospitals;


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
            querySQL = [NSString stringWithFormat:@"select time_visit , sync_totalTime , acc_time , doc_id, doc_name, doc_spec, call_inquiry ,call_objection , call_remark , doc_notice , sample_drop , sample_type, app_id , app_name ,  visitType , doc_CID  from sync  ORDER BY sync.time_visit desc"];
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
        NSMutableArray *result_sample_type = [[NSMutableArray alloc]init];
        NSMutableArray *result_app_id= [[NSMutableArray alloc]init];
        NSMutableArray *result_app_name = [[NSMutableArray alloc]init];
        NSMutableArray *result_vistiType = [[NSMutableArray alloc]init];
        NSMutableArray *result_cid = [[NSMutableArray alloc]init];

        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                //   NSLog(@"%@",[self sqlite3StmtToString:statement]);
                //  sync_Id,sync_totalTime,acc_time,doc_id,doc_Name,doc_spec,call_inquiry,call_objection,call_remark,doc_notice,sample_drop
                NSString *sync_Id = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 0)];
                NSString *sync_totalTime = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 1)];
                NSString *acc_time = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 2)];
                NSString *doc_id   = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 3)];
                NSString *doc_Name = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 4)];
                NSString *doc_Spec = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 5)];
                NSString *call_inquiry = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 6)];
                NSString *call_objection = [ [NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 7)];
                NSString *call_remark = [ [NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 8) ];
                NSString *doc_notice  = [ [NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 9) ];
                NSString *sample_drop = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                NSString *sample_type  = @"";
                if (sqlite3_column_text(statement, 11)) {
                    sample_type = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                }
                NSString *app_id   = [ [NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 12)];
                NSString *app_name = [ [NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 13) ];
                NSString*vistiType = [ [NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 14) ];
                NSString *doc_cid  = [ [NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, 15) ];

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
                [result_sample_type addObject:sample_type];
                [result_app_id addObject:app_id];
                [result_app_name addObject:app_name];
                [result_vistiType addObject:vistiType];
                [result_cid addObject:doc_cid];

            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            
            NSMutableDictionary *getAllSync =[[NSMutableDictionary alloc] init];
            [getAllSync setValue:result_sync_Id forKey:@"sync_id"];
            [getAllSync setValue:result_sync_totalTime forKey:@"total_time"];
            [getAllSync setValue:result_acc_time forKey:@"acc_time"];
            
            [getAllSync setValue:result_docId forKey:@"did"];
            [getAllSync setValue:result_cid forKey:@"cid"];

            [getAllSync setValue:result_docName forKey:@"name"];
            [getAllSync setValue:result_docSpec forKey:@"spec"];
            
            [getAllSync setValue:result_call_inquiry forKey:@"call_inquiry"];
            [getAllSync setValue:result_call_objection forKey:@"call_objection"];
            [getAllSync setValue:result_call_remark forKey:@"call_remark"];
            [getAllSync setValue:result_doc_notice forKey:@"doc_notice"];
            [getAllSync setValue:result_sample_drop forKey:@"sample_drop"];
            [getAllSync setValue:result_sample_type forKey:@"sample_type"];

            
            [getAllSync setValue:result_app_id forKey:@"app_id"];
            [getAllSync setValue:result_app_name forKey:@"app_name"];
            [getAllSync setValue:result_vistiType forKey:@"vistiType"];
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

        NSString *querySQL = [NSString stringWithFormat:
                              @"select acc_time,time_visit,sync_totalTime,doc_id,doc_notice,sample_drop,call_remark,call_inquiry,call_objection, doc_name,doc_spec , doc_CID  , app_id  , visitType ,app_name from sync where time_visit ='%@'",_SyncID];
        const char *query_stmt = [querySQL UTF8String];

        NSMutableArray *result_Sesstion = [[NSMutableArray alloc]init];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
        
            
            NSString *acc_time = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            [result_Sesstion addObject:acc_time];
         
            NSString *sync_Id = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            [result_Sesstion addObject:sync_Id];
                
            NSString *sync_totalTime = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            [result_Sesstion addObject:sync_totalTime];
                
            NSString *doc_id = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
            [result_Sesstion addObject:doc_id];
                
            NSString *doc_notice = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
            [result_Sesstion addObject:doc_notice];
                
            NSString *sample_drop = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
            [result_Sesstion addObject:sample_drop];
                
            NSString *call_remark = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
            [result_Sesstion addObject:call_remark];
                
                
            NSString *call_inquiry = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
            [result_Sesstion addObject:call_inquiry];
                
            NSString *call_objection = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
            [result_Sesstion addObject:call_objection];
            
            NSString *doc_Name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
            [result_Sesstion addObject:doc_Name];
                
            NSString *doc_Spec = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
            [result_Sesstion addObject:doc_Spec];

            NSString *doc_cid = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
            [result_Sesstion addObject:doc_cid];

            NSString *appID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
            [result_Sesstion addObject:appID];

            NSString *visit_type = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
            [result_Sesstion addObject:visit_type];

            NSString *app_name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
            [result_Sesstion addObject:app_name];
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

-(BOOL)deleteAllDB{
     [self iudStatementWithSQL_String:@"DELETE FROM  doctors ; commit ; "];
     [self iudStatementWithSQL_String:@"DELETE FROM  hospitals ; commit ;"];
     [self iudStatementWithSQL_String:@"DELETE FROM  Pharmacies ; commit ;"];
     [self iudStatementWithSQL_String:@"DELETE FROM sync ; commit ;"  ];
     [self iudStatementWithSQL_String:@"DELETE FROM  noti ; commit ;"];
 
    return true;
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
    querySQL=[[NSString alloc] initWithFormat:@"update sync set sample_drop ='%@' ,sample_type ='%@' ,call_remark='%@',call_objection='%@' where time_visit='%@'",
                            [_DataVisit objectAtIndex:0],
                            [_DataVisit objectAtIndex:1],
                            [_DataVisit objectAtIndex:2],
                            [_DataVisit objectAtIndex:3],
                            [_DataVisit objectAtIndex:4]
              ];
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
    
   // NSLog(@"e_visitsDate %@ ", e_visitsDate);
    sqlite3_stmt    *statement;
    NSString  *querySQL = [NSString stringWithFormat:@""];
   
    querySQL=[[NSString alloc] initWithFormat:@"update sync set doc_CID = '%@' , doc_id ='%@' ,doc_name='%@',doc_spec='%@' , visitType = '%@' where time_visit='%@'",
                                                [e_visitsDate objectForKey:@"dcid"],
                                                [e_visitsDate objectForKey:@"did"],
                                                [e_visitsDate objectForKey:@"dname"],
                                                [e_visitsDate objectForKey:@"dspec"],
                                                [e_visitsDate objectForKey:@"visitType"],
                                                [e_visitsDate objectForKey:@"visit"]
                                            ];
//    NSLog(@"querySQl %@",querySQL);
//    NSLog(@"Query %@",querySQL);
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *insert_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(database,insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement)==SQLITE_DONE) NSLog(@"update successfully");
        else NSLog(@"Update not successfully");
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return true ;
    }else
        return false ;
    
}


//---------Notifications ----------------//
#pragma Notofications API


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
//             NSLog(@"SQL  is %@",insertSQL);
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



//================================================# SQL API FUNCTIONS #================================================//


#pragma mark -Start to Create Tables
//-----------------------------------#Create Tables#-----------------------------------//
-(void)openDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSLog(@"Dir %@",docsDir);
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"tacitApp.db"]];
    bool tableCreated  ;
    tableCreated = [sharedInstance createDB];
    
    if (!tableCreated) {
        NSLog(@"Tables not created");
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}


#pragma  -mark Create Login Table
-(BOOL)createDB{
    
    BOOL isSuccess = YES ;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists doctors (id INTEGER PRIMARY KEY  autoincrement , docID TEXT , doc_Name TEXT, doc_Spec TEXT, doc_type TEXT ,doc_Loc text, doc_CID TEXT) ;"
            "create table if not exists hospitals (id INTEGER PRIMARY KEY  autoincrement , hospital_ID TEXT, hospital_Name TEXT, hospital_Area text) ;"
            
            "create table if not exists Pharmacies (id INTEGER PRIMARY KEY  autoincrement , pharmacy_CID text ,pharmacy_ID TEXT  , pharmacy_Name TEXT, pharmacy_Area TEXT) ;"
            "create table if not exists sync (time_visit TEXT ,sync_totalTime TEXT , acc_time TEXT, doc_id TEXT, doc_CID TEXT , doc_name TEXT, doc_spec TEXT,call_inquiry TEXT,call_objection TEXT,call_remark TEXT,doc_notice TEXT,sample_drop TEXT , sample_type TEXT, app_id TEXT , app_name TEXT , visitType TEXT) ;"
            "create table if not exists noti (noti_id INTEGER PRIMARY KEY   AUTOINCREMENT  , noti_string TEXT ,noti_sender TEXT , noti_date TEXT )";

            

            
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



#pragma  -mark  IUD STATMENT API

-(BOOL) iudStatementWithSQL_String :(NSString  *)str_sql {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        const char *insert_stmt = [str_sql UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    }
    
    BOOL success =((sqlite3_step(statement) == SQLITE_DONE) ?YES : NO);
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return success;
    
}
#pragma  -mark  SQL STATMENT API
-(NSDictionary *) selectStatementWithTable:(NSString  *)strTable_name {
    
    NSMutableDictionary *statmemnt_result = [[NSMutableDictionary alloc]init] ;
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *str_sql = [NSString stringWithFormat:@"select  * from %@" , strTable_name];
        
        const char *query_stmt = [str_sql UTF8String];
        
        NSMutableArray *dic_TableKey = [[NSMutableArray alloc]init];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            // loop to get table column
            for (int x = 0  ; x < sqlite3_column_count(statement) ; x ++ ) {
                
                [dic_TableKey addObject:[NSString stringWithFormat:@"%s" , sqlite3_column_name(statement , x ) ] ] ;
                [statmemnt_result setObject:[[NSMutableArray alloc] init] forKey:dic_TableKey[x]];
            }
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                for (int i = 0 ; i < sqlite3_data_count(statement) ; i ++ ) {
                    // get  table coulmn  and value
                    NSString *_column = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_name(statement, i)] ;
                    NSString *_result = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)] ;
                    
                    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:[statmemnt_result objectForKey:_column] ] ;
                    [tempArr addObject:_result];
                    [statmemnt_result setObject:tempArr forKey:_column];
                }
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(database);
            
        }
    }
    
    return statmemnt_result;
    
}










@end
