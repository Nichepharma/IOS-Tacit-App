//
//  AppDetailsController.h
//  Tacit App
//
//  Created by Yahia El-Dow on 10/3/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDetailCustomCell.h"


@interface AppDetailsController : UIViewController <UITableViewDelegate ,UITableViewDataSource , AppDetailsDelegate >
@property (weak, nonatomic) IBOutlet UITableView *appDetail_TV;
@end
