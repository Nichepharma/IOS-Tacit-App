 //
//  ReturnSesstionDetails.h
//  DashboardSQL
//
//  Created by Yahia on 2/25/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
@interface ReturnSesstionDetails : NSObject
+(ReturnSesstionDetails*)sharedInstance ;
-(void)setData:(NSString *)str_sessionID ;
-(NSMutableDictionary *)getData ;

@end
