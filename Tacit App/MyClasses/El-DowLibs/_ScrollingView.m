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
NSString *applicationName ;
UIImageView *leftBackgroundImage , *currentBackgroundImage , *rightBackgroundImage ;

int numberOfScroll  = 0 ;
NSArray *arr_BKG ;


- (id)initWithFrame:(CGRect)frame numberOFSlides : (char ) scViewNumber{

    
    self = [super initWithFrame:frame];
    
    if (self) {
        numberOfScroll = scViewNumber;
        pageNumber = 0 ;
        arr_BKG =  [[ApplicationData getSharedInstance] getScrollViewBKG]  ;
       
        [leftBackgroundImage removeFromSuperview];
        [currentBackgroundImage removeFromSuperview] ;
        [rightBackgroundImage  removeFromSuperview];
        
        leftBackgroundImage = nil ;
        currentBackgroundImage = nil ;
        rightBackgroundImage = nil ;
        
        CGSize scrollViewContant = CGSizeMake(frame.size.width * scViewNumber , frame.size.height);
        
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

        
       applicationName  = [[ApplicationData getSharedInstance] getAppName] ;
        //[[NSClassFromString([[[_Arr_Slide getSharedInstanceArray] getter_ArrayView] objectAtIndex:pageNumber]) alloc] initWithSlideNumber:pageNumber] ;
        
        
        [self handelScrollViewBackgroundImage];
        [self addSubview:sCrolling_CurrentView];

     

  
    }
    return self;
}
/*
-(void)setScrollViewBKG :(NSArray *)arr_BKG appName :(NSString *)appName {
    UIImage *imgScrollViewBKG ;
            if (arr_BKG)
                for (int i=0; i<[arr_BKG count]; i++){
                    UIImageView *scV_BKG = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * (i) , 0, self.frame.size.width, self.frame.size.height)];
                    imgScrollViewBKG = [Image loadimageFromDocumentWithName:[arr_BKG objectAtIndex:i] stringWithApplicationDidSelected:appName];
                    scV_BKG.image = imgScrollViewBKG;
                    [self insertSubview:scV_BKG atIndex:i] ;

                }
}
*/

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    pageNumber = (self.contentOffset.x / self.frame.size.width);
    [self handelScrollViewBackgroundImage];
    
      [sCrolling_CurrentView removeFromSuperview] ;
   //  sCrolling_CurrentView = [[NSClassFromString([[[_Arr_Slide getSharedInstanceArray] getter_ArrayView] objectAtIndex:pageNumber]) alloc] initWithSlideNumber:pageNumber] ;
    [scrollView addSubview: sCrolling_CurrentView];
    
    [self.sDelegate endScroll:pageNumber];

 
}


-(void)handelScrollViewBackgroundImage {
   
    int leftBackgroundImageSLideNumber    = pageNumber  - 1 ;
    int currentBackgroundImageSLideNumber = pageNumber ;
    int rightBackgroundImageSLideNumber   = pageNumber + 1 ;


    if (!leftBackgroundImage || !currentBackgroundImage || !rightBackgroundImage) {
        
        leftBackgroundImage = [[UIImageView alloc] init];
        currentBackgroundImage = [[UIImageView alloc] init];
        rightBackgroundImage = [[UIImageView alloc] init];
        
        [self addSubview:leftBackgroundImage] ;
        [self addSubview:currentBackgroundImage ] ;
        [self addSubview:rightBackgroundImage] ;
        
        
    }
    
    if (leftBackgroundImageSLideNumber != -1) {
        leftBackgroundImage.frame = CGRectMake(self.frame.size.width * (leftBackgroundImageSLideNumber) , 0, self.frame.size.width, self.frame.size.height) ;
        leftBackgroundImage.image =  [Image loadimageFromDocumentWithName:[arr_BKG objectAtIndex:leftBackgroundImageSLideNumber] stringWithApplicationDidSelected:applicationName] ;
    }
    
    
    
    currentBackgroundImage.frame = CGRectMake(self.frame.size.width * (currentBackgroundImageSLideNumber) , 0, self.frame.size.width, self.frame.size.height) ;
    currentBackgroundImage.image =  [Image loadimageFromDocumentWithName:[arr_BKG objectAtIndex:currentBackgroundImageSLideNumber] stringWithApplicationDidSelected:applicationName] ;
    
    if (rightBackgroundImageSLideNumber < numberOfScroll) {
        rightBackgroundImage.frame = CGRectMake(self.frame.size.width * (rightBackgroundImageSLideNumber) , 0, self.frame.size.width, self.frame.size.height) ;
            rightBackgroundImage.image =  [Image loadimageFromDocumentWithName:[arr_BKG objectAtIndex:rightBackgroundImageSLideNumber] stringWithApplicationDidSelected:applicationName] ;
        
    }
    
    
    
 
   
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    pageNumber = (self.contentOffset.x / self.frame.size.width);
//    [self.sDelegate didScroll:pageNumber];
    
//    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
//        sCrolling_CurrentView.alpha  = 0 ;
//    } completion:nil];
    
}





@end

