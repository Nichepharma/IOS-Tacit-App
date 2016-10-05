//
//  ContanerAppView.m
//  Career Management Apps
//
//  Created by Yahia on 3/14/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import "ContanerAppView.h"
#import "Header.h"
//#import "SetAnimationsWithItems.h"
#import "CreateViewWithArray.h"
#import "ClosingViewController.h"

@interface ContanerAppView ()<scrollingDelegate , _MenuDelegate>{
@private char slide_Num ;
    // Dashboard Item
@private NSString *startTime ;
@private  NSMutableArray *item;
@private   _ScrollingView *scrollView ;
    // PDF ITEM
@private Button *btn_pdfArrow ;
@private UIWebView *pdfShow ;
@private UIView * pdfView ;
@private BOOL ButtonOfPDFCheck ;
    
    // MENU ITEM
@private BOOL menuChecked ;
@private  Button *btn_menu ;
@private MenuView *menuContanerView ;
}@end

@implementation ContanerAppView

-(void)viewDidLoad{

    item = [[NSMutableArray alloc] init];
    startTime = [[NSString alloc] initWithFormat:@"%@",[[TimerCalculate getSharedInstance] TimeNow]];
    NSLog(@"%@ startTime = " , startTime);
    [[TimerCalculate getSharedInstance] updateSlide:[[TimerCalculate getSharedInstance] TimeNow] :slide_Num];

//
//}
//
//-(void)viewDidAppear:(BOOL)animated{
//

    NSMutableDictionary *mainArray  = [[ApplicationData getSharedInstance]getMasterData ] ;
    if ([mainArray objectForKey:@"staticButtons"] ) {
        
    }



    scrollView = [[_ScrollingView alloc] initWithFrame:self.view.frame numberOFSlides: [[ApplicationData getSharedInstance] getSlideNumber] - 1 ];
    [scrollView setScrollViewBKG:[[ApplicationData getSharedInstance] getScrollViewBKG] appName:[[ApplicationData getSharedInstance] getAppName]] ;
    scrollView.sDelegate = self ;
    [self.view addSubview:scrollView];



    [_MasterContanerView removeFromSuperview];
     NSMutableDictionary *dicArray  = [[[[ApplicationData getSharedInstance]getMasterData ] objectForKey:@"slideshows"] objectAtIndex:0];
    _MasterContanerView = [[CreateViewWithArray alloc] initWithArray:dicArray setXView:(self.view.frame.size.width * 0)] ;
    [scrollView addSubview: _MasterContanerView];
    
    NSLog(@"dicArray %@ ", [[[ApplicationData getSharedInstance]getMasterData ] allKeys ]);
    
    Button *btn_goToClose = [[Button alloc] initWithFrame:@"tabukLogo.png" :self.view.frame.size.width-300 :self.view.frame.size.height-120];
    btn_goToClose.frame=CGRectMake(                                                                                                                                                                                                                                                                                                                                                                                                                                                                       self.view.frame.size.width-btn_goToClose.frame.size.width, self.view.frame.size.height-70, btn_goToClose.frame.size.width, 80);
    [btn_goToClose addTarget:self action:@selector(goToCloseView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_goToClose];
    
    
    btn_pdfArrow = [[Button alloc] initWithFrame:@"pdfArrow.png" :0 :0];
    btn_pdfArrow.frame=CGRectMake(500, 740, 40, 35);
    btn_pdfArrow.alpha = 0 ;
    [btn_pdfArrow  addTarget:self action:@selector(pdfViewerMethod:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:btn_pdfArrow];
    
    

    
    btn_menu  = [[Button alloc ]initWithFrame:[[[ApplicationData getSharedInstance] getMENUArray] objectForKey:@"menuButton"] :0 :710];
    [btn_menu addTarget:self action:@selector(btnMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    btn_menu.tag=0;
    btn_menu.alpha=0;
    [self.view addSubview:btn_menu];
    
    
    
     //[self.view addSubview:[self open_PDFViewerWith_name:@"pdf"]] ;
}


 UIView *_MasterContanerView ;
-(void)endScroll:(int)slideNumber{








    [[TimerCalculate getSharedInstance] updateSlide:startTime :slideNumber];
    slide_Num = slideNumber ;
    startTime = [[TimerCalculate getSharedInstance] TimeNow];
  
    [_MasterContanerView removeFromSuperview];
    NSMutableDictionary *dicArray  = [[[[ApplicationData getSharedInstance]getMasterData ] objectForKey:@"slideshows"] objectAtIndex:slideNumber];
    _MasterContanerView = [[CreateViewWithArray alloc] initWithArray:dicArray setXView:(self.view.frame.size.width * slideNumber)] ;
    [scrollView addSubview: _MasterContanerView];
  

    if (slide_Num > 0){
    btn_menu.alpha=1;
    }else    btn_menu.alpha=0;
    if (menuChecked) {
          [self __closeMenu];
    }
    
    // Checked If Slide Having a Refrence ......
    if ([[[ApplicationData getSharedInstance]
                            getPDFArray] objectForKey:[NSString stringWithFormat:@"%d",slideNumber]]) {
        
        btn_pdfArrow.alpha = 1 ;
    }else{
        btn_pdfArrow.alpha = 0 ;
    }

    
    if (ButtonOfPDFCheck) {
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            ButtonOfPDFCheck =false;
            pdfView.frame =CGRectMake(50, 820, 954, 168);
            btn_pdfArrow.transform=CGAffineTransformMakeRotation(0);
            btn_pdfArrow.frame=CGRectMake(500, 740, btn_pdfArrow.frame.size.width ,
                                          btn_pdfArrow.frame.size.height) ;
        } completion:^(BOOL finished){
            
        }];

    }


}





-(IBAction)goToCloseView:(id)sender{
    
   ClosingViewController  *clView = [self.storyboard instantiateViewControllerWithIdentifier:@"closing"];
    [[TimerCalculate getSharedInstance] updateSlide:startTime :slide_Num];
    [self presentViewController:clView animated:NO completion:^(void){}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//_______________________________-----#PDF API#-----_______________________________//

#pragma mark PDF Viewer Methods 
-(IBAction)pdfViewerMethod:(id)sender{

        //! .. create allocated PDF View in memory ...
        
        if (!pdfView) {
            #pragma mark -Create Allocated PDF
            pdfView=[[UIView alloc] initWithFrame:CGRectMake(50, 800, 954, 168)];
            pdfView.backgroundColor=[[UIColor colorWithPatternImage:[UIImage imageNamed:@"pdfBox.png"]] colorWithAlphaComponent:.5];
            [self.view addSubview:pdfView];
        }
    
        //open or Close PDF View
        if (!ButtonOfPDFCheck) {
            // To Open PDF
            ButtonOfPDFCheck =true;
            // add Button In View
            [self setPDF_Button];
            [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                pdfView.frame =CGRectMake(50, 620, 954, 168);
                btn_pdfArrow.transform=CGAffineTransformMakeRotation(3.1);
                btn_pdfArrow.frame=CGRectMake(500,600, btn_pdfArrow.frame.size.width ,
                                                        btn_pdfArrow.frame.size.height);
            } completion:^(BOOL finished){}];
            
            
        }else {
                // To Close PDF
            [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                    ButtonOfPDFCheck =false;
                pdfView.frame =CGRectMake(50, 820, 954, 168);
                btn_pdfArrow.transform=CGAffineTransformMakeRotation(0);
                btn_pdfArrow.frame=CGRectMake(500, 740, btn_pdfArrow.frame.size.width ,
                                              btn_pdfArrow.frame.size.height) ;
            } completion:^(BOOL finished){
                
            }];
        }
    
}
-(void)setPDF_Button {
    
    for (int numOfPDF = 0 ;
         numOfPDF < [[[[[ApplicationData getSharedInstance] getPDFArray]
                                objectForKey:[NSString stringWithFormat:@"%d",slide_Num]]
                                objectForKey:@"content"] count];
             numOfPDF ++ ) {
        
        NSString *str_ImgName  =[[[[[[ApplicationData getSharedInstance] getPDFArray]
                                    objectForKey:[NSString stringWithFormat:@"%d",slide_Num]]
                                    objectForKey:@"content"] objectAtIndex:numOfPDF]
                                    objectForKey:@"image"];
       
        
        Button *tempBTN_PDF = [[Button alloc] init];
        UIImage *temp_buttonImage = [Image loadimageFromDocumentWithName:str_ImgName
                                        stringWithApplicationDidSelected: [[ApplicationData getSharedInstance] getAppName]] ;
        [tempBTN_PDF setImage:temp_buttonImage  forState:UIControlStateNormal];
     
    
        
        [tempBTN_PDF setFrame:CGRectMake(
                                         (pdfView.frame.size.width / 2) - (temp_buttonImage .size.width / 2)
                                         , (30  * numOfPDF ) + 20 ,
                                         temp_buttonImage .size.width,
                                         30   )];
        [tempBTN_PDF setTag:numOfPDF];
        [tempBTN_PDF addTarget:self action:@selector(showPDFView:) forControlEvents:UIControlEventTouchUpInside] ;
        [pdfView addSubview:tempBTN_PDF];
    }
    
}

-(IBAction)showPDFView:(id)sender{
    NSString * strPDF_Name = [[[[[[ApplicationData getSharedInstance] getPDFArray]
                                 objectForKey:[NSString stringWithFormat:@"%d",slide_Num]]
                                objectForKey:@"content"] objectAtIndex:[sender tag]]
                              objectForKey:@"ref"] ;
    
    pdfShow = [PDFViewer openPDF_withName:[NSString stringWithFormat:@"%@/%@",[[ApplicationData getSharedInstance] getAppName],strPDF_Name]] ;
   
    UIButton *close=[UIButton buttonWithType:UIButtonTypeContactAdd];
    close.frame=CGRectMake(975, 20, 50, 50);
    [close addTarget:self action:@selector(pdf_dismissMe:) forControlEvents:UIControlEventTouchUpInside];
    close.transform=CGAffineTransformMakeRotation(2.4);
    close.alpha=.7;
    

    [self.view addSubview:pdfShow];
    [self.view addSubview:close];
}

-(IBAction)pdf_dismissMe:(id)sender {
    [pdfShow removeFromSuperview];
    [sender removeFromSuperview];
}



//------------------------------------ MENU ------------------------------------ //

-(IBAction)btnMenuAction:(id)sender{

        if (!menuChecked) {
            if (!menuContanerView) {
                menuContanerView = [[MenuView alloc] init];
                menuContanerView.menuDelegate = self ;
                [self.view addSubview:[menuContanerView getMenuView]];
            }
            
            
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                [menuContanerView getMenuView].frame = CGRectMake(0, [menuContanerView getMenuView].frame.origin.y, [menuContanerView getMenuView].frame.size.width, [menuContanerView getMenuView].frame.size.height);
                scrollView.frame = CGRectMake([menuContanerView getMenuView].frame.origin.x + [menuContanerView getMenuView].frame.size.width,
                                              0,
                                              scrollView.frame.size.width, scrollView.frame.size.height);
                btn_menu.frame = CGRectMake([menuContanerView getMenuView].frame.origin.x + [menuContanerView getMenuView].frame.size.width,
                                            btn_menu.frame.origin.y,
                                            btn_menu.frame.size.width, btn_menu.frame.size.height);
            } completion:^(BOOL finished){ menuChecked = true ;
            }];
       
            

            
        }else if (menuChecked){
            [self __closeMenu];
            
        }
    

    
}

-(void)didSelectMenuItem:(int)goToSlideNumber{
    
    [_MasterContanerView removeFromSuperview];
      [scrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width * goToSlideNumber
                                               , 0 ,scrollView.frame.size.width, scrollView.frame.size.height) animated:false];
    
    
    NSMutableDictionary *dicArray  = [[[[ApplicationData getSharedInstance]getMasterData ] objectForKey:@"slideshows"] objectAtIndex:goToSlideNumber];
    
    _MasterContanerView = [[CreateViewWithArray alloc] initWithArray:dicArray setXView:(self.view.frame.size.width * goToSlideNumber)] ;
    [scrollView  addSubview:_MasterContanerView];
    
    [self __closeMenu];
    

}


-(void)__closeMenu{

    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        [menuContanerView getMenuView].frame = CGRectMake(-300, 0, [menuContanerView getMenuView].frame.size.width,[menuContanerView getMenuView].frame.size.height);
        [btn_menu setFrame:CGRectMake([menuContanerView getMenuView].frame.origin.x + [menuContanerView getMenuView].frame.size.width
                                      ,[btn_menu frame].origin.y,[btn_menu frame].size.width , [btn_menu frame].size.height)];
        [scrollView setFrame:CGRectMake([menuContanerView getMenuView].frame.origin.x + [menuContanerView getMenuView].frame.size.width
                                        ,[scrollView frame].origin.y,[scrollView frame].size.width , [scrollView frame].size.height)];
    } completion:^(BOOL finished){
          menuChecked = false ;
    }];

  

    
}


@end
