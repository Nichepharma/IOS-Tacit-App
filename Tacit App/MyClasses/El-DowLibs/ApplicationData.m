//
//  ApplicationData.m
//  Career Management Apps
//
//  Created by Yahia on 3/14/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import "ApplicationData.h"
#import "ContanerAppView.h"
@implementation ApplicationData

static ApplicationData  *sharedInstance = nil ;
@synthesize masterDataArray , numberOfSlide , appAnalytics , scrollViewBKG  ,applicationID , dicOf_pdfDetail , dicOf_menuDetail ,sampleType ;


+(ApplicationData*)getSharedInstance{
    if (!sharedInstance) {
        
        sharedInstance = [[super allocWithZone:NULL]init];
    }
    return sharedInstance;
}

-(id)initWithApplicationName :(NSString *)str_AppName{
    [self setAppName:str_AppName];
    [masterDataArray removeAllObjects];
    [dicOf_menuDetail removeAllObjects];

    masterDataArray  = [Read_WriteJSONFile readStringFromFileFromApplicationName:str_AppName] ;
    numberOfSlide    = [[[self getMasterData] objectForKey:@"slideshows"] count] ;
     appAnalytics    =  [self appIsAnalytics];
    applicationID    = [[self getMasterData] objectForKey:@"appID"];
    sampleType       = [[self getMasterData]objectForKey:@"sampleType"] ;
    dicOf_pdfDetail  = [[NSMutableDictionary alloc] initWithDictionary:[self set_pdfDetails]] ;
    dicOf_menuDetail = [Read_WriteJSONFile readJsonFileWithName:[NSString stringWithFormat:@"%@/menu", [self getAppName] ] ];

    [self scrollViewBKG];
//    NSLog(@"applicationID %@",  dicOf_menuDetail ) ;
    return self ;
}

// check if product Have a dashboard (timer , send data to server , and more ) or product just detailer only
-(bool)appIsAnalytics{
     if ([[masterDataArray objectForKey:@"analytics"]isEqualToString:@"NO"]) {
          return false;
     }
     return true ;
}


-(void)scrollViewBKG {

    [scrollViewBKG removeAllObjects];
    scrollViewBKG = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *arr_BKG in [ masterDataArray objectForKey:@"slideshows"])
        [scrollViewBKG addObject:[arr_BKG objectForKey:@"slideBKG"]];

    masterDataArray = [Read_WriteJSONFile readStringFromFileFromApplicationName:[self getAppName]] ;
    numberOfSlide   = [[[self getMasterData] objectForKey:@"slideshows"] count] ;
    applicationID   = [[self getMasterData] objectForKey:@"appID"];
    dicOf_pdfDetail = [[NSMutableDictionary alloc] initWithDictionary:[self set_pdfDetails]] ;
    dicOf_menuDetail = [Read_WriteJSONFile readJsonFileWithName:[NSString stringWithFormat:@"%@/menu", [self getAppName] ] ];
}



/*! this Method to get Image Name From json Array inside Decoument File */
-(NSMutableDictionary *)set_pdfDetails {
//    [dicOf_pdfDetail removeAllObjects];
  //  NSLog(@"APP NAME = %@ " ,     [self getAppName]);
    [dicOf_pdfDetail removeAllObjects] ;
  //  if (!dicOf_pdfDetail )
        dicOf_pdfDetail = [Read_WriteJSONFile readJsonFileWithName:[NSString stringWithFormat:@"%@/pdf", [self getAppName] ] ];
 //   NSLog(@"dicOf_pdfDetail = %@ " ,     dicOf_pdfDetail);

    return dicOf_pdfDetail ;
}

/*! this Method to get Image Name and go to Slide Number From json Array inside Decoument File */
-(NSMutableDictionary *)set_menuDetails {
    if (!dicOf_menuDetail ) dicOf_menuDetail = [Read_WriteJSONFile readJsonFileWithName:[NSString stringWithFormat:@"%@/menu", [self getAppName] ] ];
    return dicOf_menuDetail ;
}

-(void)clearAppData{
    [masterDataArray removeAllObjects];
    [dicOf_menuDetail removeAllObjects];
    [dicOf_pdfDetail removeAllObjects] ;
    [scrollViewBKG removeAllObjects];
    numberOfSlide = 0 ;
}
@end
