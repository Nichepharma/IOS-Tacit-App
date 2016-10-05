//
//  NotificationViewController.h
//  Career Management Apps
//
//  Created by Yahia on 3/28/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController < UITableViewDataSource , UITableViewDelegate >
@property (setter=setReloadTable : ) UITableView *tv_notifcationData ;
@property(nonatomic, weak) IBOutlet UILabel *registeringLabel;

@end
