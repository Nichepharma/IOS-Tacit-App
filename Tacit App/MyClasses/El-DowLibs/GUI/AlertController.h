//
//  AlertController.h
//  Career Management Apps
//
//  Created by Yahia on 3/15/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertController : NSObject
+(void)showAlertWithSingleButton :(NSString *)buttonTitle  presentOnViewController:(id)representOnView
                      alertTitle :(NSString *)str_Title alertMessage :(NSString*)str_message ;
@end
