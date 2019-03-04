//
//  Scroll.h
//  TacitPlan
//
//  Created by Yahia on 2/17/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol scrollingDelegate
@optional
-(void)didScroll :(int)slideNumber ;
@required
-(void)endScroll :(int)slideNumber ;
@end

@interface _ScrollingView : UIScrollView
@property (nonatomic, weak)id<scrollingDelegate> sDelegate ;
//-(id)initWithFrame:(CGRect)frame scrollViewBackGround : (NSArray *) arr_ScrollView_BKG ;

- (id)initWithFrame:(CGRect)frame numberOFSlides : (char ) scViewNumber ;

//-(void)setScrollViewBKG :(NSArray *)arr_BKG appName :(NSString *)appName  ;

@property (nonatomic, strong) UIView *sCrolling_CurrentView ;

-(void)handelScrollViewBackgroundImage ;













//
//- (id)initWithFrame : (CGRect)frame scrollViewBackGround : (NSArray *) arr_ScrollView_BKG
//menuButtonImageName  :(void (^) (NSDictionary *response) )handler ;
//
@end
