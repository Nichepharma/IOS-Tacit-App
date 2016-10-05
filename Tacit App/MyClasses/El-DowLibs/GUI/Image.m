//
//  image.m
//  Piramyl
//
//  Created by Yosra  on 8/10/13.
//  Copyright (c) 2013 tarakeeb. All rights reserved.
//

#import "Image.h"

@interface Image()

@end

@implementation Image

- (id)initWithFrame :(NSString*) imageName :(NSInteger)imageX :(NSInteger)imageY
{
    self = [super initWithImage:[UIImage imageNamed:imageName]];
    if (self) {
        
        [self setFrame:CGRectMake(imageX, imageY, self.frame.size.width, self.frame.size.height)];
     
    }
    return self;
}



+(UIColor*)_HexaColor:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}



+(UIImage*)loadimageFromDocumentWithName :(NSString *)str_imgName stringWithApplicationDidSelected :(NSString *)str_ApplicationDidSelected {

    NSString *str = [NSString stringWithFormat:@"%@/%@",str_ApplicationDidSelected,str_imgName ];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullImgNm=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
    return [UIImage imageWithContentsOfFile:fullImgNm] ;
}





@end
