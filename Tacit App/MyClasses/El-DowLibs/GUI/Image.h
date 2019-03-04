//
//  image.h
//  Piramyl
//
//  Created by Yosra  on 8/10/13.
//  Copyright (c) 2013 tarakeeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+ImageViewCategory.h"
@interface Image : UIImageView

- (id)initWithFrame :(NSString*) imageName :(NSInteger)imageX :(NSInteger)imageY;
+(UIColor*)_HexaColor:(NSString*)hex ;



/*!
 *      if u want to load image From Document Folder use this Method .
 
 
 *      how to use it
 
 
 *      1- call this Class Image ,  then call method  , "[Image loadimageFromDocumentWithName......]"
 
 
 *      2- method need tow Prameters
 
 
 *      pram 1 : name of Image  , pram 2 : folder Name
 
 * Enjoy ... 
 
 */
+(UIImage*)loadimageFromDocumentWithName :(NSString *)str_imgName stringWithApplicationDidSelected :(NSString *)str_ApplicationDidSelected ;
@end
