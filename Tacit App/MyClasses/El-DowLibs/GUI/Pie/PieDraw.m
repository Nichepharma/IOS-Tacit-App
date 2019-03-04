//  PieDraw.m
//  Created by Yahia 
//  Copyright (c) 2014 nichepharma. All rights reserved.


#import "PieDraw.h"

@implementation PieDraw

NSMutableArray *portions;
TaraProgressPie *pie;
int pieFlag[3]={0,1,1};
int iFlag=1;
int pieNumbers = 3;


-(UIView *) drawPie
{
    //NSLog(@"%s", __FUNCTION__);
    portions=[[NSMutableArray alloc] initWithCapacity:pieNumbers];
    PieComponent *p=[[PieComponent alloc] init];
    p.progress=[self getPieTransform];
    [portions addObject:p];
   
    
    p=[[PieComponent alloc] init];
    p.progress= [self getPieDiameter1];
    [portions addObject:p];
    
     p=[[PieComponent alloc] init];
    if ([self getPieDiameter2] == 0 ) {
        p.progress= 1 - [self getPieDiameter1];
    }else {
        p.progress= [self getPieDiameter2];
    }
   
    [portions addObject:p];
    
    if ([self getPieDiameter3] != 0 ) {
        p=[[PieComponent alloc] init];
        p.progress= [self getPieDiameter3] ;
        [portions addObject:p];
        pieNumbers = 4;
    }

    
    PieComponent *c=[portions objectAtIndex:0]  ;

    c=[portions objectAtIndex:1] ;
    c.color= [self getPie1Background];
    //[UIColor colorWithRed:.12 green:.713 blue:.9725 alpha:1];
    if ([portions count] > 2){
        c=[portions objectAtIndex:2] ;
        c.color= [self getPie2Background];
    }
    if ([portions count] > 3){
        c=[portions objectAtIndex:3] ;
        c.color= [self getPie3Background];
        
    }
   
    
    pie = [[TaraProgressPie alloc] initWithFrame:
                        CGRectMake([self getPieX],  [self getPieY], [self getPieWidth], [self getPieHeight])
                                     andPortions:portions];
    [self addSubview:pie];
   
//    self.alpha = 0 ;

    [NSTimer scheduledTimerWithTimeInterval: 0.000003f
                                     target: self
                                   selector: @selector(animateProgress:)
                                   userInfo:pie
                                    repeats: YES];
                
    
   
    
    return pie ;
}

-(void) animateProgress:(NSTimer *) aTimer
{
    //NSLog(@"%s", __FUNCTION__);
    TaraProgressPie *p= aTimer.userInfo;
    for (int i=0;i<pieNumbers;i++)
    {
        if ([[p portions] count] > i && [p.subPies count] >  i) {
            PieComponent *comp = [[p portions] objectAtIndex:i];
            SSPieProgressView *sp = [p.subPies objectAtIndex:i];
            SSPieProgressView *sp_1;
            if (i>0) sp_1=[p.subPies objectAtIndex:i-1];
            if (sp.progress < comp.progress-.001)
            {
                //if(i>0 && sp_1.progress>=[[p.portions objectAtIndex:i-1] progress]-.001)    sp.progress += .005;
                if(pieFlag[i]==1)    sp.progress += .01;
                //  else if (i == 0 )sp.progress += .005;
                
            }
        }
      
    }
}




@end
