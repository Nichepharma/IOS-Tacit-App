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

@property(nonatomic, strong) void (^registrationHandler)
(NSString *registrationToken, NSError *error);
@property(nonatomic, assign) BOOL connectedToGCM;
@property(nonatomic, strong) NSString* registrationToken;
@property(nonatomic, assign) BOOL subscribedToTopic;
@end

NSString *const SubscriptionTopic = @"/topics/global";

@implementation AppDelegate

// [START register_for_remote_notifications]
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  //  [[NSUserDefaults standardUserDefaults] setObject:@[@"eg", @"ar"] forKey:@"AppleLanguages"];

//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0 ;
       return YES;
}

// [START connect_gcm_service]
- (void)applicationDidBecomeActive:(UIApplication *)application {
    }
// [END connect_gcm_service]



// [START disconnect_gcm_service]
- (void)applicationDidEnterBackground:(UIApplication *)application {

}


// [START receive_apns_token]
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Token is >> %@",deviceToken );
    // [END receive_apns_token]
    // [START get_gcm_reg_token]
    // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.

    // [END get_gcm_reg_token]
}

// [START receive_apns_token_error]
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registration for remote notification failed with error: %@", error.localizedDescription);
    // [END receive_apns_token_error]
    NSDictionary *userInfo = @{@"error" :error.localizedDescription};
    [[NSNotificationCenter defaultCenter] postNotificationName:_registrationKey
                                                        object:nil
                                                      userInfo:userInfo];
}

// [START ack_message_reception]
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"Notification received: %@", userInfo);
//    // This works only if the app started the GCM service
//    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
//    // Handle the received messagey
//    // [START_EXCLUDE]
//    [[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
//                                                        object:nil
//                                                      userInfo:userInfo];
//    
//    [[DBManager getSharedInstance]insertNotificationWithStringMessage:[userInfo objectForKey:@"message"] sender:@"0" noti_Daye:@"Date"];
//    [self Trigger_LocalNotification:[userInfo objectForKey:@"body"]];
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    NSLog(@"Notification received: %@", userInfo);
    
    /*
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
    // [START_EXCLUDE]
    [[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
                                                        object:nil
                                                      userInfo:userInfo];
    handler(UIBackgroundFetchResultNoData);
    [[DBManager getSharedInstance]insertNotificationWithStringMessage:[userInfo objectForKey:@"message"] sender:@"0" noti_Daye:@"Date"];

    [self Trigger_LocalNotification:[userInfo objectForKey:@"body"]];
    */
    
    // [END_EXCLUDE]
}


// [START on_token_refresh]
- (void)onTokenRefresh {
    /*
    // A rotation of the registration tokens is happening, so the app needs to request a new token.
    NSLog(@"The GCM registration token needs to be changed.");
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
     */
}
// [END on_token_refresh]


-(void)Trigger_LocalNotification :(NSString *)str_Text{
 
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *_localNotification = [[UILocalNotification alloc]init];
    
    //setting the fire dat of the local notification
    
     _localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    //setting the time zone
    _localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    //setting the message to display
    _localNotification.alertBody = str_Text ;
    
    //default notification sound
    _localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //displaying the badge number
    _localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber]+1;
    
    
    
    //schedule a notification at its specified time with the help of the app delegate
    [[UIApplication sharedApplication]scheduleLocalNotification:_localNotification];
    
}

    
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NotificationViewController *ringingVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"notificationView"];
    [self.window setRootViewController:ringingVC];

    
    
}


// [START upstream_callbacks]
- (void)willSendDataMessageWithID:(NSString *)messageID error:(NSError *)error {
    if (error) {
        // Failed to send the message.
    } else {
        // Will send message, you can save the messageID to track the message
    } 
}

- (void)didSendDataMessageWithID:(NSString *)messageID {
    // Did successfully send message identified by messageID
}
// [END upstream_callbacks]

- (void)didDeleteMessagesOnServer {
    // Some messages sent to this device were deleted on the GCM server before reception, likely
    // because the TTL expired. The client should notify the app server of this, so that the app
    // server can resend those messages.
}

@end
