//
//  ServerRequest.m
//  AlmofireObjective
//
//  Created by Yahia El-Dow on 10/15/17.
//  Copyright © 2017 Yahia El-Dow. All rights reserved.
//

#import "ServerRequest.h"
#import <AFNetworking.h>
@implementation ServerRequest

static NSString * const BaseURLString = @"http://www.tacitapp.com/Yahia/MobileWebService/";


//GetDataFromServer and PostDataToServer both of them inherits from ServerRequest

+(void)get:(NSDictionary *)parameters CompletionHandler:(void (^)(NSDictionary * result))completionHandler {
    NSDictionary *paras = @{@"data" : parameters};

    //From Prepare Manager Method
    [[self sessionManager] GET:BaseURLString parameters:paras
                      progress:nil 
                       success:^(NSURLSessionTask *task, id responseObject)
    {
        //NSString* newStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"string = %@ " , newStr);
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        completionHandler(dic);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completionHandler(NULL);
    }];    
}
+(void)post:(NSDictionary *)param CompletionHandler:(void (^)(NSDictionary * result))completionHandler {
    
    //(2) From Prepare Request Method
    NSMutableURLRequest *request  = [self sessionRequest:@"POST"];
    
    //(3) From Prepare Parameter Method
    [request setHTTPBody:[self postDataWithDictionayArray:param] ];

    //(1) From Prepare Manager Method
    NSURLSessionDataTask *dataTask = [[self sessionManager] dataTaskWithRequest:request
                                                            completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
    {
        if (error) {
            NSLog(@"Error: %@", error); completionHandler(NULL);
        
        } else {
            NSString* newStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"newStr %@" , newStr);
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            completionHandler(dic);
        }
    }];
    [dataTask resume];
}

//+(AFJSONRequestSerializer *) serializer {
//    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
//    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [serializer setValue:@"content-type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
//    [serializer setValue:@"cache-control" forHTTPHeaderField:@"no-cache"];
//    return serializer;
//}

//(1) Prepare The Manager
+(AFHTTPSessionManager *) sessionManager{
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [serializer setValue:@"content-type" forHTTPHeaderField:@"application/x-www-form-urlencoded"];
    [serializer setValue:@"cache-control" forHTTPHeaderField:@"no-cache"];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer =  serializer;
    return  manager;
}

//(2) Prepare The Request
+(NSMutableURLRequest*)sessionRequest :(NSString *) methodType{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:BaseURLString]];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:methodType];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    return  request;
}

//(3) Prepare The Post Parameters
+(NSMutableData*)postDataWithDictionayArray : (NSDictionary *)paramDic{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDic options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return NULL;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[[NSString stringWithFormat:@"data=%@" , jsonString]  dataUsingEncoding:NSUTF8StringEncoding]];
    return postData ;
}
@end

