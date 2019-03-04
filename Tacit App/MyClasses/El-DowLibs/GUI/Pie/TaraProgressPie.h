//
//  TaraProgressPie.h
//  TaraTestScroll
//
//  Created by Feras Ali Masoud on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPieProgressView.h"
#import "PieComponent.h"

@interface TaraProgressPie : UIView

@property (strong,nonatomic) NSMutableArray *portions;
@property (strong,nonatomic)NSMutableArray *subPies;
- (id)initWithFrame:(CGRect)frame andPortions:(NSMutableArray *)p;

@end
