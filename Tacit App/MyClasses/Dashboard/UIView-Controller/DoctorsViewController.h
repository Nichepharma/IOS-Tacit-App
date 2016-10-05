//
//  DoctorsViewController.h
//  DashboardSQL
//
//  Created by Yahia on 2/22/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//


#import "Header.h"

@interface DoctorsViewController : UIViewController<UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>


@property double doc_totalTime;
@property NSString  *doc_ACC;
@property NSString *str_SesstionID;
@end
