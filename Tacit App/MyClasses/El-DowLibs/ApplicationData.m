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
@synthesize masterDataArray , numberOfSlide ,scrollViewBKG  ,applicationID , dicOf_pdfDetail , dicOf_menuDetail ;


-(id)initWithApplicationName :(NSString *)str_AppName{

    [self setAppName:str_AppName];
    masterDataArray = [Read_WriteJSONFile readStringFromFileFromApplicationName:[self getAppName]] ;
    numberOfSlide   = [[[self getMasterData] objectForKey:@"slideshows"] count] ;
    applicationID   = [[self getMasterData] objectForKey:@"appID"];
    dicOf_pdfDetail = [[NSMutableDictionary alloc] initWithDictionary:[self set_pdfDetails]] ;
    dicOf_menuDetail = [[NSMutableDictionary alloc] initWithDictionary:[self set_menuDetails]];
    [self scrollViewBKG];
//    NSLog(@"applicationID %@", [self getMasterData] ) ;
    return self ;
}

+(ApplicationData*)getSharedInstance{
    
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
    } return sharedInstance;
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
    dicOf_menuDetail = [[NSMutableDictionary alloc] initWithDictionary:[self set_menuDetails]];


    

}



/*! this Method to get Image Name From json Array inside Decoument File */
-(NSMutableDictionary *)set_pdfDetails {
    if (!dicOf_pdfDetail ) dicOf_pdfDetail = [Read_WriteJSONFile readJsonFileWithName:[NSString stringWithFormat:@"%@/pdf", [self getAppName] ] ];
    return dicOf_pdfDetail ;
}

/*! this Method to get Image Name and go to Slide Number From json Array inside Decoument File */
-(NSMutableDictionary *)set_menuDetails {
    if (!dicOf_menuDetail ) dicOf_menuDetail = [Read_WriteJSONFile readJsonFileWithName:[NSString stringWithFormat:@"%@/menu", [self getAppName] ] ];
    return dicOf_menuDetail ;
}
@end
