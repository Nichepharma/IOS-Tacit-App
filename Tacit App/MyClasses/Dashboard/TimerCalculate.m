//
//  TimerCalclate.m
//  DashboardSQL
//
//  Created by Yahia on 2/19/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "TimerCalculate.h"
static TimerCalculate *sharedInstance = nil;

@implementation TimerCalculate


+(TimerCalculate*)getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
       
    }
    return sharedInstance;
}


NSDateFormatter *timeFormat ;

-(void) init_fire :(int) _numOf_Slides{
  
        //_numOf_Slides=11;
        _str_SessionID =[[NSString alloc]initWithString:[[GetDateNow getD] getSesstionID]];
      
        timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm:ss"];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [timeFormat setLocale:usLocale];


//        if (!self.arr_accu ) {
        self.arr_accu=[[NSMutableArray alloc] init];
            for (int x=0; x<_numOf_Slides ; x++) {
                NSString *str=@"0";
                [self.arr_accu addObject:str ];
//            }
        }
        

}



-(NSString *)TimeNow {
    if (!timeFormat) {
        _str_SessionID =[[NSString alloc]initWithString:[[GetDateNow getD] getSesstionID]];
        timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm:ss"];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [timeFormat setLocale:usLocale];

    }
    NSString *theTime1 =[[NSString alloc] init];
    NSDate *now = [[NSDate alloc] init];
    theTime1  = [timeFormat stringFromDate:now];
    return theTime1 ;
}


-(void)updateSlide :(NSString *)time1 :(NSInteger )slideNumber{
    
    NSDate *date1= [timeFormat dateFromString:time1];
    NSDate *date2 = [timeFormat dateFromString:[self TimeNow]];
    
    // NSLog(@"time 1 = %@ , time 2 = %@ slide Number = %i ",time1,[self TimeNow],slideNumber);
    
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
    
    double result = secondsBetween ;
//          NSLog(@"Time Interval %f ",result);
    double resultValue = result + [[self.arr_accu objectAtIndex:slideNumber] doubleValue];
    NSString *convert_result_ToStringValue =[[NSString alloc] initWithFormat:@"%f",resultValue];
    [self.arr_accu replaceObjectAtIndex:slideNumber withObject:convert_result_ToStringValue];
    
//    
//        NSLog(@"%@ ",[self getAccTime]);
  //     NSLog(@"%i ",slideNumber);
}





-(NSString *)getAccTime{
    NSString *str_sesstionAccTime=[[NSString alloc] init];
    for (NSString *n in self.arr_accu) {
        str_sesstionAccTime= [str_sesstionAccTime stringByAppendingFormat:@"%f|",[n floatValue]];
    }
    return str_sesstionAccTime;
}

-(double)getTimeSetInApplication {
    double sum = 0;
    for (NSNumber * n in self.arr_accu) {
        sum += [n doubleValue];
    }
    return sum ;
}





@end
