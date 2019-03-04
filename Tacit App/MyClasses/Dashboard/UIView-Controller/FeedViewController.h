//
//  FeedViewController.h
//  DashboardSQL
//
//  Created by Yahia on 2/24/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//


#import "Header.h"
@interface FeedViewController : UIViewController <UITextFieldDelegate>
@property (strong,nonatomic) NSString *strVisitTime , *strfeed_sample, *strfeed_remark, *strfeed_objection;
@property BOOL _HomeViewStatus , _isPharmacy;
@property(strong , nonatomic) NSString *strAPP_name ;
@property(strong , nonatomic) NSString *feedback_sampleTypeSelected  ;

@end
