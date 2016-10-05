//
//  ClosingViewController.m
//  Career Management Apps
//
//  Created by Yahia on 3/20/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import "ClosingViewController.h"
#import "Header.h"
#import "SetAnimationsWithItems.h"
#import "CreateViewWithArray.h"

@interface ClosingViewController (){
@private NSString *strTimeStart ;
}@end
@implementation ClosingViewController
char closSlideNumber  ;



-(void)viewDidLoad{
        strTimeStart =[[TimerCalculate getSharedInstance] TimeNow];
    
    closSlideNumber = [[ApplicationData getSharedInstance] getSlideNumber]-1;
    
    NSString *str_ClosingBKG = [[[[[ApplicationData getSharedInstance] getMasterData]
                                  objectForKey:@"slideshows"] objectAtIndex:closSlideNumber]
                                objectForKey:@"slideBKG"];
    
 
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[Image loadimageFromDocumentWithName:str_ClosingBKG
                                                                     stringWithApplicationDidSelected:[[ApplicationData getSharedInstance] getAppName]
                                                                  ]]];
    

    
    
    

}
-(void)viewDidAppear:(BOOL)animated{
    
    NSMutableDictionary *dicArray  = [[[[ApplicationData getSharedInstance]getMasterData ] objectForKey:@"slideshows"] objectAtIndex:closSlideNumber];
//    UIView *view_Closing = [[CreateViewWithArray alloc] initWithArray:dicArray setXView:0];
    [self.view addSubview: [[CreateViewWithArray alloc] initWithArray:dicArray setXView:0]];
    
    
    Button *Btn_close_  =[[Button alloc]initWithFrame:@"tabukLogo.png" :0 :0];
    Btn_close_.frame=CGRectMake(self.view.frame.size.width-Btn_close_.frame.size.width, self.view.frame.size.height-70,
                                Btn_close_.frame.size.width, 80);
    Btn_close_.tag=0;
    [Btn_close_ addTarget:self action:@selector(close_Tabuk:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn_close_];
    
    
    Button *btnSync=[[Button alloc]initWithFrame:@"dash_btn_save3.png" :0 :720];
    [btnSync addTarget:self action:@selector(GoToSync:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSync];
    
    
}
-(IBAction)close_Tabuk:(id)sender{
    [[TimerCalculate getSharedInstance] updateSlide:strTimeStart :[[[TimerCalculate getSharedInstance] arr_accu ] count ]-1];
    [self dismissViewControllerAnimated:YES completion:Nil];
}
-(IBAction)GoToSync:(id)sender
{
    
    [[TimerCalculate getSharedInstance] updateSlide:strTimeStart :[[[TimerCalculate getSharedInstance] arr_accu ] count]-1];
    DoctorsViewController *dv = [self.storyboard instantiateViewControllerWithIdentifier:@"dv"];
    dv.str_SesstionID=[[NSString alloc] initWithString:[[TimerCalculate getSharedInstance] str_SessionID]];
    dv.doc_ACC=[[NSString alloc] initWithString:[[TimerCalculate getSharedInstance] getAccTime]];
    dv.doc_totalTime = [[TimerCalculate getSharedInstance] getTimeSetInApplication];
    [self presentViewController:dv animated:YES completion:nil];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
