//
//  ReturnSesstionDetails.m
//  DashboardSQL
//
//  Created by Yahia on 2/25/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "ReturnSesstionDetails.h"
static ReturnSesstionDetails *sharedInstance = nil ;

@implementation ReturnSesstionDetails

NSMutableDictionary *sessionDetails ;
// USING DATA ON VIEWSESSSIONDETAILS VIEW

+(ReturnSesstionDetails*)sharedInstance{
    
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        
        sessionDetails =[[NSMutableDictionary alloc] init];
        [sharedInstance getData];
        
    }
    return sharedInstance;
}



-(void)setData:(NSString *)str_sessionID{
//    NSLog(@"sesstion De %@",[[DBManager getSharedInstance] getOneSyncSesstion:str_sessionID] );

    NSString *docString =[[[DBManager getSharedInstance] getOneSyncSesstion:str_sessionID] objectAtIndex:9];
    
    NSArray* doc_Array = [docString componentsSeparatedByString: @"|"];
  
    
    NSString *docSpec =[[[DBManager getSharedInstance] getOneSyncSesstion:str_sessionID] objectAtIndex:10];
    NSArray* docSpecArray = [docSpec componentsSeparatedByString: @"|"];

    
    NSString *_totalTime =[[[DBManager getSharedInstance] getOneSyncSesstion:str_sessionID] objectAtIndex:2];
    
    NSString *_visitType =[[[DBManager getSharedInstance] getOneSyncSesstion:str_sessionID] objectAtIndex:13];

    [sessionDetails removeAllObjects];

    NSLog(@"_visitType %@ ", _visitType);


    if ([_visitType isEqualToString:@"1"]) {
        [sessionDetails setObject:@"Privarte Market" forKey:@"visit_type"];
    }else if ([_visitType isEqualToString:@"2"]) {
        [sessionDetails setObject:@"Hospitals" forKey:@"visit_type"];
    }else if ([_visitType isEqualToString:@"3"]) {
        [sessionDetails setObject:@"Pharmacies" forKey:@"visit_type"];
    }

    [sessionDetails setObject:str_sessionID forKey:@"id"];
    [sessionDetails setObject:doc_Array forKey:@"docName"];
    [sessionDetails setObject:docSpecArray forKey:@"docSpec"];
    [sessionDetails setObject:_totalTime forKey:@"du"];
    
}

-(NSMutableDictionary *)getData{
   
    return sessionDetails;
}
@end
