//
//  MAVideoButton.m
//  Tacit App
//
//  Created by Mahmoud Hamad on 5/2/18.
//  Copyright © 2018 nichepharma.com. All rights reserved.
//

#import "MAVideoButton.h"
#import <AVFoundation/AVFoundation.h>

@interface MAVideoButton ()

@property (nonatomic, strong) UIImageView *pauseImage;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL fullScreen;
@end

@implementation MAVideoButton



-(void)setVideoWithVideoURL:(NSURL*)videoURL autoPlay:(BOOL)autoPlay {
    
    self.player = [AVPlayer playerWithURL:videoURL];
    AVPlayerLayer *playerLayer = [AVPlayerLayer layer];
    playerLayer.player = self.player;
    playerLayer.frame = self.frame;
    playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:playerLayer];
    
    //Play and Pause button
    self.pauseImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Play-Button-PNG-Picture.png"]];
    self.pauseImage.frame = CGRectMake(0, 0, self.frame.size.width/3.5, self.frame.size.height/3.5);
    self.pauseImage.center = self.center;
    self.pauseImage.contentMode = UIViewContentModeScaleAspectFit;
    self.pauseImage.alpha = 0.9;
    [self.pauseImage setHidden:NO];
    [self addSubview:self.pauseImage];
    
    if (autoPlay) {
        [self.player play];
        [self.pauseImage setHidden:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    if ((self.player.rate != 0) && (self.player.error == nil)) {
        // player is playing
        [self.pauseImage setHidden:NO];
        [self.player pause];
    } else if ((self.player.rate == 0) && (self.player.error == nil)) {
        [self.player play];
        [self.pauseImage setHidden:YES];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
