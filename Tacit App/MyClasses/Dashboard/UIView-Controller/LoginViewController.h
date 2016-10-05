
//  DashboardSQL
//
//  Created by Yahia on 2/18/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Header.h"
#import "SoapRequest.h"

@interface LoginViewController : UIViewController<SoapRequestDelegate, UITextFieldDelegate>
{

}
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;


@end
