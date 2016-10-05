//
//  TimerCalclate.h
//  DashboardSQL
//
//  Created by Yahia on 2/19/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
@interface TimerCalculate : NSObject
+(TimerCalculate*)getSharedInstance ;
-(void) init_fire :(int) _numOf_Slides ;
//- (id) init :(int) _numOf_Slides ;
@property (strong , nonatomic)  NSMutableArray *arr_accu ;
-(NSString *)TimeNow;
-(void)updateSlide :(NSString *)time1 :(NSInteger )slideNumber;
@property (strong ,nonatomic ) NSString *str_SessionID ;
-(double)getTimeSetInApplication ;
-(NSString *)getAccTime;

@end
