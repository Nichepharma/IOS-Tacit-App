//
//  UILabel+LabelCategory.m
//  Tacit App
//
//  Created by Yahia El-Dow on 11/21/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import "UILabel+LabelCategory.h"

@implementation UILabel (LabelCategory)

-(UILabel *)setIncrementLabel : (float) from  toEnd: (float) to  incrementalPlus: (float)increment delay:(float)_Delay {
     self.alpha = 0 ;
     NSNumber* _from = [NSNumber numberWithFloat:from];
     NSNumber* _to = [NSNumber numberWithFloat:to];
     NSNumber* _increment = [NSNumber numberWithFloat:increment];

     NSDictionary *params = @{@"from": _from, @"to" : _to , @"increment":_increment};
     [NSTimer scheduledTimerWithTimeInterval:_Delay
                                      target:self
                                    selector:@selector(inCrementFire:)
                                    userInfo: params
                                     repeats:NO];
     


    return  self ;
}
-(void)inCrementFire:(NSTimer *)timer {
     self.alpha = 1 ;
     NSDictionary *params =  timer.userInfo;
     [self start:params];
}

-(void)start :(NSDictionary*)info {
     float from =      [[info objectForKey:@"from"] floatValue];
     float to   =      [[info objectForKey:@"to"] floatValue ];
     float increment = [[info objectForKey:@"increment"] floatValue];
    if (from > to) { return;
        
    }
     [UIView animateWithDuration: 1  delay : 0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
          CGFloat rounded_down = floorf(from * 100) / 100 ;
          [self setText: [NSString stringWithFormat:@"%.1f", rounded_down]];

     } completion:^(BOOL finished){

          if (from < to) {
               NSNumber* _from = [NSNumber numberWithFloat:from + increment];
               NSNumber* _to = [NSNumber numberWithFloat:to];
               NSNumber* _increment = [NSNumber numberWithFloat:increment];

               NSDictionary *params = @{@"from": _from, @"to" : _to , @"increment":_increment};
               [self start:params];
//               [self setIncrementLabel:from  + increment  toEnd:to incrementalPlus:increment delay:0];
          }else {
              if (from - to == 0) {
                  int finalNumber = to ;
                  [self setText: [NSString stringWithFormat:@"%d",finalNumber]];
                  [self setTextAlignment:NSTextAlignmentCenter];
              }
          }

     }];
}
@end
