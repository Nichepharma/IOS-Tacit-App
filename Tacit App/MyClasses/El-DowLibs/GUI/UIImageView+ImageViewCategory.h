//
//  UIImageView+ImageViewCategory.h
//  Omiz
//
//  Created by Yahia on 2/23/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageViewCategory)


-(UIImageView *)setInCenter  ;
-(UIImageView *)setXCenter ;
-(UIImageView *)setYCenter ;
-(UIImageView *)setRightCorner  ;
-(UIImageView *)setButtomCorner ;

-(UIImageView *)setWidthAnimations ;
-(UIImageView *)setWidthAnimations : (float) _Delay ;

-(UIImageView *)setDropeAnimations;
-(UIImageView *)setDropeAnimationsWithDelay : (float) _Delay ;


-(UIImageView *)setBarAnimations ;
-(UIImageView *)setBarAnimationsWithDelay : (float) _Delay ;

-(UIImageView *)setFadeAnimations ;
-(UIImageView *)setFadeAnimationsWithDelay : (float) _Delay ;

-(UIImageView *)setAnimation_MoveFromCurrent_Y_to_Y_Postion :(float) _YPostion ;
-(UIImageView *)setAnimation_MoveFromCurrent_Y_to_Y_Postion :(float) _YPostion withDelay:(float)_Delay ;

-(UIImageView *)setAnimation_MoveFromCurrent_X_to_X_Postion :(float) _XPostion ;
-(UIImageView *)setAnimation_MoveFromCurrent_X_to_X_Postion :(float) _XPostion withDelay:(float)_Delay ;
    

-(UIImageView *)setAnimationWithFrameWithFrame :(CGRect) frame1  to_NEW_Frame  :(CGRect) frame2 withDelay:(float)_Delay ;



-(UIImageView *)changeImageWithAnimationsToNewImage : (UIImage *)newImg withDelay:(float)_Delay  ;
@end
