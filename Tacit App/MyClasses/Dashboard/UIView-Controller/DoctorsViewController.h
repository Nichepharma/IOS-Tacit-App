//
//  DoctorsViewController.h
//  DashboardSQL
//
//  Created by Yahia on 2/22/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//


#import "Header.h"
#import "BeforeDoctorView.h"
@interface DoctorsViewController : UIViewController<UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate , _BeforeDocView >

@property NSInteger visit_Type ;
@property double doc_totalTime;
@property NSString  *doc_ACC;
@property NSString *str_SesstionID;
@property BOOL reUpdateSession ;
@end
