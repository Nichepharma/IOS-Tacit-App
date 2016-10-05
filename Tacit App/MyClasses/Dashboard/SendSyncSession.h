//
//  SendSyncSession.h
//  DashboardSQL
//
//  Created by Yahia on 2/25/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//




#import  <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SoapRequest.h"


@protocol sendSyncDelegate<NSObject>
@required
-(void)syncSended :(NSInteger )checkedSync :(NSString *)str_sync_strVisitTime;
@optional

@end

#import "Header.h"




@interface SendSyncSession : NSObject<SoapRequestDelegate >
@property (nonatomic,strong) SoapRequest *soap;
-(void)syncData:(NSString *)str_SessionID;
@property (strong,nonatomic) id<sendSyncDelegate> syncDelegate;
@end
