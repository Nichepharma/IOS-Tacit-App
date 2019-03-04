//
//  CreateViewWithArray.m
//  Career Management Apps
//
//  Created by Yahia on 3/20/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import "CreateViewWithArray.h"
#import "MAVideoButton.h"


@implementation CreateViewWithArray
NSMutableDictionary *actionImageDic ;
AVAudioPlayer *myplayer;
NSMutableArray *actionTags ;

-(id)initWithArray :(NSMutableDictionary *)arr_contaner setXView :(float)vX {
    
    self = [super initWithFrame:CGRectMake(vX, 0, [[[UIScreen screens] firstObject] bounds].size.width, [[[UIScreen screens] firstObject] bounds].size.height)];
    actionImageDic = [[NSMutableDictionary alloc] init];
    actionTags = [[NSMutableArray alloc] init];
    
    if (self) {
        
        if ( [arr_contaner objectForKey:@"pie"]){   //For drawing a rounded circle
            [self setPieViewContent:[arr_contaner objectForKey:@"pie"] ] ;
        }
        
        if ( [arr_contaner objectForKey:@"image"])  //Our Basic Main Slide
            [self setViewContent:[arr_contaner objectForKey:@"image"] ];
        
        if ( [arr_contaner objectForKey:@"label"])
            [self setLabelView:[arr_contaner objectForKey:@"label"] ] ;
        
        if ( [arr_contaner objectForKey:@"gif"])
            [self initGIF:[arr_contaner objectForKey:@"gif"] ] ;
        
        // check if slide have mp3 file should play
        if ( [arr_contaner objectForKey:@"sound"])
            [self playMp3File:[arr_contaner objectForKey:@"sound"] ] ;

         if ( [arr_contaner objectForKey:@"videoPausable"]) //u can puase this video
              [self playPausableVideoFile:[arr_contaner objectForKey:@"videoPausable"] ] ;

        if ( [arr_contaner objectForKey:@"video"])     //u can't pause this video
              [self playVideoFile:[arr_contaner objectForKey:@"video"] ] ;


    }
    return self;
}

-(void)removeImageWithTagID :(int)tag {
    for ( UIView *view in [self subviews] ) {
        if (view.tag == tag) {
            [view removeFromSuperview];
        }
    }
}

-(void)setPieViewContent  :(NSDictionary *)content_Dic {
    for ( NSDictionary * elemenet in content_Dic ) {
        float pieX = [[elemenet objectForKey:@"positionX"] floatValue];
        float pieY = [[elemenet objectForKey:@"positionY"] floatValue];
        float pieW = [[elemenet objectForKey:@"pieWidth"] floatValue];
        float pieH = [[elemenet objectForKey:@"pieHeight"] floatValue];
        float percentage = [[elemenet objectForKey:@"percentage"] floatValue];
        float percentage2 = [[elemenet objectForKey:@"percentage2"] floatValue];
        float percentage3 = [[elemenet objectForKey:@"percentage3"] floatValue];
        float f_AnimationDelay = [[elemenet objectForKey:@"delay"]  floatValue] ;
        int viewTag = [[elemenet objectForKey:@"tag"] intValue];
        
        double delayInSeconds = f_AnimationDelay;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            PieDraw *pieView = [[PieDraw alloc] init];
            
            [pieView setPieDiameter1:percentage ];
            [pieView setPieDiameter2:percentage2 ];
            [pieView setPieDiameter3:percentage3 ];
            
            UIColor *pie1Color = [Image _HexaColor:elemenet[@"color1"]];
            UIColor *pie2Color = [Image _HexaColor:elemenet[@"color2"]];
            UIColor *pie3Color = [Image _HexaColor:elemenet[@"color3"]];
            
            [pieView setDelay:delayInSeconds];
            [pieView setPieWidth:pieW];
            pieView.tag = viewTag;
            [pieView setPieHeight:pieH];
            [pieView setPieX:pieX];
            [pieView setPieY:pieY];
            [pieView setPie1Background: pie1Color ];
            [pieView setPie2Background: pie2Color ];
            [pieView setPie3Background: pie3Color ];
            [pieView setPieTransform:1.20];
            
            [self addSubview:[pieView drawPie]];

        
        });
    }
}
//   MARK:- CREATEING LABELVIEW
// to create label View
-(void)setLabelView :(NSDictionary *)content_Dic{
    for (   NSDictionary * elemenet in content_Dic ) {
        
        float f_AnimationDelay = [[elemenet objectForKey:@"delay"]  floatValue] ;
        NSString *lbl_str = [elemenet objectForKey:@"str"] ;
        float lbl_XPostion = [[elemenet objectForKey:@"positionX"] floatValue];
        float lbl_YPostion = [[elemenet objectForKey:@"positionY"] floatValue];
        float lbl_width  = [[elemenet objectForKey:@"width"] floatValue];
        float lbl_height = [[elemenet objectForKey:@"height"] floatValue];
        float lbl_fontSize = [[elemenet objectForKey:@"fontSize"] floatValue];
        int viewTag = [[elemenet objectForKey:@"tag"] intValue];
        NSString *lbl_fontName = [elemenet objectForKey:@"fontName"];
        UIColor *font_color = [Image _HexaColor:[elemenet objectForKey:@"textColor"]];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(f_AnimationDelay * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(lbl_XPostion, lbl_YPostion, lbl_width, lbl_height)];
        lbl.tag = viewTag;
        [lbl setTextColor :  font_color];
        [lbl setText:lbl_str];
        [lbl setFont:[UIFont fontWithName:lbl_fontName size:lbl_fontSize]];
        if ([elemenet objectForKey:@"endTo"]) {
            float strartFrom = [lbl_str floatValue];
            float endTo = [[elemenet objectForKey:@"endTo"] floatValue];
            float incrementPluse = [[elemenet objectForKey:@"increment"] floatValue];
            [lbl setIncrementLabel:strartFrom toEnd:endTo incrementalPlus:incrementPluse delay:0];

        }
        [self addSubview:lbl];
        });
    }
}


-(void)setViewContent :(NSDictionary *)content_Dic{
    for (  NSDictionary * elemenet in content_Dic ) {
        /* JSON:
         animationType = setFadeAnimations;
         delay = "0.5";
         name = "img/S3/S3-03.png";
         positionX = setXCenter;
         positionY = 190;
        */
        
        //Use name
        UIImage *i2 = [Image loadimageFromDocumentWithName: [elemenet objectForKey:@"name"]
                          stringWithApplicationDidSelected: [[ApplicationData getSharedInstance] getAppName]];
        UIImageView *img = [[UIImageView alloc] init];
        
        //Use X and Y
        NSString *checkXCenter = [NSString stringWithFormat:@"%@", [elemenet objectForKey:@"positionX"] ];
        NSString *checkYCenter =  [NSString stringWithFormat:@"%@", [elemenet objectForKey:@"positionY"] ];
        int viewTag = [[elemenet objectForKey:@"tag"] intValue];
        img.tag = viewTag ;
        
        // postion
        if ([checkXCenter isEqualToString :@"setXCenter"] &&  [checkYCenter isEqualToString :@"setYCenter"] ){
            img.frame =  CGRectMake( 0 , 0 , i2.size.width , i2.size.height);
            [img  setInCenter];
        }else if ([checkXCenter isEqualToString :@"setXCenter"]){
            float imgY = [[elemenet objectForKey:@"positionY"] floatValue];
            img.frame =  CGRectMake( 0 , imgY  , i2.size.width , i2.size.height);
            [img  setXCenter];
        }else  if ([checkYCenter isEqualToString :@"setYCenter"]){
            float imgX = [[elemenet objectForKey:@"positionX"] floatValue];
            img.frame =  CGRectMake( imgX , 0 , i2.size.width , i2.size.height);
            [img  setYCenter];
        }else{
            float imgX = [[elemenet objectForKey:@"positionX"] floatValue];
            float imgY = [[elemenet objectForKey:@"positionY"] floatValue];
            img.frame = CGRectMake(imgX, imgY , i2.size.width, i2.size.height) ;
        }
        
        [img setImage:i2];
        
        NSString *isHaveAction = [elemenet objectForKey:@"haveAction"];
        if (isHaveAction){
            NSString *imageTag = [elemenet objectForKey:@"tag"] ;
            [actionImageDic setObject: isHaveAction  forKey:imageTag];
            [img setUserInteractionEnabled:YES];
            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageAction:)];
            img.tag = [imageTag integerValue] ;
            [singleTap setNumberOfTapsRequired:1];
            [img addGestureRecognizer:singleTap];
        }
        /*
         setFrame
         setFrameWithPostion
         setFadeAnimations
         setFadeOutAnimations
         setDropeAnimations
         setBarAnimations
         setWidthAnimations
         setWidthAnimations
         moveToY
         moveToX
         moveToX&Y
         changeImage
         changeImageWithFade
         setLeftFlip
         setRightFlip
         setUPFlip
         setDownFlip
         */
        
        //Use animationType
        NSString *str_AnimationType = [elemenet objectForKey:@"animationType"]  ;
        
        //Use Delay
        float f_AnimationDelay = [[elemenet objectForKey:@"delay"]  floatValue] ;
        
        //Types Of Animations
        //Move to place animation or was certain size and stretched it
        if ([str_AnimationType isEqualToString:@"moveToY"] || [str_AnimationType isEqualToString:@"moveToX"] ){
            float f_nextMove =  [[elemenet objectForKey:@"nextMove"]  floatValue] ;
            [SetAnimationsWithItems setAnimationsWithObjectMoveXorY:img
                                                           withType:str_AnimationType
                                                 animationWithDelay:f_AnimationDelay
                                                        setNextMove:f_nextMove];
        } else if ([str_AnimationType isEqualToString:@"moveToX&Y"] ){//|| [str_AnimationType isEqualToString:@"moveToX"] ) {
            // Frame 1
            float _X1 =  [[elemenet objectForKey:@"x1"]  floatValue] ;
            float _Y1 =  [[elemenet objectForKey:@"y1"]  floatValue] ;
            //Frame 2
            float _X2 =  [[elemenet objectForKey:@"x2"]  floatValue] ;
            float _Y2 =  [[elemenet objectForKey:@"y2"]  floatValue] ;
            
            CGRect frame1 = CGRectMake(_X1 ,_Y1, img.frame.size.width, img.frame.size.height);
            CGRect frame2 = CGRectMake(_X2 ,_Y2, img.frame.size.width, img.frame.size.height);
            [SetAnimationsWithItems setFrameWithObject:img
                                         setFirstFrame:frame1
                                         toSecondFrame:frame2
                                    animationWithDelay:f_AnimationDelay];
        }
        else if ([str_AnimationType isEqualToString:@"setFrame"] ) {
            // Frame 1
            float _X1 =  [[elemenet objectForKey:@"x1"]  floatValue] ;
            float _Y1 =  [[elemenet objectForKey:@"y1"]  floatValue] ;
            float _W1 =  [[elemenet objectForKey:@"w1"]  floatValue] ;
            float _H1 =  [[elemenet objectForKey:@"h1"]  floatValue] ;
            //Frame 2
            float _X2 =  [[elemenet objectForKey:@"x2"]  floatValue] ;
            float _Y2 =  [[elemenet objectForKey:@"y2"]  floatValue] ;
            float _W2 =  [[elemenet objectForKey:@"w2"]  floatValue] ;
            float _H2 =  [[elemenet objectForKey:@"h2"]  floatValue] ;
            //NSLog(@"W1 = %f",_W1);
            //NSLog(@"H1 = %f",_H1);
            //NSLog(@"W2 = %f",_W2);
            //NSLog(@"H2 = %f",_W2);
            CGRect frame1 = CGRectMake(_X1, _Y1, _W1, _H1);
            CGRect frame2 = CGRectMake(_X2, _Y2, _W2, _H2);
            [SetAnimationsWithItems setFrameWithObject:img
                                         setFirstFrame:frame1
                                         toSecondFrame:frame2
                                    animationWithDelay:f_AnimationDelay];
        } else if ([str_AnimationType isEqualToString:@"setFrameWithPostion"] ) {
            // Frame 1
            float _X1 =  [[elemenet objectForKey:@"x1"]  floatValue] ;
            float _Y1 =  [[elemenet objectForKey:@"y1"]  floatValue] ;
            //Frame 2
            float _X2 =  [[elemenet objectForKey:@"x2"]  floatValue] ;
            float _Y2 =  [[elemenet objectForKey:@"y2"]  floatValue] ;
            CGRect frame1 = CGRectMake(_X1, _Y1, img.frame.size.width, img.frame.size.height);
            CGRect frame2 = CGRectMake(_X2, _Y2, img.frame.size.width,  img.frame.size.height);
            [SetAnimationsWithItems setFrameWithObject:img setFirstFrame:frame1 toSecondFrame:frame2 animationWithDelay:f_AnimationDelay];
        } else if ([str_AnimationType isEqualToString:@"setWidthBarAnimations"] ) {
            [SetAnimationsWithItems setAnimationsWithObject:img
                                                   withType:str_AnimationType
                                         animationWithDelay:f_AnimationDelay] ;
        }
        else if([str_AnimationType isEqualToString:@"changeImageWithFade"]){
            UIImage *toNewImage = [Image loadimageFromDocumentWithName: [elemenet objectForKey:@"changeToImage"]
                                      stringWithApplicationDidSelected: [[ApplicationData getSharedInstance] getAppName]] ;
            NSLog(@"toNewImagetoNewImage %@ ", toNewImage) ;
            [SetAnimationsWithItems setAnimationsWithObjectChangeImages:img toNewImage:toNewImage withDelay:f_AnimationDelay];
            [self addSubview:img];
        } else if([str_AnimationType isEqualToString:@"changeImage"]){
            UIImage *toNewImage = [Image loadimageFromDocumentWithName: [elemenet objectForKey:@"changeToImage"]
                                      stringWithApplicationDidSelected: [[ApplicationData getSharedInstance] getAppName]] ;
            NSLog(@"toNewImagetoNewImage %@ ", toNewImage) ;
            [SetAnimationsWithItems setAnimationsWithObjectChangeImagesWithoutAlpha:img
                                                                         toNewImage: toNewImage
                                                                          withDelay:f_AnimationDelay];
            
        } else if ([str_AnimationType isEqualToString:@"setLeftFlip"]){
            [SetAnimationsWithItems setAnimationsWithLeftFlip:img withDelay:f_AnimationDelay];
        } else if ([str_AnimationType isEqualToString:@"setRightFlip"]){
            [SetAnimationsWithItems setAnimationsWithRightFlip:img withDelay:f_AnimationDelay];
        } else if ([str_AnimationType isEqualToString:@"setUPFlip"]){
            [SetAnimationsWithItems setAnimationsWithUpFlip:img withDelay:f_AnimationDelay];
        } else if ([str_AnimationType isEqualToString:@"setDownFlip"]){
            [SetAnimationsWithItems setAnimationsWithDownFlip:img withDelay:f_AnimationDelay];
        }
        else {
            [SetAnimationsWithItems setAnimationsWithObject:img   withType:str_AnimationType animationWithDelay:f_AnimationDelay];
        }
        
        if ( [elemenet objectForKey:@"alpha"] ) {
            [UIView animateWithDuration:1.3 delay :1  options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                img.alpha =  [[elemenet objectForKey:@"alpha"]  floatValue] ;
            } completion:nil];
        }
        [self addSubview:img];
        
        
        if ( [[elemenet objectForKey:@"removeViewWithTag"] integerValue] > 0 )  {
            int removeViewWithTag = [[elemenet objectForKey:@"removeViewWithTag"] intValue];
            [self removeImageWithTagID: removeViewWithTag];
        }
    }    
}

-(IBAction)imageAction:(id)sender{
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
    long tag = recognizer.view.tag;
    if (![actionTags containsObject:[NSString stringWithFormat:@"%ld", tag]] ){
        [actionTags addObject:[NSString stringWithFormat:@"%ld", tag]];
        
        [self setViewContent: actionImageDic[[NSString stringWithFormat: @"%ld", tag ] ]];
        
        //superOtherAction
        NSDictionary *super_newAction = [actionImageDic[[NSString stringWithFormat:@"%ld", tag ] ] objectAtIndex:0];
        if ([[super_newAction objectForKey:@"superOtherAction"] isEqualToString:@"moveToX"]) {
            float nextXMove = [[super_newAction objectForKey:@"positionX"] floatValue] ;
            [SetAnimationsWithItems setFrameWithObject:recognizer.view
                                         setFirstFrame:recognizer.view.frame
                                         toSecondFrame:CGRectMake(nextXMove, recognizer.view.frame.origin.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height)
                                    animationWithDelay:0];
            
        }
    }
    //   [recognizer.view setAlpha :0];
    
}

-(void)playMp3File :(NSString *) mp3File_name {
    if (myplayer.isPlaying){
        [myplayer stop];
    }
    NSString *str = [NSString stringWithFormat:@"%@/%@", [[ApplicationData getSharedInstance] getAppName] , mp3File_name ];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *soundFile=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
    NSLog(@"key %@ ", soundFile);
    if (soundFile) {
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFile];
        if ([[NSFileManager defaultManager] fileExistsAtPath:soundFile]) {
            NSError        *error;
            myplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
            [myplayer setNumberOfLoops:0];
            [myplayer play];
        }
        
    }
}

-(void)initGIF :(NSDictionary *) gifDic {
    NSString *gif_name = gifDic[@"name"];
    CGFloat xPostion = [gifDic[@"positionX"] floatValue];
    CGFloat yPostion = [gifDic[@"positionY"] floatValue];
    CGFloat width = [gifDic[@"width"] floatValue];
    CGFloat height = [gifDic[@"height"] floatValue];
    CGRect frame = CGRectMake(xPostion, yPostion, width, height);
    int viewTag = [[gifDic objectForKey:@"tag"] intValue];
    
    NSString *str_AnimationType = [gifDic objectForKey:@"animationType"]  ;
    float f_AnimationDelay = [[gifDic objectForKey:@"delay"]  floatValue] ;
    
    double delayInSeconds = f_AnimationDelay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        NSLog(@"Do some work");
        
        NSString *str = [NSString stringWithFormat:@"%@/%@", [[ApplicationData getSharedInstance] getAppName] , gif_name ];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
        NSURL *gifURL = [NSURL fileURLWithPath:fullPath];
        
        UIImageView * gifImageView = [[UIImageView alloc] initWithFrame:frame];
        gifImageView.tag = viewTag;
        NSData *animationData =  [NSData dataWithContentsOfURL:gifURL];
        AnimatedGif * animation = [AnimatedGif getAnimationForGifWithData:animationData];
        animation.delegate =  self ;
        [gifImageView setAnimatedGif:animation startImmediately:YES];
        [self addSubview:gifImageView];
        
        [SetAnimationsWithItems setAnimationsWithObject:gifImageView   withType:str_AnimationType animationWithDelay:0];
    });
}
//U can pause this video
-(void)playPausableVideoFile :(NSDictionary *) videoDic {
    NSLog(@"videoDic %@ ", videoDic);
    
    NSString *video_name = videoDic[@"name"];
    //CGFloat xPostion = [videoDic[@"positionX"] floatValue];
    BOOL autoPlay = [videoDic[@"autoPlay"] boolValue];  //ma added new
    BOOL fullscreen = [videoDic[@"fullscreen"] boolValue];
    CGFloat xPostion = [videoDic[@"positionX"] floatValue];
    CGFloat yPostion = [videoDic[@"positionY"] floatValue];
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (!fullscreen) {
        width  = [videoDic[@"width"] floatValue];
        height =  [videoDic[@"height"] floatValue];
    }
    
    CGRect video_frame = CGRectMake(xPostion, yPostion, width, height);
    
    NSString *str = [NSString stringWithFormat:@"%@/%@", [[ApplicationData getSharedInstance] getAppName] , video_name ];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
    NSURL *videoURL = [NSURL fileURLWithPath:fullPath];
    
    
    /*AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    AVPlayerLayer *playerLayer = [AVPlayerLayer layer];
    playerLayer.player = player;
    playerLayer.frame = video_frame ;
    playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:playerLayer];
    if (autoPlay) {
        [player play];
    }*/
    MAVideoButton *playerView = [[MAVideoButton alloc] init];
    playerView.frame = video_frame; //CGRectMake(200, 200, 350, 350);
    [playerView setVideoWithVideoURL:videoURL autoPlay:autoPlay];
    [self addSubview:playerView];
    
    //Add Tag so we can play it later
    
}
//U can't pause this video
-(void)playVideoFile :(NSDictionary *) videoDic {
     NSLog(@"videoDic %@ ", videoDic);

     NSString *video_name = videoDic[@"name"];
     //CGFloat xPostion = [videoDic[@"positionX"] floatValue];
     //BOOL autoPlay = [videoDic[@"autoPlay"] boolValue];  //ma added new
     BOOL fullscreen = [videoDic[@"fullscreen"] boolValue];
     CGFloat xPostion = [videoDic[@"positionX"] floatValue];
     CGFloat yPostion = [videoDic[@"positionY"] floatValue];


     CGFloat width = [UIScreen mainScreen].bounds.size.width;
     CGFloat height = [UIScreen mainScreen].bounds.size.height;
     if (!fullscreen) {
          width  = [videoDic[@"width"] floatValue];
          height =  [videoDic[@"height"] floatValue];
     }

     CGRect video_frame = CGRectMake(xPostion, yPostion, width, height);

     NSString *str = [NSString stringWithFormat:@"%@/%@", [[ApplicationData getSharedInstance] getAppName] , video_name ];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString *fullPath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
     NSURL *videoURL = [NSURL fileURLWithPath:fullPath];


     AVPlayer *player = [AVPlayer playerWithURL:videoURL];
      AVPlayerLayer *playerLayer = [AVPlayerLayer layer];
      playerLayer.player = player;
      playerLayer.frame = video_frame ;
      playerLayer.backgroundColor = [UIColor clearColor].CGColor;
      playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
      [self.layer addSublayer:playerLayer];
      //if (autoPlay) {
      [player play];
      //}


}

-(void)animationWillRepeat:(AnimatedGif *)animatedGif{
    [animatedGif stop];
}

@end

