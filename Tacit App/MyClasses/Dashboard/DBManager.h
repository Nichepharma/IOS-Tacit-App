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



//-----------------------------------#Edit Doctors , Hosptial and Pharmacy  DataBase Function#-----------------------------------//
//Doctord

- (BOOL) saveDoctors:(NSDictionary*)doctorsInfo ;
- (NSMutableDictionary*) getAllDoctors   ;
- (NSMutableDictionary*) getAllDoctors :(NSString *)type :(NSString *)hospital_id ;


// Hospitals
- (BOOL) saveHospitals:(NSDictionary*)hospitalsInfo ;
- (NSMutableDictionary*) getAllHospitals ;


//Pharmacies
- (BOOL) savePharmacies:(NSDictionary *)pharmciesInfo;
- (NSMutableDictionary*) getAllPharmacies ;

//END



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
        visitType :(NSString *)visitType ;



- (NSMutableDictionary*) getAllSyncSessionByAppID :(NSString *)str_appID ;
- (NSMutableArray*) getOneSyncSesstion :(NSString *)_SyncID ;
-(NSMutableArray *)getDetailsSesttionData :(NSString *)_dSyncID ;

-(BOOL)deleteAllDB ;

-(BOOL)updateSyncData :(NSMutableArray *)_DataVisit ;
-(BOOL)deleteSyncData:(NSString *)_visitsDate ;
-(BOOL)update_e_SyncData:(NSMutableDictionary *)e_visitsDate ;


//---------Notifications ----------------//
#pragma Notofications API

- (NSMutableDictionary*) getNotifications;

-(BOOL)insertNotificationWithStringMessage:(NSString*)str_msg
                                    sender:(NSString*)sender noti_Daye:(NSString *)str_noti_Date ;
@end
