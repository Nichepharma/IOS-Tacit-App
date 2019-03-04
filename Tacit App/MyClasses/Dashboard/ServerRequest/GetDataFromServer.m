//
//  GetDoctorsFromServer.m
//  AlmofireObjective
//
//  Created by Yahia El-Dow on 10/16/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

#import "GetDataFromServer.h"
#import "Read_WriteJSONFile.h"
@implementation GetDataFromServer


static NSDictionary *dicOf_serverApps ;
+(NSDictionary*)serverApps_InfoArray {
    if (!dicOf_serverApps) {
        dicOf_serverApps = [Read_WriteJSONFile readJsonfromServer:@"http://www.tacitapp.com/Yahia/tacitapp/appVersion.txt"];
    }
    return dicOf_serverApps ;
}
+(void)checkLoginWithUsername:(NSString *)username  whithPassword:(NSString *) password CompletionHandler:(void (^)(NSDictionary * result))completionHandler {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:username   forKey:@"username"];
    [dic setValue: password    forKey:@"password"];
    [dic setValue:@"checkLogin" forKey:@"ASK".capitalizedString ];
    [dic setValue: [self getTacitAppVersion]    forKey:@"app_version"];
    [dic setValue: [self getTacitAppBuild]    forKey:@"app_build"];
    
    [ServerRequest post: dic CompletionHandler:^(NSDictionary *result) {
        completionHandler(result);
    }];
}
+(void)getProductsWithCompanyID :(NSString*)companyID  userID :(NSString*) userID  CompletionHandler:(void (^)(NSDictionary * result))completionHandler {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:companyID   forKey:@"companyID"];
    [dic setValue: userID    forKey:@"userID"];
    [dic setValue:@"getUserProduct" forKey:@"ASK".capitalizedString ];
    [dic setValue: [self getTacitAppVersion]    forKey:@"app_version"];
    [dic setValue: [self getTacitAppBuild]    forKey:@"app_build"];
    
    [ServerRequest post: dic CompletionHandler:^(NSDictionary *result) {
        completionHandler(result);
    }];
}
+(void)getDoctorWithCompanyID :(NSString*)companyID  userID :(NSString*) userID CompletionHandler:(void (^)(NSDictionary * result))completionHandler {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:companyID   forKey:@"companyID"];
    [dic setValue: userID    forKey:@"userID"];
    [dic setValue:@"getDoctors" forKey:@"ASK".capitalizedString ];
    [dic setValue: [self getTacitAppVersion]    forKey:@"app_version"];
    [dic setValue: [self getTacitAppBuild]    forKey:@"app_build"];
    
    
    [self get:dic CompletionHandler:^(NSDictionary *result){
        completionHandler(result);
    }];
}
+(void)getPharmaciesWithCompanyID :(NSString*)companyID  userID :(NSString*) userID CompletionHandler:(void (^)(NSDictionary *result))completionHandler {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:companyID   forKey:@"companyID"];
    [dic setValue: userID    forKey:@"userID"];
    [dic setValue:@"getPharmacies" forKey:@"ASK".capitalizedString];
    [dic setValue: [self getTacitAppVersion]    forKey:@"app_version"];
    [dic setValue: [self getTacitAppBuild]    forKey:@"app_build"];
    
    [self get:dic CompletionHandler:^(NSDictionary *result){
        completionHandler(result);
    }];
}
+(void)getHospitalsWithCompanyID :(NSString*)companyID  userID :(NSString*) userID CompletionHandler:(void (^)(NSDictionary *result))completionHandler {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:companyID  forKey: @"companyID"];
    [dic setValue:userID     forKey: @"userID"];
    [dic setValue:@"getHospitals" forKey:@"ASK".capitalizedString];
    [dic setValue: [self getTacitAppVersion]    forKey:@"app_version"];
    [dic setValue: [self getTacitAppBuild]    forKey:@"app_build"];
    
    [self get:dic CompletionHandler:^(NSDictionary *result){
        if (result) {
            completionHandler(result);
            return ;
        }
        completionHandler([[NSDictionary alloc] init]);
        
    }];
}
+(void)getNotificationCompanyID :(NSString*)companyID  userID :(NSString*) userID productID: (NSString *)pid CompletionHandler:(void (^)(NSDictionary *result))completionHandler {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:companyID  forKey: @"companyID"];
    [dic setValue:userID     forKey: @"userID"];
    [dic setValue:pid forKey:@"productID"];
    [dic setValue:@"getNotification" forKey:@"ASK".capitalizedString];
    [dic setValue: [self getTacitAppVersion]    forKey:@"app_version"];
    [dic setValue: [self getTacitAppBuild]    forKey:@"app_build"];
    
    [self get:dic CompletionHandler:^(NSDictionary *result){
        completionHandler(result);
    }];
}
+(void)getMotificationCompanyID :(NSString*)companyID  userID :(NSString*) userID productID: (NSString *)pid CompletionHandler:(void (^)(NSDictionary *result))completionHandler {
    
    NSMutableDictionary *dic = [[NSMutableDictionary     alloc] init];
    [dic setValue:companyID  forKey: @"companyID"];
    [dic setValue:userID     forKey: @"userID"];
    [dic setValue:pid forKey:@"productID"];
    [dic setValue:@"getMotification" forKey:@"ASK".capitalizedString];
    [dic setValue: [self getTacitAppVersion]    forKey:@"app_version"];
    [dic setValue: [self getTacitAppBuild]    forKey:@"app_build"];
    
    [self get:dic CompletionHandler:^(NSDictionary *result){
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
