//
//  ApplicationData.h
//  Career Management Apps
//
//  Created by Yahia on 3/14/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Read_WriteJSONFile.h"

@interface ApplicationData : NSObject

+(ApplicationData*)getSharedInstance ;

@property (setter = setAppName: , getter=getAppName) NSString *str_AppName ;
@property (readonly, getter=getSlideNumber)char numberOfSlide ;
@property (readonly, getter=getApplicationID)NSString *applicationID ;
@property (readonly, getter = getMasterData) NSMutableDictionary *masterDataArray ;
@property (readonly, getter = getScrollViewBKG) NSMutableArray *scrollViewBKG ;
@property (readonly, getter = getPDFArray )NSMutableDictionary *dicOf_pdfDetail ;
@property (readonly, getter = getMENUArray )NSMutableDictionary *dicOf_menuDetail ;
-(id)initWithApplicationName :(NSString *)str_AppName ;
@end
