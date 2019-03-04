//
//  BeforeDoctorView.h
//  Atimos
//
//  Created by Yahia on 1/3/16.
//  Copyright © 2016 nichepharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol _BeforeDocView <NSObject>
@optional
-(IBAction)goToSync:(id)sender ;
@optional
-(IBAction)reloadDoctorView:(id)sender ;
@optional
-(IBAction)beforeDocList_backToHome:(id)sender ;



@end
@interface BeforeDoctorView : UIView
-(id)initWithReload; 
@property (strong,nonatomic) id<_BeforeDocView> _BDoc_delegate;

@end
