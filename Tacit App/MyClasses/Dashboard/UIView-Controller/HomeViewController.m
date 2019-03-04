//
//  GetAllDoctorsFromServer.m
//  DashboardSQL
//
//  Created by Yahia on 2/18/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "HomeViewController.h"
#import "Download_Remove_Content.h"
#import "AppDetails/AppDetailsController.h"
#import <SDWebImage/UIImageView+WebCache.h>




@interface HomeViewController ()<_DownloadContentDelegate>{

@private    NSMutableDictionary * dictionaryOf_userApplications;
@private    NSMutableArray *home_btn_Apps ;
@private    Activity_indicator_loading *home_loader ;
@private    Image *img_noti ;
@private    BOOL isReallyMakeDownload ;
@private     _ScrollingView *home_userApp_scrollView ;
@private    char numberOfProjectSelected ;
@private  internetChecked *home_netChecked ;

}@end

int home_companyID = 0 ;
int home_userID =0;
BOOL haveAnalysis = false ;
NSString *pharmacySessionStatus = false ;
NSString *str_pharmacyTitle = @"Pharmacy";

@implementation HomeViewController
 static bool displayAlert = true ;
NSDictionary *home_liveServerAppsVersion;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"__HomeViewController");

    //Get the directory so we can 
#if TARGET_IPHONE_SIMULATOR
    // where are you?
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
    
    
    home_liveServerAppsVersion  =  [GetDataFromServer serverApps_InfoArray];

    home_loader = [[Activity_indicator_loading alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    NSUserDefaults *userDefault =  [[NSUserDefaults alloc] init];
    home_userID = [[userDefault objectForKey:@"userID"] intValue];
    home_companyID = [[userDefault objectForKey:@"companyID"] intValue] ;
    pharmacySessionStatus = [userDefault objectForKey:@"pharmacySessionStatus"] ;
    str_pharmacyTitle = [userDefault objectForKey:@"pharmacyTitle"];
    haveAnalysis = [[userDefault objectForKey:@"haveAnalysis"] boolValue];

    
    if (!str_pharmacyTitle) {
        str_pharmacyTitle = @"Pharmacy";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        // WARNING: is the cell still using the same data by this point??
        
        //Check internet
        home_netChecked = [[internetChecked alloc] init];
        //[GetAllDoctorsFromServer get_Doc] ;
        
        
#pragma mark - get rep application from json file in decument
        dictionaryOf_userApplications = [[NSMutableDictionary alloc]initWithDictionary:[Read_WriteJSONFile readJsonFileWithName:@"AppsForUser"]];
        //NSLog(@"dictionaryOf_userApplications %@ ", dictionaryOf_userApplications);
        Image *bkg_Enter = [[Image  alloc] initWithFrame:@"dash_general_bkg.png" :0 :0];
        [self.view addSubview:bkg_Enter];
        
        Image *img_enter_Title = [[Image alloc] initWithFrame:@"dash_welcome.png" :450 :25];
        [self.view addSubview:img_enter_Title];
        
        home_userApp_scrollView = [[_ScrollingView alloc] init ];
        home_btn_Apps = [[NSMutableArray alloc] init];
        
        home_userApp_scrollView.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
        home_userApp_scrollView.contentSize = CGSizeMake((10 *[[dictionaryOf_userApplications objectForKey:@"product"] count] + 10 ) + (100 * [[dictionaryOf_userApplications objectForKey:@"product"] count])
                                                         , home_userApp_scrollView.frame.size.height);
        [home_userApp_scrollView  setShowsHorizontalScrollIndicator:NO];
        [self.view addSubview:home_userApp_scrollView];
        
        if (haveAnalysis) {
            Button * btn_enter_syncn  =[[Button alloc]initWithFrame:@"dash_btn_sync.png" :900 :25];
            btn_enter_syncn.tag=1;
            [btn_enter_syncn addTarget:self action:@selector(enter_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn_enter_syncn];
        }
        
        
        Button *btn_enter_logout =[[Button alloc]initWithFrame:@"dash_btn_relogin.png" :50 :25];
        btn_enter_logout.tag=2;
        [btn_enter_logout addTarget:self action:@selector(enter_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn_enter_logout];
        
        Image *tacc = [[Image alloc] initWithFrame:@"dash_logo.png" :700 :600];
        [self.view addSubview:tacc];
        
        Button *appManagement = [[Button alloc] initWithFrame:[NSString stringWithFormat:@"ic_file_download"] : 20  : 700 ];
        [appManagement addTarget:self action:@selector(goToAppManagement:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:appManagement];
        
        [self applicationButton];
        
        
        
    });

//    NSLog(@"Pharm = %@" ,[[DBManager getSharedInstance] getAllPharmacies]);
//    [GetAllDoctorsFromServer get_Doc];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    dispatch_async(dispatch_get_main_queue(), ^{
    if (!img_noti) {
        if ([pharmacySessionStatus boolValue] == false ) {
            UIImage *imgPharmacyImageBKG = [UIImage imageNamed:@"dash_btn_pharmMarket.png"];
            UIButton *btn_pharmacyButton = [[UIButton alloc]init];
            [btn_pharmacyButton setBackgroundImage:imgPharmacyImageBKG forState:UIControlStateNormal];
            btn_pharmacyButton.frame = CGRectMake(400, 350, imgPharmacyImageBKG.size.width, imgPharmacyImageBKG.size.height);
            [btn_pharmacyButton setTitle: str_pharmacyTitle forState:UIControlStateNormal];
            [btn_pharmacyButton titleLabel].font = [UIFont boldSystemFontOfSize:20];
            [btn_pharmacyButton setTintColor:[UIColor whiteColor]];
            btn_pharmacyButton.alpha = 0 ;
            [btn_pharmacyButton addTarget:self
                                action:@selector(openPharmacyView:)
                                forControlEvents: UIControlEventTouchUpInside];
            [self.view addSubview:btn_pharmacyButton];
            [btn_pharmacyButton.titleLabel setFont:[UIFont fontWithName:@"NeoSans-Medium"  size:0]];
            [btn_pharmacyButton.titleLabel setFont:[UIFont systemFontOfSize:26.0]];
            //        btn_pharmacy.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn_pharmacyButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100);
            [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                   btn_pharmacyButton.alpha = 1 ;
                btn_pharmacyButton.frame =  CGRectMake(120, btn_pharmacyButton.frame.origin.y , btn_pharmacyButton.frame.size.width , btn_pharmacyButton.frame.size.height);
            } completion:^(BOOL finished){}];
        }


    img_noti =  [[Image alloc ] initWithFrame:@"dash_Motifi.png" :350 :180];
    img_noti.frame =  CGRectMake(700, 590, 50, 50);
    [self.view addSubview:img_noti];
        [self.view addSubview:home_loader];

    [img_noti setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go_toNotificationsView:)];
    [singleTap setNumberOfTapsRequired:1];
    [img_noti addGestureRecognizer:singleTap];


    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            img_noti.frame =  CGRectMake(350, 200, 419, 463);
    } completion:^(BOOL finished){
            [self msgItem] ;
   }];

   }
         });


    [self checkedProducts];

    NSString *strAppVersion =  @"1.8";
    @try {
        strAppVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    } @catch (NSException *exception) {
        NSLog(@"exception %@ " , exception);
    }
    UILabel *lblVersion = [[UILabel alloc] initWithFrame:CGRectMake(100, 700, 100, 100)];
    [lblVersion setText: [NSString stringWithFormat:@"version %@" , strAppVersion]];
    [lblVersion setTextColor:[UIColor darkGrayColor]];
    [[self view] addSubview:lblVersion];

// [self applicationButton];
}


//MARK: application icon [download and open application] button
//For loop at the product and start putting the buttons
-(void)applicationButton{


      for (UIButton *btn in [home_userApp_scrollView  subviews]) {
          [btn removeFromSuperview];
      }
    
    for (int i = 0 ; i < [[dictionaryOf_userApplications objectForKey:@"product"] count] ; i++) {
     
        NSString *appName = [[[dictionaryOf_userApplications objectForKey:@"product"] objectAtIndex:i] objectForKey:@"pName"] ;
        //NSLog(@"Apps %@ ",appName);
        UIButton *btnUserApps = [[UIButton alloc] init];
        btnUserApps.frame =  CGRectMake((110 * i) + 10, 0, 100 ,  100) ;
        btnUserApps.tag = i ;
        [btnUserApps setImage:[UIImage imageNamed:@"appIco.png"] forState:UIControlStateNormal];
        [home_btn_Apps addObject:btnUserApps];
          dispatch_async(dispatch_get_main_queue(), ^{
        //image on server replaces any space to {- dash}
        //in code replace string to -
        NSString *str_imageUrl = [NSString stringWithFormat:@"http://www.tacitapp.com/Yahia/appIcon/%@.png", [appName stringByReplacingOccurrencesOfString:@" " withString:@"-"]] ;
        
        NSURL *imgURL = [[NSURL alloc] initWithString:str_imageUrl];
        //NSLog(@"image url %@ ",imgURL);

        if ([Download_Remove_Content checkExistFileWithFileName:[[[dictionaryOf_userApplications objectForKey:@"product"] objectAtIndex:i] objectForKey:@"pName"]]) {
            [btnUserApps addTarget:self action:@selector(home_userApp_Action:) forControlEvents:UIControlEventTouchUpInside];
            UILongPressGestureRecognizer *btn_LongPress_gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(home_RemoveApp:)];
            btn_LongPress_gesture.minimumPressDuration  = 1 ;
            [btnUserApps addGestureRecognizer:btn_LongPress_gesture];

            // [self checkApplicationUpdate];
        }else{
            [btnUserApps addTarget:self action:@selector(home_DownloadUserApp_Action:) forControlEvents:UIControlEventTouchUpInside];
            [btnUserApps setAlpha:.4];
        }

        [btnUserApps setTitle:appName forState:UIControlStateNormal];
        btnUserApps.titleLabel.tintColor = UIColor.blackColor ;
        [btnUserApps setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnUserApps setImage:[UIImage imageNamed:[NSString stringWithFormat:@"appIco.png" ]]  forState: UIControlStateNormal];


     SDWebImageManager *manager = [SDWebImageManager sharedManager];

  [manager downloadImageWithURL:imgURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                    }
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) { 
                                             [btnUserApps setImage:image  forState: UIControlStateNormal];
                                        }
                                   }];

        [home_userApp_scrollView addSubview:btnUserApps];
          });
    }

}

-(IBAction)openPharmacyView:(id)sender{
    // tabuk pharmacy
    [[TimerCalculate getSharedInstance]init_fire:0];
    [[ApplicationData getSharedInstance] setAppName:@"Pharmacy"];
    DoctorsViewController *dv = [self.storyboard instantiateViewControllerWithIdentifier:@"dv"];
    dv.visit_Type = 3 ;
    dv.str_SesstionID = [[TimerCalculate getSharedInstance] str_SessionID];
    dv.doc_ACC = @"0";
    dv.doc_totalTime = 0;
    [self presentViewController:dv animated:YES completion:nil];

}
-(IBAction)go_toNotificationsView:(id)sender{
    /*
    NotificationViewController *noti=[self.storyboard instantiateViewControllerWithIdentifier:@"notificationView"];
    [self presentViewController:noti animated:YES completion:nil];
     */
}
-(IBAction)goToAppManagement:(id)sender{
    if ([home_netChecked Checked]) {
        AppDetailsController *app=[self.storyboard instantiateViewControllerWithIdentifier:@"appManagVC"];
    [self presentViewController:app animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"No internet connection."
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil , nil];
        [alert show];

    }
}

-(IBAction)enter_buttonAction:(id)sender{
    UIButton *btn = sender;
    if (btn.tag==0) {
      
    }else if (btn.tag==1){
        SyncViewController *sync=[self.storyboard instantiateViewControllerWithIdentifier:@"sync"];
                            sync.isComeFromHomeViewController = true ;
        [self presentViewController:sync animated:NO completion:^(void){}];
        
    }else if (btn.tag==2){
        
        if (home_netChecked.Checked) {

            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:NSLocalizedString(@"Message", nil)
                                                  message:NSLocalizedString(@"Are you sure you want to re-login?\r  NB : All unsynchronized calls will be deleted.", nil)
                                                  preferredStyle:UIAlertControllerStyleActionSheet | UIAlertControllerStyleAlert] ;
            
                UIAlertAction *delete_Action = [UIAlertAction
                                               actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                               style:UIAlertActionStyleDestructive
                                               handler:^(UIAlertAction *action)
                                               {
#pragma mark - REMOVE PRODUCT LIST
                                                   [Read_WriteJSONFile writeStringWithData:@"" fileName:@"AppsForUser"];

                                                   [[DBManager getSharedInstance] deleteAllDB];
                                                   NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
                                                   NSDictionary * dict = [defs dictionaryRepresentation];
                                                   for (id key in dict) {
                                                       [defs removeObjectForKey:key];
                                                   }
                                                   [defs synchronize];
                                                   LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
                                                   [self presentViewController:loginVC  animated:true  completion:nil];
                                                 
                                               }];


                UIAlertAction *cancel_Action = [UIAlertAction
                                                actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                style:UIAlertActionStyleCancel
                                            handler:nil];

            [alertController addAction:delete_Action];
            [alertController addAction:cancel_Action];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            
        }else{
            [AlertController showAlertWithSingleButton:@"Okay"
                             presentOnViewController:self
                                          alertTitle:@"Info"
                                          alertMessage:@"No internet connection."];
        }
    }
}


#pragma mark - Go To Contaner ViewController
//! if user really downloaded application
-(IBAction)home_userApp_Action:(id)sender{
    
    dispatch_queue_t queue = dispatch_queue_create("myqueue", NULL);
    dispatch_async(queue, ^{
        // create UIwebview, other things too
        // Perform on main thread/queue
        dispatch_async(dispatch_get_main_queue(), ^{
            numberOfProjectSelected = [sender tag];
            if ([Download_Remove_Content checkExistFileWithFileName:[[[dictionaryOf_userApplications objectForKey:@"product"] objectAtIndex:[sender tag]] objectForKey:@"pName"]] &&
                !isReallyMakeDownload){
                NSString *str_StartAppName = [NSString stringWithFormat:@"%@" , [[[dictionaryOf_userApplications objectForKey:@"product"] objectAtIndex:[sender tag]] objectForKey:@"pName"]] ;
                
                ApplicationData *appData = [[ApplicationData getSharedInstance] initWithApplicationName:str_StartAppName];
                [appData getMasterData];
                ContanerAppView *conView = [self.storyboard instantiateViewControllerWithIdentifier:@"contanerView"];
                if ([[ApplicationData getSharedInstance] appIsAnalytics]){
                    [[TimerCalculate getSharedInstance]init_fire:[[ApplicationData getSharedInstance] getSlideNumber] + 1 ];
                }
                
                [self presentViewController:conView animated:YES completion:nil] ;
            }
        
        });
    });
    
    
 
}

#pragma mark - Go To Download Application
//! if user not  Download Application
-(IBAction)home_DownloadUserApp_Action:(id)sender{
      numberOfProjectSelected = [sender tag];
    if (![Download_Remove_Content checkExistFileWithFileName:[[[dictionaryOf_userApplications objectForKey:@"product"] objectAtIndex:[sender tag]] objectForKey:@"pName"]] &&
                        !isReallyMakeDownload) {
  
    home_loader = [[Activity_indicator_loading alloc] initWithFrame:CGRectMake(0, 0, [sender frame].size.width, [sender frame].size.height)];
    home_loader.backgroundColor = [UIColor whiteColor];
    [sender addSubview:home_loader];
    
    //get application name to download
    NSString *str_DownloadAppName = [NSString stringWithFormat:@"%@" , [[[dictionaryOf_userApplications objectForKey:@"product"] objectAtIndex:[sender tag]] objectForKey:@"pName"]] ;
   
        Download_Remove_Content  *downContent = [[Download_Remove_Content alloc] init];
        downContent.downloadDelegate = self ;
        [downContent _StartDownloadFromServer:str_DownloadAppName];

    [sender setAlpha:1];
    [sender addTarget:self action:@selector(home_userApp_Action:)forControlEvents:UIControlEventTouchUpInside];
    isReallyMakeDownload = true ;
        
    }
}





#pragma mark - fire Download Delegate
-(void)didStartDownloadContanet{}

-(void)didFinshDownloadContanet:(NSString *)file_name{
     for (int i = 0 ; i < [[dictionaryOf_userApplications objectForKey:@"product"] count] ; i++) {
     NSString *temp_appName =  [[[dictionaryOf_userApplications  objectForKey:@"product"] objectAtIndex:i]objectForKey:@"pName"];
     NSString *temp_appID =  [[[dictionaryOf_userApplications  objectForKey:@"product"] objectAtIndex:i]objectForKey:@"pid"];
     
     if ([[temp_appName lowercaseString] isEqualToString:[file_name lowercaseString]]) {
     
     if (![home_liveServerAppsVersion objectForKey:[file_name localizedCapitalizedString]] ) {
     
     return;
     }
     
     NSDictionary *arr_newData =  @{ @"pName"    : file_name ,
     @"pid"   : temp_appID ,
     @"version" : [home_liveServerAppsVersion objectForKey:[file_name localizedCapitalizedString]]  ,
     };
     // remove old data
     [[dictionaryOf_userApplications  objectForKey:@"product"] removeObjectAtIndex:i];
     [[dictionaryOf_userApplications  objectForKey:@"product"] insertObject:arr_newData atIndex:i];
     NSError * err;
     NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dictionaryOf_userApplications options:0 error:&err];
     NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
//     NSLog(@"%@",myString);
     
     [Read_WriteJSONFile writeStringWithData:myString fileName:@"AppsForUser"];
     
     
     return;
     }
     }
 }
-(void)didFinshDownloadContanet{
    
    [home_loader stop];
    [home_loader removeFromSuperview];
    UILongPressGestureRecognizer *btn_LongPress_gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(home_RemoveApp:)];
    btn_LongPress_gesture.minimumPressDuration  = 1.5 ;
    [[home_btn_Apps objectAtIndex:1]  addGestureRecognizer:btn_LongPress_gesture];
    isReallyMakeDownload = false ;
   
}-(void)didFinshDownloadContanetWithError{
    [AlertController showAlertWithSingleButton:@"Cancel" presentOnViewController:self alertTitle:@"Info" alertMessage:@"Download error ."];
    [home_loader stop];
    [home_loader removeFromSuperview];
    isReallyMakeDownload = false ;
    [[home_btn_Apps objectAtIndex:numberOfProjectSelected] setAlpha:.4];
    [[home_btn_Apps objectAtIndex:numberOfProjectSelected] addTarget:self action:@selector(home_DownloadUserApp_Action:)forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Show Motifiations
//! -------------------------Motifiations---------------------------------//
//! only showing Motifiations

-(void)msgItem{

    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
    NSDictionary *motificationArray = [[userDefault objectForKey:@"motification"] mutableCopy];
    
    if (!motificationArray && [home_netChecked Checked] ) {
        [GetDataFromServer getMotificationCompanyID: [NSString stringWithFormat:@"%d",home_companyID]  userID:[NSString stringWithFormat:@"%d",home_userID]   productID:0
                                  CompletionHandler:^(NSDictionary *result) {
           [userDefault setObject: result  forKey:@"motification"];
           [userDefault synchronize] ;
           [self setNotificationView:result];

        }];//getMotification
    
    }else {
        [self setNotificationView:motificationArray];
    }
  
}
-(void)setNotificationView : (NSDictionary *)_enter_arrMotifations{
    UIColor *_fontColor ;
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
    
    int __CalcMonth  = (int)[components month];
    if ([components day]>15) {
        if ([components month] >=8) {
            __CalcMonth = __CalcMonth - 8  ;
            
        }else{
            __CalcMonth =  (__CalcMonth *2) -2 ;
        }
        
    }else  if ([components day]<15) {
        if ([components month] >=8) {
            __CalcMonth = __CalcMonth - 7  ;
            
        }else{
            __CalcMonth = (__CalcMonth *2) -1 ;
        }
    }
    NSString *strMSG = @"" ;
    
    if ([[_enter_arrMotifations objectForKey:@"msg"] count] > __CalcMonth ) {
        strMSG = [[_enter_arrMotifations objectForKey:@"msg"] objectAtIndex:__CalcMonth] ;
    }else{
        strMSG = [[_enter_arrMotifations objectForKey:@"msg"] objectAtIndex:0] ;
    }
    
    _fontColor = [UIColor whiteColor];
    
    Label *lbl = [[Label alloc] initWithFrame:CGRectMake((img_noti.frame.size.width/2 )-((img_noti.frame.size.width-70) /2) , 40, img_noti.frame.size.width-100, img_noti.frame.size.height-200) :[strMSG uppercaseString]:500];
    lbl.center =  CGPointMake(img_noti.frame.size.width / 2, img_noti.frame .size.height / 2 -25    );
    lbl.font = [UIFont systemFontOfSize:36] ;
    //    lbl.backgroundColor = [UIColor redColor];
    lbl.adjustsFontSizeToFitWidth  = YES;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor =   _fontColor;
    [img_noti addSubview:lbl];
    
    
    [home_loader removeFromSuperview];
}

- (void) shakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue]) {
        UIView* item = (__bridge UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}
#pragma mark - Remove Application 
/*! Delete Application 
    * ask user are he sure whant to delete contant application from Document Path
    * get button tag
    * get application name from dictionaryOf_userApplications array with useing button tag
    * call [removeApplication: application_name] from Download_Remove_Content class
*/
-(IBAction)home_RemoveApp:(id)sender{
    
    UIAlertController *deleteApp_alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Message", nil)
                                          message:NSLocalizedString(@"Delete product ?", nil)
                                          preferredStyle:UIAlertControllerStyleActionSheet | UIAlertControllerStyleAlert] ;
    
    UIAlertAction *delete_Action = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Yes", @"will Delete ")
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction *action)
                                    {
                                        UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
                                        int appNumber = (int)recognizer.view.tag;
                                        NSString *appName =[NSString stringWithFormat:@"%@" , [[[dictionaryOf_userApplications objectForKey:@"product"] objectAtIndex:appNumber] objectForKey:@"pName"]] ;
                                        
                                        [[home_btn_Apps objectAtIndex:appNumber] setAlpha:.4];
                                        [[home_btn_Apps objectAtIndex:appNumber] addTarget:self
                                                                                    action:@selector(home_DownloadUserApp_Action:)
                                                                                    forControlEvents:UIControlEventTouchUpInside];
                                        [Download_Remove_Content removeApplication: appName];
                                        [home_userApp_scrollView addSubview:[home_btn_Apps objectAtIndex:appNumber]];

                                          numberOfProjectSelected = appNumber ;
                                    
                                    }];
    
    UIAlertAction *cancel_Action = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                    style:UIAlertActionStyleCancel
                                    handler:nil];
    
    
    [deleteApp_alertController addAction:delete_Action];
    [deleteApp_alertController addAction:cancel_Action];
    [self presentViewController:deleteApp_alertController animated:YES completion:nil];
    

}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -Check Update
//-(BOOL)checkApplicationUpdate {
//    
//    if ([home_netChecked Checked]) {
//        NSLog(@"App Version = %@",dictionaryOf_userApplications);
//        return true;
//    }
//    return false ;
//}


-(void)checkedProducts{
    dispatch_async(dispatch_get_main_queue(), ^{

        internetChecked *internet =[[internetChecked alloc] init];
        
        if (internet.Checked && displayAlert) {
            displayAlert = false ;
            NSDictionary *appDetailOnServer = [Read_WriteJSONFile readJsonfromServer:@"http://www.tacitapp.com/Yahia/tacitapp/appVersion.txt"];
            NSDictionary *dic_userApplications = [[[NSMutableDictionary alloc]initWithDictionary:[Read_WriteJSONFile readJsonFileWithName:@"AppsForUser"]] objectForKey:@"product"] ;
            
            for ( NSDictionary *appDic in dic_userApplications ) {
                NSString *app_versionOnServer =  [appDetailOnServer objectForKey:[[appDic objectForKey:@"pName"] localizedCapitalizedString]] ;
                NSString *appVersion = [appDic objectForKey:@"version"];
                
                if ([appVersion doubleValue] < [app_versionOnServer doubleValue] && [Download_Remove_Content checkExistFileWithFileName:[appDic objectForKey:@"pName"]]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                    message:@"Update to the latest version now."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Done"
                                                          otherButtonTitles:nil , nil];
                    [alert show];
                    
                    break;
                }
                
            }
        }
        
    });
}
-(void)SoapRequest:(id)Request didFinishWithData:(NSMutableDictionary *)dict{
//    NSLog(@"My apps is %@",dict);
    [home_loader removeFromSuperview];

}
-(void)SoapRequest:(id)Request didFinishWithError:(int)ErrorCode{
     [home_loader removeFromSuperview];
}



-(void) getApplicationFromServer{
    
#pragma mark - GET PRODUCT FORM SERVER
    [GetDataFromServer getProductsWithCompanyID:[NSString stringWithFormat:@"%d",home_companyID] userID:[NSString stringWithFormat:@"%d",home_userID]  CompletionHandler:^(NSDictionary *result) {
#pragma mark - REMOVE PRODUCT LIST
        [Read_WriteJSONFile writeStringWithData:@"" fileName:@"AppsForUser"];
        if (result.count != 0){
#pragma mark - SAVE PRODUCT ON JSON FILE
            NSDictionary *product = @{@"product":result};
            NSData *data = [NSJSONSerialization dataWithJSONObject:product options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#pragma mark - write data on json file
            [Read_WriteJSONFile writeStringWithData:jsonStr fileName:@"AppsForUser"];
#pragma mark - get rep application from json file in decument
            dictionaryOf_userApplications = [[NSMutableDictionary alloc]initWithDictionary:[Read_WriteJSONFile readJsonFileWithName:@"AppsForUser"]];
            
            [self applicationButton];
            
        }
    }];
}

@end
