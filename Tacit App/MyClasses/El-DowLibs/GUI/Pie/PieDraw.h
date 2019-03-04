//  PieDraw.m
//  Created by Yahia
//  Copyright (c) 2014 nichepharma. All rights reserved.


#import <UIKit/UIKit.h>
#import "TaraProgressPie.h"

@interface PieDraw : UIView

@property(setter=setPieDiameter1: , getter=getPieDiameter1) double pieD1 ;
@property(setter=setPieDiameter2: , getter=getPieDiameter2) double pieD2 ;
@property(setter=setPieDiameter3: , getter=getPieDiameter3) double pieD3 ;

@property(setter=setPieWidth: , getter=getPieWidth ) float pie_W;
@property(setter=setPieHeight: , getter=getPieHeight ) float pie_H;
@property(setter=setDelay: , getter=getDelay ) double delay;
@property(setter=setPieX: , getter=getPieX ) float pie_X;
@property(setter=setPieY: , getter=getPieY ) float pie_Y;
@property(setter=setPie1Background: , getter=getPie1Background) id pie1Coloe ;
@property(setter=setPie2Background: , getter=getPie2Background) id pie2Coloe ;
@property(setter=setPie3Background: , getter=getPie3Background) id pie3Coloe ;
@property(setter=setPieTransform : ,getter=getPieTransform) float pie_transform ;
-(UIView *) drawPie ;

@end
