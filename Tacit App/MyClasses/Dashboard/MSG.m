//
//  MSG.m
//  LendoMax
//
//  Created by Yahia on 7/24/14.
//  Copyright (c) 2014 nichepharma. All rights reserved.
//

#import "MSG.h"

@implementation MSG
static MSG * instance = nil;

+(MSG *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
    
            instance= [MSG new];
            
        }
      
    }
    return instance;
}
@end
