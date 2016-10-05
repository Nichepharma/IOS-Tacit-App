//
//  Activity_indicator_loading.m
//  CollectionView
//
//  Created by Yahia on 11/23/14.
//  Copyright (c) 2014 nichepharma. All rights reserved.
//

#import "Activity_indicator_loading.h"

@implementation Activity_indicator_loading
UIActivityIndicatorView    *spinner ;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter:CGPointMake(frame.size.width/2.0, frame.size.height/2.0)]; // I do this because I'm in landscape mode
        spinner.backgroundColor =[UIColor clearColor];
        spinner.color=[UIColor blackColor];
        [self addSubview:spinner]; // spinner is not visible until started
           [spinner startAnimating];
        
        
    }
    return self;
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 1024, 768)];
    if (self) {
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0)]; // I do this because I'm in landscape mode
        spinner.backgroundColor =[UIColor clearColor];
        spinner.color=[UIColor blackColor];
        [self addSubview:spinner]; // spinner is not visible until started
        [spinner startAnimating];
        
        
    }
    return self;
}



-(void)stop{
    
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
  
    
}



@end
