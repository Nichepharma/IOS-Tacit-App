//
//  GetDateNow.m
//  DashboardSQL
//
//  Created by Yahia on 2/19/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "GetDateNow.h"
static GetDateNow *sharedInstance = nil ;
@implementation GetDateNow
 NSString *curent_toDay;

+(GetDateNow*)getD{
    
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance d_toDay];
        [sharedInstance getSesstionID];
    }
    return sharedInstance;
}

-(NSString*) d_toDay {
    
//    if (!curent_toDay) {
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        curent_toDay = [dateFormatter stringFromDate:today];
       
//    }

    return curent_toDay;
}
-(NSString *)getSesstionID{
    NSString *sesstionID=[[NSString alloc] initWithString:[self d_toDay]];
    return sesstionID ;
}
@end
