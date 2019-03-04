//
//  TaraProgressPie.m
//  TaraTestScroll
//
//  Created by Feras Ali Masoud on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaraProgressPie.h"

@implementation TaraProgressPie

@synthesize portions;
@synthesize subPies;


float offsetAngle ;
- (id)initWithFrame:(CGRect)frame andPortions:(NSMutableArray *)p
{
    
    self = [super initWithFrame:frame];
    if (self) {
        subPies = [[NSMutableArray alloc] initWithCapacity:3];
        
        offsetAngle=0;
        [self setPortions:p];
     
        for (int i=0; i<p.count; i++) {
            PieComponent *currentPortion = [portions objectAtIndex:i];
            SSPieProgressView *sp=[[SSPieProgressView alloc] initWithFrame:frame];
            [sp setProgress:0];
            [sp setPieBorderColor:[UIColor clearColor]];
            [sp setAngleOffset:offsetAngle];
            [sp setPieBackgroundColor:[UIColor clearColor]];
            [sp setPieFillColor:[currentPortion color]];
            [subPies addObject:sp];
            [self addSubview:[subPies objectAtIndex:i]];
            offsetAngle += [currentPortion progress]*360.0;

        }
    }
    return self;
}



@end
