//
//  Label.m
//  LendoMax
//
//  Created by Yahia on 5/21/14.
//  Copyright (c) 2014 nichepharma. All rights reserved.
//

#import "Label.h"

@implementation Label

- (id)initWithFrame:(CGRect)frame :(NSString *)Text :(int)size
{
    self = [super initWithFrame:frame];
    if (self) {
        //UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(160,295, 70, 50)];
        self.text=Text;
        self.backgroundColor = [UIColor clearColor];
        self.textColor=[UIColor blackColor];
        self.font = [UIFont fontWithName:@"arial" size:size];
        self.numberOfLines=0;
        
        
        

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
