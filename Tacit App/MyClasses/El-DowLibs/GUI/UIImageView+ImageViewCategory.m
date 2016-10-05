//
//  UIImageView+ImageViewCategory.m
//  Omiz
//
//  Created by Yahia on 2/23/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import "UIImageView+ImageViewCategory.h"

@implementation UIImageView (ImageViewCategory)

-(UIImageView *)setInCenter  {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.center = CGPointMake(screenWidth/2, screenHeight/2);
    return self ;
}-(UIImageView *)setXCenter  {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.frame = CGRectMake((screenWidth/2) - (self.frame.size.width / 2 ),
                            self.frame.origin.y ,
                            self.frame.size.width, self.frame.size.height) ;

    return self ;
}-(UIImageView *)setYCenter {
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    self.frame = CGRectMake(self.frame.origin.x ,
                            (screenHeight/2) - (self.frame.size.height / 2 ),
                            self.frame.size.width, self.frame.size.height) ;
    return self ;
}-(UIImageView *)setRightCorner  {
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.frame = CGRectMake(screenWidth - self.frame.size.width , self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    return self ;
}-(UIImageView *)setButtomCorner  {
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    self.frame = CGRectMake(    self.frame.origin.x     ,
                                screenHeight - self.frame.size.height     ,
                                self.frame.size.width   ,
                                self.frame.size.height  );
    return self ;
}

//-------------------------- Animations ---------------------------//
-(UIImageView *)setBarAnimations{
    
     int _CurrentHeight = self.frame.size.height ;
  
    self .frame = CGRectMake( self.frame.origin.x,
                                    self.frame.origin.y + _CurrentHeight
                                    , self.frame.size.width , 0);
    
    [UIView animateWithDuration:1.3 delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self .frame = CGRectMake(self.frame.origin.x,
                                       self.frame.origin.y + (self.frame.size.height - _CurrentHeight )
                                        , self.frame.size.width, _CurrentHeight);
    } completion:nil];
    
    return self ;
}-(UIImageView *)setBarAnimationsWithDelay : (float) _Delay{
    
    int _CurrentHeight = self.frame.size.height ;
    
    self .frame = CGRectMake( self.frame.origin.x,
                             self.frame.origin.y + _CurrentHeight
                             , self.frame.size.width , 0);
    
    [UIView animateWithDuration:1.3 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self .frame = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y + (self.frame.size.height - _CurrentHeight )
                                 , self.frame.size.width,
                                 _CurrentHeight);
    } completion:nil];
    
    return self ;
}

-(UIImageView *)setDropeAnimations{
    
    int _CurrentHeight = self.frame.size.height ;
    
    self .frame = CGRectMake( self.frame.origin.x,
                             self.frame.origin.y
                             , self.frame.size.width , 0);
    
    [UIView animateWithDuration:1.3 delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self .frame = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y
                                 , self.frame.size.width,
                                 _CurrentHeight);
    } completion:nil];
    
    return self ;
}


-(UIImageView *)setDropeAnimationsWithDelay : (float) _Delay{

    int _CurrentHeight = self.frame.size.height ;
    
    self .frame = CGRectMake( self.frame.origin.x,
                             self.frame.origin.y
                             , self.frame.size.width , 0);
    
    [UIView animateWithDuration:1.3 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self .frame = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y
                                 , self.frame.size.width,
                                 _CurrentHeight);
    } completion:nil];
    
    return self ;
}-(UIImageView *)setWidthAnimations{
    
    int _CurrentWidth = self.frame.size.width ;
    
    self .frame = CGRectMake( self.frame.origin.x  ,
                              self.frame.origin.y,
                                0,
                                self.frame.size.height );
    
   [UIView animateWithDuration:1.3 delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self .frame = CGRectMake(self.frame.origin.x ,
                                 self.frame.origin.y ,
                                  _CurrentWidth   ,
                                 self.frame.size.height);
        
    } completion:nil];
    
    return self ;
}-(UIImageView *)setWidthAnimations : (float) _Delay{
    
    int _CurrentWidth = self.frame.size.width ;
    
    self .frame = CGRectMake( self.frame.origin.x  ,
                             self.frame.origin.y,
                             0,
                             self.frame.size.height );
    
    [UIView animateWithDuration:1.3 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self .frame = CGRectMake(self.frame.origin.x ,
                                 self.frame.origin.y ,
                                 _CurrentWidth   ,
                                 self.frame.size.height);
        
    } completion:nil];
    
    return self ;
}







-(UIImageView *)setFadeAnimations{
    [self setAlpha : 0 ];
    [UIView animateWithDuration:1.3 delay : 0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
         [self setAlpha : 1 ];
    } completion:nil];
     return self ;
}-(UIImageView *)setFadeAnimationsWithDelay : (float) _Delay{
     [self setAlpha : 0 ];
    [UIView animateWithDuration:1.3 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
         [self setAlpha : 1 ];
    } completion:nil];
    
    
    
       return self ;
}
-(UIImageView *)setAnimation_MoveFromCurrent_Y_to_Y_Postion :(float) _YPostion{
    
    [UIView animateWithDuration:1.3 delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self.frame = CGRectMake(self.frame.origin.x , _YPostion
                                , self.frame.size.width, self.frame.size.height);
    } completion:nil];
    
    return self ;
}-(UIImageView *)setAnimation_MoveFromCurrent_Y_to_Y_Postion :(float) _YPostion withDelay:(float)_Delay{
    
    [UIView animateWithDuration:1.3 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
      self.frame = CGRectMake(self.frame.origin.x , _YPostion
                              , self.frame.size.width, self.frame.size.height);
    } completion:nil];

    return self ;
}


//! set manual CGRectMake x , y , W , H and readd new CGRectMake Value 
-(UIImageView *)setAnimationWithFrameWithFrame :(CGRect) frame1  to_NEW_Frame  :(CGRect) frame2
    withDelay:(float)_Delay{
    [self setAlpha:0 ];
    [self setFrame:frame1 ];
    
   [UIView animateWithDuration:1.3 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        [self setFrame: frame2 ]; [self setAlpha:1 ];
 } completion:nil];
    
    return self ;
}-(UIImageView *)setAnimation_MoveFromCurrent_X_to_X_Postion :(float) _XPostion{
    
    [UIView animateWithDuration:1.3 delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self.frame = CGRectMake( _XPostion, self.frame.origin.y
                                , self.frame.size.width, self.frame.size.height);
    } completion:nil];
    
    return self ;
}-(UIImageView *)setAnimation_MoveFromCurrent_X_to_X_Postion :(float) _XPostion withDelay:(float)_Delay{
    
    [UIView animateWithDuration:1.3 delay :_Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self.frame = CGRectMake( _XPostion, self.frame.origin.y
                                , self.frame.size.width, self.frame.size.height);
    } completion:nil];
    
    return self ;
}
-(UIImageView *)changeImageWithAnimationsToNewImage : (UIImage *)newImg withDelay:(float)_Delay {

    [UIView animateWithDuration:1.3 delay :_Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
       self.alpha = 0 ;
    } completion:^ (BOOL finished)
     {
         [UIView animateWithDuration:1.3 delay :0  options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                self.image = newImg ;
                self.alpha = 1 ;
         } completion:nil];
         }];


    return self ;
}

@end
