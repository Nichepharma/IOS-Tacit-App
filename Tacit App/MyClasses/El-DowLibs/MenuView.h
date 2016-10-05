//
//  MenuView.h
//  Career Management Apps
//
//  Created by Yahia on 3/28/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol _MenuDelegate
@required
//! when Touched on Menu Button
-(void)didSelectMenuItem :(int)goToSlideNumber ;

@end




@interface MenuView : NSObject
@property (nonatomic, weak) id <_MenuDelegate> menuDelegate ;
-(UIView *) getMenuView  ;


@end
