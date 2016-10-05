//
//  SendSyncSession.m
//  DashboardSQL
//
//  Created by Yahia on 2/25/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "SendSyncSession.h"
#define Function_Name @"SyncSession"



@implementation SendSyncSession
NSString *strDateOfVisits ;
-(void)syncData:(NSString *)str_SessionID{
    
    strDateOfVisits = str_SessionID;
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com/m"];
    NSData *intdata = [NSData dataWithContentsOfURL:scriptUrl];
    if (intdata) {

        NSMutableArray *arr_data = [[NSMutableArray alloc] initWithArray:[[DBManager getSharedInstance]getOneSyncSesstion:str_SessionID]];
        //  NSLog(@">>>>>>>> %@",arr_data );
        NSDictionary *par = @{@"pid":[[ApplicationData getSharedInstance] getApplicationID] ,
                              @"acc_time":[arr_data objectAtIndex:0],
                              @"last_mod":str_SessionID,
                              @"due":[arr_data objectAtIndex:2],
                              @"did":[arr_data objectAtIndex:3],
                              @"doctorNotice":[arr_data objectAtIndex:4],
                              @"samplesDroped":[arr_data objectAtIndex:5],
                              @"callRemarks":[arr_data objectAtIndex:6],
                              @"callInquiry":[arr_data objectAtIndex:7],
                              @"callObjection":[arr_data objectAtIndex:8],
                              @"nextVisit":@"nil",
                              @"username":[[DBManager getSharedInstance] getUsername],
                              @"doctorLoc":@"N/A"};
        
        int company_id = 0 ;
        if ([[[DBManager getSharedInstance] getUserCompany] isEqualToString:@"tabuk"]) {
            company_id  = 0 ;
        }else if ([[[DBManager getSharedInstance] getUserCompany] isEqualToString:@"chiesi"]){
            company_id = 1 ;
        }else if ([[[DBManager getSharedInstance] getUserCompany] isEqualToString:@"dermazon"]){
            company_id = 2 ;
        }
        
        self.soap =[[SoapRequest alloc] initWithFunction:Function_Name company_id:company_id];
        self.soap.delegate=self;
        [self.soap sendRequestWithAttributes:par];
        
        
        
        
    } else {
        
        UIAlertView* alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"You are not connected to the Internet!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];}
    
    
}




-(void) SoapRequest:(id)Request didFinishWithData:(NSMutableDictionary *)dict
{
    SoapRequest *s = Request;
    for (NSDictionary *d in s.Dicts)
    {
        NSLog(@"ffff %@", d  );
        if ([d[@"res"] integerValue]>1)
            [self.syncDelegate syncSended:[d[@"res"] integerValue]:strDateOfVisits];
        // NSLog(@"ffff %@", d[@"res"]  );
        
        //                        [syncView stopLoad];
    }
    
    
    
}


-(void)SoapRequest:(id)Request didFinishWithError:(int)ErrorCode{
    //  SoapRequest *s = Request;
    NSLog(@"error");
}



@end
