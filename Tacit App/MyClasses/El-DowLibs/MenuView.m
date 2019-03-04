//
//  MenuView.m
//  Career Management Apps
//
//  Created by Yahia on 3/28/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import "MenuView.h"
#import "Header.h"
@implementation MenuView
    UIView *menuV ;
    float nextMenuY ;

- (instancetype)init
{
    self = [super init];
    if (self) {

        menuV =  [[ UIView alloc] initWithFrame:CGRectMake(-300, 0, 300, 768)];

        [menuV setBackgroundColor:[UIColor colorWithPatternImage:
                                   [ Image loadimageFromDocumentWithName:[[[ApplicationData getSharedInstance]getMENUArray] objectForKey:@"menuBKG"]
                                        stringWithApplicationDidSelected:[[ApplicationData getSharedInstance] getAppName] ]
                                   ]] ;

        for (int i = 0 ; i < [[[[ApplicationData getSharedInstance]getMENUArray] objectForKey:@"content"] count]; i ++ ) {
            Button *btnMenu = [[Button alloc] init];
            UIImage *menuButton_img = [Image loadimageFromDocumentWithName:[[[[[ApplicationData getSharedInstance]getMENUArray] objectForKey:@"content"] objectAtIndex:i] objectForKey:@"image"]
                                          stringWithApplicationDidSelected:[[ApplicationData getSharedInstance] getAppName]] ;
            [btnMenu setImage:menuButton_img forState:UIControlStateNormal];
            if (i == 0 ) {
                nextMenuY = [[[[[[ApplicationData getSharedInstance]getMENUArray] objectForKey:@"content"] objectAtIndex:i] objectForKey:@"menuY"] floatValue] ;

            }

            btnMenu.frame = CGRectMake([[[[[[ApplicationData getSharedInstance]getMENUArray] objectForKey:@"content"] objectAtIndex:i] objectForKey:@"menuX"] floatValue] ,
                                       nextMenuY ,
                                       menuButton_img.size.width ,
                                       menuButton_img.size.height);


            nextMenuY = ( btnMenu.frame.size.height + btnMenu.frame.origin.y + 20);

            if (![[[[[[ApplicationData getSharedInstance]getMENUArray] objectForKey:@"content"] objectAtIndex:i] objectForKey:@"goTo"] isEqualToString:@""]  ) {
                [btnMenu setTag: [[[[[[ApplicationData getSharedInstance]getMENUArray] objectForKey:@"content"] objectAtIndex:i] objectForKey:@"goTo"] integerValue]];
                [btnMenu  addTarget:self action:@selector(MenuButtonActions:) forControlEvents:UIControlEventTouchUpInside];

            }

            [menuV addSubview:btnMenu];
        }
    }
    return self;
}
-(UIView *) getMenuView {
    
    return menuV;
}

-(IBAction)MenuButtonActions:(id)sender{

   [_menuDelegate didSelectMenuItem:[sender tag]];

}




@end
