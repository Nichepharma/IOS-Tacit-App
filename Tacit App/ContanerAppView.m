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

@interface ContanerAppView () <scrollingDelegate , _MenuDelegate, UIGestureRecognizerDelegate> {
@private char slide_Num ;

// Dashboard Item
@private  NSString *startTime ;
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

}
// Zoom
@property(nonatomic )CGAffineTransform IdelTransform;
@property(nonatomic,strong)UIPinchGestureRecognizer *pinchRecognizer ;
@property(nonatomic,strong)  IBOutlet UIButton *button;
@end

@implementation ContanerAppView
bool _ISLOADINGAPPLICATION  = false;
NSDictionary *applicationDataContent ;
bool appIsAnalytics = false ;
NSDictionary *pdfDicArray  ;
int contanerApp_companyID = 0 ;
int contanerApp_userID = 0 ;

CGFloat logo_xPostion , logo_yPostion ,logo_width  , logo_height = 0 ;
Button *btn_goToClose ;
-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"__ContanerAppView");
    
    
    //SLIDES GESTURES
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapRecognizer];
    
    panRecognizer.delegate = self;
    pinchRecognizer.delegate = self;

    // Get User and Company Defaults
    NSUserDefaults *userDefault =  [[NSUserDefaults alloc] init];
    contanerApp_companyID = [[userDefault objectForKey:@"companyID"] intValue];
    contanerApp_userID = [[userDefault objectForKey:@"userID"] intValue];
    
    //Analytics
    appIsAnalytics =  [[ApplicationData getSharedInstance] appIsAnalytics];
    pdfDicArray = [[ApplicationData getSharedInstance] getPDFArray] ;
     [_MasterContanerView removeFromSuperview];
     applicationDataContent = [[ApplicationData getSharedInstance] getMasterData ] ;

    //Menu View
    menuContanerView = [[MenuView alloc] init];
    menuContanerView.menuDelegate = self ;
    [self.view addSubview:[menuContanerView getMenuView]];


    item = [[NSMutableArray alloc] init];

     if ([[ApplicationData getSharedInstance] appIsAnalytics]){
          startTime = [[NSString alloc] initWithFormat:@"%@",[[TimerCalculate getSharedInstance] TimeNow]];
          [[TimerCalculate getSharedInstance] updateSlide:[[TimerCalculate getSharedInstance] TimeNow] :slide_Num];
     }


    //NSMutableDictionary *mainArray  = [[ApplicationData getSharedInstance]getMasterData ] ;
    //if ([mainArray objectForKey:@"staticButtons"] ) {}
    
    

    //Set Our Slides by our CustomScrollView
    dispatch_async(dispatch_get_main_queue(), ^{
        scrollView = [[_ScrollingView alloc] initWithFrame:self.view.frame numberOFSlides: [[ApplicationData getSharedInstance] getSlideNumber] - 1 ];
        scrollView.sDelegate = self ;
        [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, self.view.frame.size.height)];
        [self.view addSubview:scrollView];
    });
    _ISLOADINGAPPLICATION  = false;

}


-(void)viewDidAppear:(BOOL)animated{

    if (_ISLOADINGAPPLICATION ==  false ) {
         _ISLOADINGAPPLICATION  = true;
        dispatch_async(dispatch_get_main_queue(), ^{

        //scrollView = [[_ScrollingView alloc] initWithFrame:self.view.frame numberOFSlides: [[ApplicationData getSharedInstance] getSlideNumber] - 1 ];
        //[scrollView setScrollViewBKG:[[ApplicationData getSharedInstance] getScrollViewBKG] appName:[[ApplicationData getSharedInstance] getAppName]] ;
        //scrollView.sDelegate = self ;
        //[self.view addSubview:scrollView];


        //Create The first View from Array of json
        //Send our json of the first index of the array (intro)
        //NSLog(@"create First _MasterContanerView of JSON: %@", [[applicationDataContent objectForKey:@"slideshows"] objectAtIndex:0]);
        _MasterContanerView = [[CreateViewWithArray alloc] initWithArray: [[applicationDataContent objectForKey:@"slideshows"] objectAtIndex:0] setXView:(self.view.frame.size.width * 0)] ;
        [scrollView addSubview: _MasterContanerView];


            //NSLog(@"applicationDataContent = %@ " , applicationDataContent) ;
            btn_goToClose = [[Button alloc] init];
            [btn_goToClose addTarget:self action:@selector(goToCloseView:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if ([applicationDataContent objectForKey:@"companyLogo"] ) {
                if ([[applicationDataContent objectForKey:@"companyLogo"] isKindOfClass:[NSArray class]]){
                    NSArray *closingDic = [applicationDataContent objectForKey:@"companyLogo"] ;
                    if (closingDic.count == 0 ) { return ; }
                    NSDictionary *dataContent = [closingDic firstObject];
                    if ([[dataContent objectForKey:@"xPostion" ] floatValue]) {
                        logo_xPostion = [[dataContent objectForKey:@"xPostion" ] floatValue];
                    }
                    if ([[dataContent objectForKey:@"yPostion" ] floatValue]) {
                        logo_yPostion = [[dataContent objectForKey:@"yPostion"] floatValue];
                    }
                    if ([[dataContent objectForKey:@"width" ] floatValue]) {
                        logo_width    = [[dataContent objectForKey:@"width"]  floatValue];
                    }
                    if ([[dataContent objectForKey:@"height" ] floatValue]) {
                        logo_height    = [[dataContent objectForKey:@"width"]  floatValue];
                    }
                    if ([[dataContent objectForKey:@"imgPath"] isKindOfClass:[NSString class]]) {
                        NSString *imgPath =  [dataContent objectForKey:@"imgPath"];
                        UIImage *logoImage = [Image loadimageFromDocumentWithName: imgPath stringWithApplicationDidSelected: [[ApplicationData getSharedInstance] getAppName]];
                        [btn_goToClose setImage:logoImage forState:UIControlStateNormal];
                    }
                    
                }
                //CGFloat btn_xPostion = self.view.frame.size.width - logoImage.size.width ;
                //CGFloat btn_yPostion = self.view.frame.size.height - logoImage.size.height ;
                
            } else {
                NSString *companyLogo = @"ic_keyboard_arrow_right";
                if(contanerApp_companyID == 1){
                    companyLogo = @"tabukLogo.png";
                } else if (contanerApp_companyID == 2){
                    companyLogo = @"chiesi_logo.png";
                }
                 logo_xPostion = self.view.frame.size.width-110 ;
                 logo_yPostion =  self.view.frame.size.height-30 ;
                 logo_width = 100 ;
                 logo_height = 26 ;
                [btn_goToClose setImage:[UIImage imageNamed:companyLogo] forState:UIControlStateNormal];
                [[btn_goToClose imageView] setContentMode:UIViewContentModeCenter];
                
            }
             btn_goToClose.frame=CGRectMake(logo_xPostion , logo_yPostion , logo_width , logo_height);
            [self.view addSubview:btn_goToClose];

            [btn_goToClose setAlpha:0];

        btn_pdfArrow = [[Button alloc] initWithFrame:@"pdfArrow.png" :0 :0];
        btn_pdfArrow.frame=CGRectMake(500, 740, 40, 35);
        btn_pdfArrow.alpha = 0 ;
        [btn_pdfArrow  addTarget:self action:@selector(pdfViewerMethod:) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview:btn_pdfArrow];

        //NSLog(@"menuButton = %@ " , [[[ApplicationData getSharedInstance] getMENUArray] objectForKey:@"menuButton"]  );

        btn_menu  = [[Button alloc ]initWithFrame:[[[ApplicationData getSharedInstance] getMENUArray] objectForKey:@"menuButton"] :0 :700];
        [btn_menu addTarget:self action:@selector(btnMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        btn_menu.tag=0;
        btn_menu.alpha=0;
        [self.view addSubview:btn_menu];


//if ([[[[DBManager getSharedInstance] getUsername] lowercaseString] isEqualToString:@"ym"]||
//            [[[[DBManager getSharedInstance] getUsername] lowercaseString] isEqualToString:@"y"]) {
//                    Button *reloadInputView = [[Button alloc] initWithFrame:@"tabukLogo.png" :0 :20];
//                    reloadInputView.frame=CGRectMake(0, 0, 140, 140);
//                    [reloadInputView addTarget:self  action:@selector(reloadMyDataInArray:) forControlEvents:UIControlEventTouchUpInside];
//                    [self.view addSubview:reloadInputView];
//            }
//            else if ([[[[DBManager getSharedInstance] getUsername] lowercaseString] isEqualToString:@"roche"]){
//                [btn_goToClose setImage:[UIImage imageNamed:@"RoughLogo"] forState:UIControlStateNormal];
//            }
//
//        [self.view addSubview:[self open_PDFViewerWith_name:@"pdf"]] ;
//        });
        
#if TARGET_IPHONE_SIMULATOR
            //Reload Button
            Button *reloadInputView = [[Button alloc] initWithFrame:@"tabukLogo.png" :0 :20];
            reloadInputView.frame=CGRectMake(0, 0, 140, 140);
            [reloadInputView addTarget:self  action:@selector(reloadMyDataInArray:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:reloadInputView];
#endif
        });
    }

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    
//    for (id child in [[self view] subviews]) {
//        if ([child isMemberOfClass:[UIView class]]) {
//            [child removeFromSuperview];
//        }
//    }
//    for (UIView *child in [scrollView subviews]) {
//        if ([child isMemberOfClass:[UIView class]]){
//                [child removeFromSuperview];
//            }
//        }
}

-(IBAction)reloadMyDataInArray :(id)sender{
    NSLog(@"reloadMyDataInArray");

    NSString *str_StartAppName = [[ApplicationData getSharedInstance] getAppName] ;
    ApplicationData *appData = [[ApplicationData getSharedInstance] initWithApplicationName:str_StartAppName];
    [appData getMasterData];
    
    
    //send our slideshows json with Index of the slide
    //Create The other View from Array of json also
    //NSLog(@"create for reload _MasterContanerView of JSON: %@", [[applicationDataContent objectForKey:@"slideshows"] objectAtIndex:slide_Num]);
    [_MasterContanerView removeFromSuperview];
     applicationDataContent  = [[ApplicationData getSharedInstance] getMasterData ] ;
    _MasterContanerView = [[CreateViewWithArray alloc] initWithArray: [[applicationDataContent objectForKey:@"slideshows"] objectAtIndex:slide_Num] setXView:(self.view.frame.size.width * slide_Num)] ;
    [scrollView addSubview: _MasterContanerView];
}

 UIView *_MasterContanerView ;
-(void)endScroll:(int)slideNumber{
    NSLog(@"endScroll");


     if (appIsAnalytics){
          [[TimerCalculate getSharedInstance] updateSlide:startTime :slideNumber];
          slide_Num = slideNumber ;
          startTime = [[TimerCalculate getSharedInstance] TimeNow];
     }else{
          slide_Num = slideNumber ;
     }

    //Send our slideshows json with Index of the slide
    //Create The other View from Array of json also
    //NSLog(@"create new _MasterContanerView of JSON: %@", [[applicationDataContent objectForKey:@"slideshows"] objectAtIndex:slide_Num]);
    [_MasterContanerView removeFromSuperview];
    NSMutableDictionary *dicArray  = [[applicationDataContent objectForKey:@"slideshows"] objectAtIndex:slideNumber];
    _MasterContanerView = [[CreateViewWithArray alloc] initWithArray:dicArray setXView:(self.view.frame.size.width * slideNumber)] ;
    [scrollView addSubview: _MasterContanerView];
  

    if (slide_Num > 0){
        [btn_menu setAlpha:1];
        [btn_goToClose setAlpha:1];
    } else{
        [btn_menu setAlpha:0];
        [btn_goToClose setAlpha:0];
    }
    if (menuChecked) {
          [self __closeMenu];
    }
    
    // Checked If Slide Having a Refrence ......
    if ([pdfDicArray objectForKey:[NSString stringWithFormat:@"%d",slideNumber]]) {
        btn_pdfArrow.alpha = 1 ;
    }else{
        btn_pdfArrow.alpha = 0 ;
    }

    
    if (ButtonOfPDFCheck) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
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
    NSLog(@"goToCloseView");

   ClosingViewController  *clView = [self.storyboard instantiateViewControllerWithIdentifier:@"closing"];
     if ([[ApplicationData getSharedInstance] appIsAnalytics]){
          [[TimerCalculate getSharedInstance] updateSlide:startTime :slide_Num];
     }
    [self presentViewController:clView animated:NO completion:^(void){}];
}



//_______________________________-----#PDF API#-----_______________________________//

#pragma mark PDF Viewer Methods 
-(IBAction)pdfViewerMethod:(id)sender{
    NSLog(@"pdfViewerMethod");

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
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                pdfView.frame =CGRectMake(50, 620, 954, 168);
                btn_pdfArrow.transform=CGAffineTransformMakeRotation(3.1);
                btn_pdfArrow.frame=CGRectMake(500,600, btn_pdfArrow.frame.size.width ,
                                                        btn_pdfArrow.frame.size.height);
            } completion:^(BOOL finished){}];
            
            
        } else {
                // To Close PDF
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
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
    NSLog(@"setPDF_Button");
    for (UIView *buttonViews in  [pdfView subviews]) {
        [buttonViews removeFromSuperview];
    }
    for (int numOfPDF = 0 ;
         numOfPDF < [[[pdfDicArray objectForKey:[NSString stringWithFormat:@"%d",slide_Num]]
                                objectForKey:@"content"] count];
             numOfPDF ++ ) {
        
        NSString *str_ImgName  =[[[[pdfDicArray
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


        NSLog(@"%@", [pdfView subviews]);
    }
    
}

-(IBAction)showPDFView:(id)sender{
    NSLog(@"showPDFView");

    NSString * strPDF_Name = [[[[pdfDicArray
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
    NSLog(@"pdf_dismissMe");

    [pdfShow removeFromSuperview];
    [sender removeFromSuperview];
}



//------------------------------------ MENU ------------------------------------ //
//Show Menu
-(IBAction)btnMenuAction:(id)sender{

        if (!menuChecked) {

            
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
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

//Selected item in menu
-(void)didSelectMenuItem:(int)goToSlideNumber{
    
    [_MasterContanerView removeFromSuperview];
      [scrollView scrollRectToVisible:CGRectMake(self.view.frame.size.width * goToSlideNumber, 0 ,scrollView.frame.size.width, scrollView.frame.size.height) animated:false];
    
    
    NSMutableDictionary *dicArray  = [[applicationDataContent objectForKey:@"slideshows"] objectAtIndex:goToSlideNumber];
    
    _MasterContanerView = [[CreateViewWithArray alloc] initWithArray:dicArray setXView:(self.view.frame.size.width * goToSlideNumber)] ;
    [scrollView  addSubview:_MasterContanerView];
    [scrollView handelScrollViewBackgroundImage];
    [scrollView reloadInputViews];
    [self __closeMenu];
    
    //MA test
    //going to a slide from menu didn't show the correct count (of slides) + didn't show the slide itself
    slide_Num = goToSlideNumber;    //had a probelm without it
    // Checked If Slide Having a Refrence ......
    if ([pdfDicArray objectForKey:[NSString stringWithFormat:@"%d",goToSlideNumber]]) {
        btn_pdfArrow.alpha = 1 ;
    }else{
        btn_pdfArrow.alpha = 0 ;
    }
}


-(void)__closeMenu{

    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        [menuContanerView getMenuView].frame = CGRectMake(-300, 0, [menuContanerView getMenuView].frame.size.width,[menuContanerView getMenuView].frame.size.height);
        [btn_menu setFrame:CGRectMake([menuContanerView getMenuView].frame.origin.x + [menuContanerView getMenuView].frame.size.width
                                      ,[btn_menu frame].origin.y,[btn_menu frame].size.width , [btn_menu frame].size.height)];
        [scrollView setFrame:CGRectMake([menuContanerView getMenuView].frame.origin.x + [menuContanerView getMenuView].frame.size.width
                                        ,[scrollView frame].origin.y,[scrollView frame].size.width , [scrollView frame].size.height)];
    } completion:^(BOOL finished){
          menuChecked = false ;
    }];

}


//------------------------------------ Gestures Functions ------------------------------------ //
//
#pragma mark - Gesture Recognizers
//Button that force quit zooming
-(IBAction)endZooming:(id)sender
{
    NSLog(@"endZooming");

    if(scrollView.transform.a >1){

        scrollView.transform = CGAffineTransformIdentity;

        scrollView.scrollEnabled = TRUE;
        [UIView animateWithDuration:0.25 animations:^{
            //scrollView.center = CGPointMake(CGRectGetMidX(self.view.frame),
            //self.view.frame.size.height/2);
            scrollView.frame = [[[UIScreen screens] firstObject] bounds];
        }];

        [_button removeFromSuperview];
        _button = nil;
    }
}

//Move inside zooming
- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    NSLog(@"panDetected");

    if(scrollView.transform.a > 1.0){
        CGPoint translation = [panRecognizer translationInView:self.view];
        CGPoint imageViewPosition = scrollView.center;
        imageViewPosition.x += translation.x;
        imageViewPosition.y += translation.y;

        scrollView.center = imageViewPosition;
        [panRecognizer setTranslation:CGPointZero inView:self.view];
        //scrollView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        
        
        //if (scrollView.frame.origin.x >= 0 || scrollView.frame.origin.y >= 0 || scrollView.frame.origin.x*-1 >= scrollView.frame.size.width - self.view.frame.size.width || scrollView.frame.origin.y*-1 >= (scrollView.frame.size.height -self.view.frame.size.height)/2) { }

        // put bounds

        if (scrollView.frame.origin.x > 0 ) scrollView.frame = CGRectMake(0, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
        if (scrollView.frame.origin.y > 0 )scrollView.frame = CGRectMake( scrollView.frame.origin.x, 0,scrollView.frame.size.width, scrollView.frame.size.height);
        if (scrollView.frame.origin.x*-1 >= scrollView.frame.size.width - self.view.frame.size.width)
            scrollView.frame = CGRectMake( (scrollView.frame.size.width - self.view.frame.size.width) *-1, scrollView.frame.origin.y,scrollView.frame.size.width, scrollView.frame.size.height);
        if(scrollView.frame.origin.y*-1 >= scrollView.frame.size.height -self.view.frame.size.height) {
            scrollView.frame = [[[UIScreen screens] firstObject] bounds]; ;

        }

        //if ([[[UIDevice currentDevice] systemVersion] floatValue]< 8) {
        //if(scrollView.frame.origin.y*-1 >= scrollView.frame.size.height  - (258 * scrollView.transform.a) -self.view.frame.size.height)  {
        //NSLog(@"excceed");
        ///*scrollView.frame = CGRectMake( scrollView.frame.origin.x, (scrollView.frame.size.height  - (258 * scrollView.transform.a) -self.view.frame.size.height)*-1,scrollView.frame.size.width, scrollView.frame.size.height);*/
        //}
        //}

        //NSLog(@" motion %lf , imgae height : %lf  scrolling y  : %lf lastScale %lf" ,  scrollView.frame.size.width - (258 * scrollView.transform.a) - self.view.frame.size.height , scrollView.frame.size.height  , scrollView.frame.origin.y ,scrollView.transform.a);

    }else{
        [self tapDetected: [[UITapGestureRecognizer alloc]init] ];
        scrollView.frame = [[[UIScreen screens] firstObject] bounds];;
    }
    // NSLog(@"scale= %lf",currentScale);
}


CGFloat lastScale;
const CGFloat kMaxScale = 5.0;
const CGFloat kMinScale = 1.0;
CGFloat currentScale = 1.0;

//Start Zomming
- (void)pinchDetected:(UIPinchGestureRecognizer *)gestureRecognizer
{
    NSLog(@"pinchDetected");

    //NSLog(@" here %d",[gestureRecognizer state]);
    // _currentView = [gestureRecognizer view];

    //panRecognizer
    //// Reset the last scale, necessary if there are multiple objects with different scales

    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        lastScale = [gestureRecognizer scale];
    }

    if (scrollView.transform.a != 1 && !_button) {
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button.frame = CGRectMake(0, 0, 200, 50);
        [_button setTitle:@"End Zoom Mood" forState:(UIControlState)UIControlStateNormal];
        [_button addTarget:self action:@selector(endZooming:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
        [self.view addSubview:_button];
    }

    //zoomin
    else if (
             [gestureRecognizer state] == UIGestureRecognizerStateChanged) {

        scrollView.scrollEnabled= FALSE;

        currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@ "transform.scale"] floatValue];

        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 5.0;
        const CGFloat kMinScale = 1.0;

        CGFloat newScale = 1 -  (lastScale - [ gestureRecognizer scale]);
        newScale = MIN(newScale, kMaxScale / scrollView.transform.a);
        newScale = MAX(newScale, kMinScale / scrollView.transform.a);

        CGAffineTransform transform = CGAffineTransformScale(scrollView.transform, newScale, newScale);
        // [gestureRecognizer view].transform = transform;
        scrollView.transform = transform;
        lastScale = [gestureRecognizer scale];// Store the previous scale factor for the next pinch gesture call
        NSLog(@" new Scale %lf , last scale = %lf , current a %lf", newScale , lastScale, scrollView.transform.a);
    }

    else if ( scrollView.transform.a == 1){
        //zoomout
        NSLog(@"out");
        scrollView.transform = CGAffineTransformIdentity;
        // UIImageView *img =[[UIImageView alloc]initWithImage:[bkgs objectAtIndex:PageNumber]];
        scrollView.center = CGPointMake(CGRectGetMidX(self.view.bounds),self.view.frame.size.height/2);


        scrollView.scrollEnabled = TRUE;
        [_button removeFromSuperview];
        _button = nil;

    }
}


- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    NSLog(@"tapDetected");
    if (scrollView.transform.a >1){
        //CGAffineTransform balance = CGAffineTransformMakeScale(1, 1);

        //scrollView.transform = CGAffineTransformIdentity;
        //NSLog(@"scale %f , current scale %f , current a %f", 1 - currentScale * 0.1  , currentScale,  [tapRecognizer view].transform.a);


        scrollView.transform = CGAffineTransformIdentity;

        scrollView.scrollEnabled = TRUE;
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.center = CGPointMake(CGRectGetMidX(self.view.bounds),self.view.frame.size.height/2);

        }];
        [_button removeFromSuperview];
        _button = nil;
        scrollView.frame = [[[UIScreen screens] firstObject] bounds];
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
