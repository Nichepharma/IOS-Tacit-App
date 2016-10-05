//
//  GetAllDoctorsFromServer.m
//  DashboardSQL
//
//  Created by Yahia on 2/18/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol SoapRequestDelegate <NSObject>

-(void) SoapRequest:(id) Request didFinishWithData:(NSMutableDictionary*) dict;
@optional
-(void) SoapRequest:(id)Request didFinishWithError:(int) ErrorCode;

@end


@interface SoapRequest : NSObject <NSXMLParserDelegate>

@property (strong,nonatomic) NSString *function;
@property (strong,nonatomic) NSString *att;
@property (strong,nonatomic) NSMutableArray *Dicts;
@property (strong,nonatomic) NSMutableArray *Keys;

@property (strong,nonatomic) NSMutableArray *values;
@property (strong,nonatomic) NSMutableDictionary *dict;
@property (strong,nonatomic) id<SoapRequestDelegate> delegate;
@property (strong,nonatomic) NSURLConnection *connect;
@property BOOL add;
-(id) initWithFunction:(NSString*) fun company_id :(int) companyNumber ;
-(void) sendRequestWithAttributes:(NSDictionary*) dict;

@end
