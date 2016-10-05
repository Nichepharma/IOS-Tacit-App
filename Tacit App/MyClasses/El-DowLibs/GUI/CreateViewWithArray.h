//
//  CreateViewWithArray.h
//  Career Management Apps
//
//  Created by Yahia on 3/20/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CreateViewWithArray : UIView

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
