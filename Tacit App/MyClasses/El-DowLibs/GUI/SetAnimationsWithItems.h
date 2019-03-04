//
//  SetAnimationsWithItems.h
//  Career Management Apps
//
//  Created by Yahia on 3/14/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SetAnimationsWithItems : NSObject
/*! >> Animations Type <<
 
 
 setFrameset
 
 
 setFrameWithPostion
 
 
 setFadeAnimations
 
 
 setDropeAnimations
 
 
 setBarAnimations
 
 
 setWidthAnimations
 
 
 moveToY
 
 
 moveToX

 setLeftFlip

 setRightFlip

 setUPFlip

 setDownFlip
 
 */
+(void)setAnimationsWithObject : (id) item withType :(NSString *)methodName animationWithDelay :(float)__Du ;
+(void)setAnimationsWithObjectMoveXorY : (id) item withType :(NSString *)methodName animationWithDelay :(float)__Du setNextMove : (float)f_Move;
+(void)setFrameWithObject: (id) item    setFirstFrame :(CGRect)frame1  toSecondFrame : (CGRect)frame2 animationWithDelay :(float)__Du ;
//+(void)setPostionWithObject: (id) item    setFirstFrame :(CGRect)frame1  toSecondFrame : (CGRect)frame2 animationWithDelay :(float)__Du ;


+(void)setAnimationsWithObjectChangeImages  : (id) item  toNewImage :(UIImage *)new_img2 withDelay : (float) __DU;
+(void)setAnimationsWithObjectChangeImagesWithoutAlpha : (id) item  toNewImage :(UIImage *)new_img2 withDelay : (float) __DU ;



+(void)setAnimationsWithLeftFlip : (id) item  withDelay : (float) __DU ;
+(void)setAnimationsWithRightFlip : (id) item  withDelay : (float) __DU;
+(void)setAnimationsWithUpFlip : (id) item withDelay : (float) __DU;
+(void)setAnimationsWithDownFlip : (id) item withDelay : (float) __DU;

@end
