//
//  GetAllDoctorsFromServer.h
//  DashboardSQL
//
//  Created by Yahia on 2/18/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoapRequest.h"
#import "Header.h"
@interface GetAllDoctorsFromServer : NSObject<SoapRequestDelegate>
+(GetAllDoctorsFromServer*)get_Doc ;

@end
