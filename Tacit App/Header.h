//
//  Header.h
//  Created by Yahia on 2/3/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#ifndef OfferApp_Header_h
#define OfferApp_Header_h



//! Zip App  https://github.com/ZipArchive/ZipArchive

#import "GetDataFromServer.h"
#import "PostDataToServer.h"
#import "Image.h"
#import "UIImageView+ImageViewCategory.h"
#import "Button.h"
#import "Label.h"
#import "Activity_indicator_loading.h"
#import "_ScrollingView.h"

#import "ContanerAppView.h"
#import "internetChecked.h"
#import "ApplicationData.h"

#import "AlertController.h"

#import "PDFViewer.h"
#import "MenuView.h"
// DashBoard

#import "GetDateNow.h"
#import "TimerCalculate.h"
#import "DBManager.h"

#import "ReturnSesstionDetails.h"
#import "MSG.h"
//Dashboard View Controller

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "NotificationViewController.h"
#import "DoctorsViewController.h"
#import "SyncViewController.h"
#import "FeedViewController.h"
#import "viewSessionDetails.h"

#endif






/*
 - (void)didRotate:(NSNotification *)notification {
 header.frame =CGRectMake(0, 0, self.view.frame.size.width, 40) ;
 webViewMaster.frame = CGRectMake(0, header.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) ;
 btnShare.frame = CGRectMake(header.frame.size.width - 40 , 0, 40, header.frame.size.height);
 [self close_open_Menu];
 if (aiLoader) {
 aiLoader.frame = webViewMaster.frame ;
 }
 
 UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
 
 if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
 {
 NSLog(@"Landscape");
 }else{
 NSLog(@"port");
 }
 }*/






/*
 [page6line setUserInteractionEnabled:YES];
 UITapGestureRecognizer *singleTap3 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(page6lineAction:)];
 [singleTap3 setNumberOfTapsRequired:1];
 [page6line addGestureRecognizer:singleTap3];
 
 
[NSTimer scheduledTimerWithTimeInterval:1  target:self selector:@selector(counterFire:) userInfo:nil repeats:NO];
 
[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
 
 } completion:^(BOOL finished){
 
 }];
 
 */
