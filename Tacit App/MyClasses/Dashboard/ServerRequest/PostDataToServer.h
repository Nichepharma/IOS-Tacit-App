//
//  PostDataToServer.h
//  Tacit App
//
//  Created by Yahia El-Dow on 10/23/17.
//  Copyright © 2017 nichepharma.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerRequest.h"

@interface PostDataToServer : ServerRequest
+(void)checkLoginWithUsername:(NSString *)username  whithPassword:(NSString *) password CompletionHandler:(void (^)(NSDictionary * result))completionHandler;

+(void)saveSessionWithCompanyID : (int)companyID  userID : (int)userID sessionInfo:(NSDictionary*)sessionInfo CompletionHandler:(void (^)(NSDictionary * result))completionHandler ;
+(void)savePharmaciesSessionWithCompanyID : (int)companyID  userID : (int)userID sessionInfo:(NSDictionary*)sessionInfo CompletionHandler:(void (^)(NSDictionary * result))completionHandler ;
@end
