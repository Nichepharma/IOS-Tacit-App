//
//  PostDataToServer.m
//  Tacit App
//
//  Created by Yahia El-Dow on 10/23/17.
//  Copyright © 2017 nichepharma.com. All rights reserved.
//

#import "PostDataToServer.h"

@implementation PostDataToServer


+(void)checkLoginWithUsername:(NSString *)username  whithPassword:(NSString *) password CompletionHandler:(void (^)(NSDictionary * result))completionHandler {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:username   forKey:@"username"];
    [dic setValue: password    forKey:@"password"];
    [dic setValue: [self getTacitAppVersion]    forKey:@"app_version"];
    [dic setValue: [self getTacitAppBuild]    forKey:@"app_build"];
    [dic setValue:@"checkLogin" forKey:@"ASK".capitalizedString ];
    [ServerRequest post: dic CompletionHandler:^(NSDictionary *result) {
        completionHandler(result);
    }];
}

+(void)saveSessionWithCompanyID : (int)companyID  userID : (int)userID sessionInfo:(NSDictionary*)sessionInfo CompletionHandler:(void (^)(NSDictionary * result))completionHandler {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%d",companyID]  forKey:@"companyID"];
    [dic setValue: [NSString stringWithFormat:@"%d",userID]    forKey:@"userID"];
 
    NSMutableDictionary *sessionDic = [[NSMutableDictionary alloc] init];
    [sessionDic setDictionary:sessionInfo];
    [sessionDic setValue: [self getTacitAppVersion]    forKey:@"app_version"];
    [sessionDic setValue: [self getTacitAppBuild]    forKey:@"app_build"];
    [dic setValue: sessionDic    forKey:@"sessionInfo"];
    [dic setValue:@"saveSessions" forKey:@"ASK".capitalizedString ];
    
    [ServerRequest post: dic CompletionHandler:^(NSDictionary *result) {
        completionHandler(result);
    }];
}


+(void)savePharmaciesSessionWithCompanyID : (int)companyID  userID : (int)userID sessionInfo:(NSDictionary*)sessionInfo CompletionHandler:(void (^)(NSDictionary * result))completionHandler {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%d",companyID]  forKey:@"companyID"];
    [dic setValue: [NSString stringWithFormat:@"%d",userID]    forKey:@"userID"];
    
    
    NSMutableDictionary *sessionDic = [[NSMutableDictionary alloc] init];
    [sessionDic setDictionary:sessionInfo];
    [sessionDic setValue: [self getTacitAppVersion]    forKey:@"app_version"];
    [sessionDic setValue: [self getTacitAppBuild]    forKey:@"app_build"];
    
    [dic setValue: sessionDic    forKey:@"sessionInfo"];
    [dic setValue:@"savePharmacies" forKey:@"ASK".capitalizedString ];
    
    [ServerRequest post: dic CompletionHandler:^(NSDictionary *result) {
        completionHandler(result);
    }];
}
static NSString *TACIT_APP_BUILD = @"";
static NSString *TACIT_APP_VERSION = @"";
+(NSString *) getTacitAppVersion {
    if ([TACIT_APP_VERSION isEqualToString:@""]) {
        TACIT_APP_VERSION = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return TACIT_APP_VERSION;
}
+(NSString *)getTacitAppBuild {
    if ([TACIT_APP_BUILD isEqualToString:@""]) {
        TACIT_APP_BUILD = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    }
    return TACIT_APP_BUILD ;
}
@end
