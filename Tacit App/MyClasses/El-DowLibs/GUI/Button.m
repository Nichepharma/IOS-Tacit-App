//
//  Button.m
//  TABUNEX-ADULTS
//
//  Created by Yosra on 5/11/14.
//  Copyright (c) 2014 Yosra. All rights reserved.
//

#import "Button.h"

@implementation Button

- (id)initWithFrame :(NSString*) imageName :(NSInteger)btnX :(NSInteger)btnY
{
    
    UIImageView  *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName] ];
    

    self = [super initWithFrame:CGRectMake(btnX, btnY, img.frame.size.width, img.frame.size.height) ];
    
    if (self) {

            [self setFrame:CGRectMake(btnX, btnY, img.frame.size.width, img.frame.size.height)];
            [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        [[self titleLabel]  setFont:[UIFont fontWithName:@"NeoSans-Light.otf" size:13]];
    }
    return self;
}

@end
