//
//  SyncViewController.h
//  DashboardSQL
//
//  Created by Yahia on 2/23/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "Header.h"
#import "SendSyncSession.h"


@interface SyncViewController : UIViewController<UITableViewDelegate ,UITableViewDataSource ,sendSyncDelegate , UIGestureRecognizerDelegate>

@property (strong , nonatomic)NSMutableDictionary *sessionDetails ;

@property ( nonatomic) BOOL isComeFromHomeViewController ;
-(void)stopLoad ;
@end
