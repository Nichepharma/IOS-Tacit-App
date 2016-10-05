//
//  DBManager.h
//  SQLLight
//
//  Created by Yahia on 2/15/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;

-(void)startCreateDB ;

-(NSString *)getUserId ;

- (NSMutableDictionary*) getAllDoctors   ;

- (BOOL) saveUsername :(NSString*)userName
              password:(NSString*)password
                userID:(NSString*)uid
               company:(NSString*)str_comp ;

-(NSString *)getUserCompany ;

- (BOOL) saveData:(NSString*)doc_ID
             name:(NSString*)doc_Name
             spec:(NSString*)doc_Spec ;

-(BOOL)chekLogin ;

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
       sample_drop:(NSString *)sample_drop ;



- (NSMutableDictionary*) getAllSyncSessionByAppID :(NSString *)str_appID ;
- (NSMutableArray*) getOneSyncSesstion :(NSString *)_SyncID ;
-(NSString *)getUsername ;
-(NSMutableArray *)getDetailsSesttionData :(NSString *)_dSyncID ;

-(void)deleteDB:(NSString *)str_tableName ;

-(BOOL)updateSyncData :(NSMutableArray *)_DataVisit ;
-(BOOL)deleteSyncData:(NSString *)_visitsDate ;
-(BOOL)update_e_SyncData:(NSMutableDictionary *)e_visitsDate ;


//---------Notifications ----------------//
#pragma Notofications API

- (NSMutableDictionary*) getNotifications;

-(BOOL)insertNotificationWithStringMessage:(NSString*)str_msg
                                    sender:(NSString*)sender noti_Daye:(NSString *)str_noti_Date ;
@end