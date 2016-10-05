//
//  Scroll.m
//  TacitPlan
//
//  Created by Yahia on 2/17/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import "_ScrollingView.h"
#import "Header.h"


@interface _ScrollingView()<UIScrollViewDelegate>{
@private   int pageNumber ;

}



@end
@implementation _ScrollingView
@synthesize sCrolling_CurrentView ;


- (id)initWithFrame:(CGRect)frame numberOFSlides : (char ) scViewNumber{

    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        pageNumber = 0 ;
    
        CGSize scrollViewContant = CGSizeMake(frame.size.width * scViewNumber , frame.size.height);
        // NSLog(@"Frame %@",NSStringFromCGRect(frame));
        // NSLog(@"Frame %@",NSStringFromCGSize(scrollViewContant) );
        
        [self setContentSize:scrollViewContant ];
        [self setPagingEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self setBounces:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self  setShowsHorizontalScrollIndicator:NO];
        //        [self setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
        [self setAutoresizesSubviews:NO];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self setCanCancelContentTouches:YES];
        [self setClipsToBounds:YES];	// default is NO, we want to restrict drawing within our scrollview
        
        [self setScrollEnabled:YES];
        [self setDelegate:self] ;

        
        
        //[[NSClassFromString([[[_Arr_Slide getSharedInstanceArray] getter_ArrayView] objectAtIndex:pageNumber]) alloc] initWithSlideNumber:pageNumber] ;
        [self addSubview:sCrolling_CurrentView];

    }
    return self;
}
-(void)setScrollViewBKG :(NSArray *)arr_BKG appName :(NSString *)appName {

            if (arr_BKG)
                for (int i=0; i<[arr_BKG count]; i++){
                    UIImageView *scV_BKG = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * (i) , 0, self.frame.size.width, self.frame.size.height)];
                    UIImage *imgScrollViewBKG = [Image loadimageFromDocumentWithName:[arr_BKG objectAtIndex:i] stringWithApplicationDidSelected:appName];
                    scV_BKG.image = imgScrollViewBKG;
                    [self addSubview:scV_BKG];
    
                }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    pageNumber = (self.contentOffset.x / self.frame.size.width);
    [sCrolling_CurrentView removeFromSuperview] ;
   //  sCrolling_CurrentView = [[NSClassFromString([[[_Arr_Slide getSharedInstanceArray] getter_ArrayView] objectAtIndex:pageNumber]) alloc] initWithSlideNumber:pageNumber] ;
    [scrollView addSubview: sCrolling_CurrentView];
    
    [self.sDelegate endScroll:pageNumber];

 
}

/*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    pageNumber = (self.contentOffset.x / self.frame.size.width);
    [self.sDelegate didScroll:pageNumber];
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        sCrolling_CurrentView.alpha  = 0 ;
    } completion:nil];
    
}


*/


@end

