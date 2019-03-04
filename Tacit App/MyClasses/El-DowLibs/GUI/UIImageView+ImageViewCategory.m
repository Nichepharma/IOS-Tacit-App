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
    
    [UIView animateWithDuration:1 delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
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
    
    [UIView animateWithDuration:1 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
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
    
    [UIView animateWithDuration:1 delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self .frame = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y
                                 , self.frame.size.width,
                                 _CurrentHeight);
    } completion:nil];
    
    return self ;
}


-(UIImageView *)setDropeAnimationsWithDelay :(float) _Delay{

    int _CurrentHeight = self.frame.size.height ;
    
    self .frame = CGRectMake( self.frame.origin.x,
                             self.frame.origin.y
                             , self.frame.size.width , 0);
    
    [UIView animateWithDuration:1 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self .frame = CGRectMake(self.frame.origin.x,
                                 self.frame.origin.y
                                 , self.frame.size.width,
                                 _CurrentHeight);
    } completion:nil];
    
    return self ;
}

-(UIImageView*)setWidthBarAnimations: (float) _Delay{
    
    self.hidden = FALSE;//Show the image view
    
    //Create a shape layer that we will use as a mask for the waretoLogoLarge image view
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    CGFloat maskHeight = self.layer.bounds.size.height;
    CGFloat maskWidth  = self.layer.bounds.size.width ;
    
    CGPoint centerPoint = CGPointMake(0, 0);
    
    //Make the radius of our arc large enough to reach into the corners of the image view.
    CGFloat radius = sqrtf(maskWidth * maskWidth + maskHeight * maskHeight);
    
    //Don't fill the path, but stroke it in black.
    maskLayer.fillColor = [[UIColor clearColor] CGColor];
    maskLayer.strokeColor = [[UIColor blackColor] CGColor];
    
    maskLayer.lineWidth = radius; //Make the line thick enough to completely fill the circle we're drawing
    
    CGMutablePathRef arcPath = CGPathCreateMutable();
    
    //Move to the starting point of the arc so there is no initial line connecting to the arc
    CGPathMoveToPoint(arcPath, nil, centerPoint.x, centerPoint.y-radius/2);
    
    //Create an arc at 1/2 our circle radius, with a line thickess of the full circle radius
    CGPathAddArc(arcPath,
                 nil,
                 self.frame.size.width      ,
                 self.frame.size.width ,
                 0 ,
                 self.frame.size.width ,
                 0  ,
                 YES);
    
    maskLayer.path = arcPath;
    
    //Start with an empty mask path (draw 0% of the arc)
    maskLayer.strokeEnd = 0.0;
    
    CFRelease(arcPath);
    
    //Install the mask layer into out image view's layer.
    self.layer.mask = maskLayer;

    //Create an animation that increases the stroke length to 1, then reverses it back to zero.
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 3;
    //    swipe.delegate = self;
    //    [swipe setValue: theBlock forKey: kAnimationCompletionBlock];
    
    animation.timingFunction = [CAMediaTimingFunction
                            functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.autoreverses = NO;
    animation.toValue = [NSNumber numberWithFloat: 1.0];
    animation.beginTime = CACurrentMediaTime() + _Delay ;
    [maskLayer addAnimation: animation forKey: @"strokeEnd"];
    return self ;
}

-(UIImageView *)setWidthAnimations{
    
    int _CurrentWidth = self.frame.size.width ;
    
    self .frame = CGRectMake( self.frame.origin.x  ,
                              self.frame.origin.y,
                                0,
                                self.frame.size.height );
    
   [UIView animateWithDuration:1 delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
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
    
    [UIView animateWithDuration:1 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self .frame = CGRectMake(self.frame.origin.x ,
                                 self.frame.origin.y ,
                                 _CurrentWidth   ,
                                 self.frame.size.height);
        
    } completion:nil];
    
    return self ;
}







-(UIImageView *)setFadeAnimations{
    [self setAlpha : 0 ];
    [UIView animateWithDuration:1 delay : 0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
         [self setAlpha : 1 ];
    } completion:nil];
     return self ;
}-(UIImageView *)setFadeAnimationsWithDelay : (float) _Delay{
     [self setAlpha : 0 ];
    [UIView animateWithDuration:1 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
         [self setAlpha : 1 ];
    } completion:nil];
    
    
    
       return self ;
}


-(UIImageView *)setFadeOutAnimations{
    [self setAlpha : 1 ];
    [UIView animateWithDuration:1 delay : 0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        [self setAlpha : 0 ];
    } completion:nil];
    return self ;
}-(UIImageView *)setFadeOutAnimations : (float) _Delay{
    [self setAlpha : 1 ];
    [UIView animateWithDuration:1 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        [self setAlpha : 0 ];
    } completion:nil];
    
    return self ;
}




-(UIImageView *)setAnimation_MoveFromCurrent_Y_to_Y_Postion :(float) _YPostion{
    
    [UIView animateWithDuration:1 delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self.frame = CGRectMake(self.frame.origin.x , _YPostion
                                , self.frame.size.width, self.frame.size.height);
    } completion:nil];
    
    return self ;
}-(UIImageView *)setAnimation_MoveFromCurrent_Y_to_Y_Postion :(float) _YPostion withDelay:(float)_Delay{
    
    [UIView animateWithDuration:1 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
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
    
   [UIView animateWithDuration:1 delay : _Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        [self setFrame: frame2 ]; [self setAlpha:1 ];
 } completion:nil];
    
    return self ;
}-(UIImageView *)setAnimation_MoveFromCurrent_X_to_X_Postion :(float) _XPostion{
    
    [UIView animateWithDuration:1 delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self.frame = CGRectMake( _XPostion, self.frame.origin.y
                                , self.frame.size.width, self.frame.size.height);
    } completion:nil];
    
    return self ;
}-(UIImageView *)setAnimation_MoveFromCurrent_X_to_X_Postion :(float) _XPostion withDelay:(float)_Delay{
    
    [UIView animateWithDuration:1 delay :_Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self.frame = CGRectMake( _XPostion, self.frame.origin.y
                                , self.frame.size.width, self.frame.size.height);
    } completion:nil];
    
    return self ;
}
-(UIImageView *)changeImageWithAnimationsToNewImage : (UIImage *)newImg withDelay:(float)_Delay {

    [UIView animateWithDuration:1 delay :_Delay options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
       self.alpha = 0 ;
    } completion:^ (BOOL finished)
     {
         [UIView animateWithDuration:1 delay :0  options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                self.image = newImg ;
                self.alpha = 1 ;
         } completion:nil];
         }];



    return self ;
}
-(UIImageView *)changeImageWithAnimationsToNewImageWithoutFade : (UIImage *)newImg withDelay:(float)_Delay {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"contents"];
    fadeAnim.fromValue = (__bridge id)self.image.CGImage;
    fadeAnim.toValue = (__bridge id)newImg.CGImage;
    fadeAnim.duration = 2.0;
    [self.layer addAnimation:fadeAnim forKey:@"contents"];
    self.layer.contents = (__bridge id)newImg.CGImage;
    return self ;
}



-(UIImageView *)imageWithLeftFlipWithDelay:(float)_Delay {

     CALayer *sideALayer = self.layer;
     CALayer *sideBLayer = self.layer;
     CALayer *containerLayer = self.layer;

     sideALayer.opacity = 1;
     sideBLayer.opacity = 0;
     sideBLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
     containerLayer.transform = CATransform3DIdentity;


     CATransform3D perspectiveTransform = CATransform3DIdentity;
     perspectiveTransform.m34 = -1.0 / self.frame.size.width;
     [UIView animateKeyframesWithDuration:1 delay:_Delay options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{

          [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
               sideALayer.opacity = 0;
               containerLayer.transform = CATransform3DConcat(perspectiveTransform,CATransform3DMakeRotation(M_PI_2, 0, 1, 0));
          }];
          [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
               sideBLayer.opacity = 1;
               containerLayer.transform = CATransform3DConcat(perspectiveTransform, CATransform3DMakeRotation(M_PI, 0, 0, 0));
          }];
     } completion:nil];

     return self ;
}

-(UIImageView *)imageWithRightFlipWithDelay:(float)_Delay {
     
     CALayer *sideALayer = self.layer;
     CALayer *sideBLayer = self.layer;
     CALayer *containerLayer = self.layer;
     
     sideALayer.opacity = 1;
     sideBLayer.opacity = 0;
     sideBLayer.transform = CATransform3DMakeRotation(M_PI, 1, 1, 0);
     containerLayer.transform = CATransform3DIdentity;
     
     
     CATransform3D perspectiveTransform = CATransform3DIdentity;
     perspectiveTransform.m34 = -1.0 / self.frame.size.width;
     [UIView animateKeyframesWithDuration:1 delay:_Delay options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
          
          [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
               sideALayer.opacity = 0;
               containerLayer.transform = CATransform3DConcat(perspectiveTransform,CATransform3DMakeRotation(M_PI_2, 1, 1, 0));
          }];
          [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
               sideBLayer.opacity = 1;
               containerLayer.transform = CATransform3DConcat(perspectiveTransform, CATransform3DMakeRotation(M_PI, 0, 0, 0));
          }];
     } completion:nil];
     
     return self ;
}

-(UIImageView *)imageWithUpFlipWithDelay:(float)_Delay {
     [self setAlpha : 0 ];
     [UIView animateWithDuration:1 delay :_Delay options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(void) {
          self.layer.transform = CATransform3DMakeRotation(M_PI,-1.0,1.0,1.0);

     } completion:^(BOOL finished){
          // code to be executed when flip is completed
     }];
     [UIView animateWithDuration:1 delay :_Delay options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(void) {
          self.layer.transform = CATransform3DMakeRotation(M_PI,0.0,0.0,0.0);
     } completion:^(BOOL finished){
          // code to be executed when flip is completed
     }];
     return self ;
}

-(UIImageView *)imageWithDownFlipWithDelay:(float)_Delay {
     CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
     rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0;
     rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -2, 1.0f, 0.0f, 0.0f);
     self.layer.transform = rotationAndPerspectiveTransform;

     [UIView animateWithDuration:1.0 animations:^{
          self.layer.transform = CATransform3DMakeRotation(M_PI,0.0,0.0,0.0);
     } completion:^(BOOL finished){
          // code to be executed when flip is completed
     }];
     return self;
}




@end
