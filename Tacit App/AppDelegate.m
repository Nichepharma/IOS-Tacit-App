//
//  AppDelegate.m
//  Career Management Apps
//
//  Created by Yahia on 3/21/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import "AppDelegate.h"
//http://stackoverflow.com/questions/tagged/google-cloud-messaging
#import "Header.h"
@interface AppDelegate ()

//@property(nonatomic, strong) void (^registrationHandler)
//(NSString *registrationToken, NSError *error);
//@property(nonatomic, assign) BOOL connectedToGCM;
//@property(nonatomic, strong) NSString* registrationToken;
//@property(nonatomic, assign) BOOL subscribedToTopic;
@end

//NSString *const SubscriptionTopic = @"/topics/global";

@implementation AppDelegate

// [START register_for_remote_notifications]
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"App Path %@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] );
       return YES;
}



@end
