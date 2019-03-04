//
//  ServerRequest.h
//  AlmofireObjective
//
//  Created by Yahia El-Dow on 10/15/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerRequest : NSDictionary
+(void)get:(NSDictionary *)parameters CompletionHandler:(void (^)(NSDictionary * result))completionHandler ;
+(void)post:(NSDictionary *)param CompletionHandler:(void (^)(NSDictionary * result))completionHandler ;
@end
