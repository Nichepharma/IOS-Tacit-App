//
//  SetAnimationsWithItems.m
//  Career Management Apps
//
//  Created by Yahia on 3/14/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import "SetAnimationsWithItems.h"
#import "UIImageView+ImageViewCategory.h"
@implementation SetAnimationsWithItems

+(void)setAnimationsWithObject : (id) item withType :(NSString *)methodName animationWithDelay :(float)__Du {
 
    if (methodName){
    if ([methodName isEqualToString:@"setFadeAnimations"]) {
        
        [item setFadeAnimationsWithDelay:__Du];
    }else if ([methodName isEqualToString:@"setDropeAnimations"]){
        [item setDropeAnimationsWithDelay:__Du];
    }else if ([methodName isEqualToString:@"setBarAnimations"]){
        [item setBarAnimationsWithDelay:__Du];
    }else if ([methodName isEqualToString:@"setWidthAnimations"]){
        [item setWidthAnimations:__Du];
    }
}
}

+(void)setAnimationsWithObjectChangeImages  : (id) item  toNewImage :(UIImage *)new_img2 withDelay : (float) __DU{

    [item changeImageWithAnimationsToNewImage:new_img2 withDelay:__DU];

}
+(void)setAnimationsWithObjectMoveXorY : (id) item withType :(NSString *)methodName animationWithDelay :(float)__Du setNextMove : (float)f_Move{
    
    
    if ([methodName isEqualToString:@"moveToY"]){
        [item setAnimation_MoveFromCurrent_Y_to_Y_Postion:f_Move withDelay:__Du];
    }else if ([methodName isEqualToString:@"moveToX"]){
        [item setAnimation_MoveFromCurrent_X_to_X_Postion:f_Move withDelay:__Du];
        
    }
}

+(void)setFrameWithObject: (id) item    setFirstFrame :(CGRect)frame1  toSecondFrame : (CGRect)frame2
           animationWithDelay :(float)__Du {
    [item setAnimationWithFrameWithFrame:frame1 to_NEW_Frame:frame2 withDelay:__Du];
   
}





/*
 
 
 -(UIImageView *)setInCenter  ;
 -(UIImageView *)setXCenter ;
 -(UIImageView *)setYCenter ;
 -(UIImageView *)setRightCorner  ;
 -(UIImageView *)setButtomCorner ;
 

 -(UIImageView *)setWidthAnimations : (float) _Delay ;
 

 -(UIImageView *)setDropeAnimationsWithDelay : (float) _Delay ;
 
 
 -(UIImageView *)setBarAnimationsWithDelay : (float) _Delay ;
 

 -(UIImageView *)setFadeAnimationsWithDelay : (float) _Delay ;
 

 -(UIImageView *)setAnimation_MoveFromCurrent_Y_to_Y_Postion :(float) _YPostion withDelay:(float)_Delay ;
 
 -(UIImageView *)setAnimation_MoveFromCurrent_X_to_X_Postion :(float) _XPostion withDelay:(float)_Delay ;

 
 */
@end
