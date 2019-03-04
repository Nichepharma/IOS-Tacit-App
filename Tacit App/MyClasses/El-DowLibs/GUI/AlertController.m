//
//  AlertController.m
//  Career Management Apps
//
//  Created by Yahia on 3/15/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import "AlertController.h"

@implementation AlertController

+(void)showAlertWithSingleButton :(NSString *)buttonTitle  presentOnViewController:(id)representOnView
                      alertTitle :(NSString *)str_Title alertMessage :(NSString*)str_message  {
    
    if (representOnView) {
        NSLog(@">>> %f",[representOnView view].frame.size.height);

        UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(str_Title, nil)
                                          message:NSLocalizedString(str_message, nil)
                                          preferredStyle:UIAlertControllerStyleActionSheet | UIAlertControllerStyleAlert];
    
    
    
//    UIAlertAction *cancelAction = [UIAlertAction
//                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
//                                   style:UIAlertActionStyleCancel
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       NSLog(@"Cancel action");
//                                   }];

        UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(buttonTitle, buttonTitle)
                               style:UIAlertActionStyleDefault
                               handler:nil];
    
        [alertController addAction:okAction];
    
        [representOnView presentViewController:alertController animated:YES completion:nil];
     }
    
}


@end
