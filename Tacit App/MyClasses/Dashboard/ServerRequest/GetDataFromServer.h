//
//  GetDoctorsFromServer.h
//  AlmofireObjective
//
//  Created by Yahia El-Dow on 10/16/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequest.h"
@interface GetDataFromServer : ServerRequest
+(void)getProductsWithCompanyID :(NSString*)companyID  userID :(NSString*) userID  CompletionHandler:(void (^)(NSDictionary * result))completionHandler ;
+(void)getDoctorWithCompanyID :(NSString*)companyID  userID :(NSString*) userID CompletionHandler:(void (^)(NSDictionary * result))completionHandler ;
+(void)getPharmaciesWithCompanyID :(NSString*)companyID  userID :(NSString*) userID CompletionHandler:(void (^)(NSDictionary *result))completionHandler ;
+(void)getHospitalsWithCompanyID :(NSString*)companyID  userID :(NSString*) userID CompletionHandler:(void (^)(NSDictionary *result))completionHandler ;
+(void)getNotificationCompanyID :(NSString*)companyID  userID :(NSString*) userID productID: (NSString *)pid CompletionHandler:(void (^)(NSDictionary *result))completionHandler ;
    +(void)getMotificationCompanyID :(NSString*)companyID  userID :(NSString*) userID productID: (NSString *)pid CompletionHandler:(void (^)(NSDictionary *result))completionHandler ;



+(NSDictionary*)serverApps_InfoArray ;
@end

