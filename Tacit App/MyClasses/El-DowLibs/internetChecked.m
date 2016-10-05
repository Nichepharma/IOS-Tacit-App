//
//  internetChecked.m
//  LendoMax
//
//  Created by Yahia on 6/30/14.
//  Copyright (c) 2014 nichepharma. All rights reserved.
//

#import "internetChecked.h"
#import "Reachability.h"
@implementation internetChecked

-  (BOOL)Checked{
    
 //  NSError *error = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {

        if(conn){
            
            _internetChecked =true ;
            NSLog(@"there is interner");
        }
        else{
            return false;
        }
    }
    else {
        //there-is-no-connection warning
        _internetChecked =false ;
        NSLog(@"No interner");
    }
    return _internetChecked ;
    
    
}





@end
