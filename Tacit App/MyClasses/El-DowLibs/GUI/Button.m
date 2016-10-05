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
//        if ([imageName isEqualToString:@"null"]) {
//            
//            self =[UIButton buttonWithType:UIButtonTypeCustom ];
//            [self setFrame:CGRectMake(btnX, btnY, 100, 150)];
//            
//        }else{
            self = [UIButton buttonWithType:UIButtonTypeCustom ];
            [self setFrame:CGRectMake(btnX, btnY, img.frame.size.width, img.frame.size.height)];
            //   [self setTitle:@"selfomer" forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
//        }

           
        
        
        
       
    }
    return self;
}

@end
