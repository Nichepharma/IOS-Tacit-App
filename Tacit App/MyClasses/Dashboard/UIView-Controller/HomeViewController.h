//
//  GetAllDoctorsFromServer.m
//  DashboardSQL
//
//  Created by Yahia on 2/18/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Header.h"


@interface HomeViewController : UIViewController


@property NSString *MsgString;

//
//@property(nonatomic, strong) MSG * Message;

#ifdef __IPHONE_8_0
#define GregorianCalendar NSCalendarIdentifierGregorian
#else
#define GregorianCalendar NSGregorianCalendar
#endif



@end
