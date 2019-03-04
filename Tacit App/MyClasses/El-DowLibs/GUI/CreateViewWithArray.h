//
//  CreateViewWithArray.h
//  Career Management Apps
//
//  Created by Yahia on 3/20/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Image.h"
#import "SetAnimationsWithItems.h"
#import "ApplicationData.h"
#import "UIImageView+ImageViewCategory.h"
#import "UILabel+LabelCategory.h"
#import "PieDraw.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AnimatedGif.h"
#import "UIImageView+AnimatedGif.h"


@interface CreateViewWithArray : UIView<AnimatedGifDelegate>

/*! 
  * this method return view  , 
  * this method create image and view .
  * need two parameter 
        1 - array have all item (IMAGE , BUTTON , ANY UI )
        2 - postion of X
  *  when send two pram will call loadimageFromDocumentWithName from Image Class
                                    and create this item
 */
-(id)initWithArray :(NSMutableDictionary *)arr_contaner setXView :(float)vX ;

@end
