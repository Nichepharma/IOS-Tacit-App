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


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    home_netChecked = [[internetChecked alloc] init];
    [GetAllDoctorsFromServer get_Doc] ;



    #pragma mark - get rep application from json file in decument
    dictionaryOf_userApplications = [[NSMutableDictionary alloc]initWithDictionary:[Read_WriteJSONFile readJsonFileWithName:@"AppsForUser"]];

    Image *bkg_Enter = [[Image  alloc] initWithFrame:@"dash_general_bkg.png" :0 :0];
    [self.view addSubview:bkg_Enter];
    
    Image *img_enter_Title = [[Image alloc] initWithFrame:@"dash_welcome.png" :450 :25];
    [self.view addSubview:img_enter_Title];
    
    home_userApp_scrollView = [[_ScrollingView alloc] init ];
    home_btn_Apps = [[NSMutableArray alloc] init];

    for (int i = 0 ; i < [[dictionaryOf_userApplications objectForKey:@"apps"] count] ; i++) {
        NSString *appName = [[[dictionaryOf_userApplications objectForKey:@"apps"] objectAtIndex:i] objectForKey:@"name"] ;
        NSLog(@"Apps %@ ",appName);
        Button *btnUserApps = [[Button alloc] initWithFrame:[NSString stringWithFormat:@"appIco.png"] :(110 * i) + 10  :0 ];
             btnUserApps.frame =  CGRectMake((110 * i) + 10, 0, 100, 100) ;
             btnUserApps.tag = i ;
        [home_btn_Apps addObject:btnUserApps];





        NSURL *imgURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.tacitapp.com/Yahia/appIcon/%@.png",appName]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imgURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//            if ( data == nil )
//                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                [btnUserApps setImage:[UIImage imageWithData: data]  forState: UIControlStateNormal];
            });
        }];

        if ([Download_Remove_Content checkExistFileWithFileName:[[[dictionaryOf_userApplications objectForKey:@"apps"] objectAtIndex:i] objectForKey:@"name"]]) {
             [btnUserApps addTarget:self action:@selector(home_userApp_Action:) forControlEvents:UIControlEventTouchUpInside];
            UILongPressGestureRecognizer *btn_LongPress_gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(home_RemoveApp:)];
            btn_LongPress_gesture.minimumPressDuration  = 1.5 ;
            [btnUserApps addGestureRecognizer:btn_LongPress_gesture];
            
//            [self checkApplicationUpdate];
        }else{
             [btnUserApps addTarget:self action:@selector(home_DownloadUserApp_Action:) forControlEvents:UIControlEventTouchUpInside];
            [btnUserApps setAlpha:.4];
        }
       
            [home_userApp_scrollView addSubview:btnUserApps];
      
    }

    home_userApp_scrollView.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    home_userApp_scrollView.contentSize = CGSizeMake((10 *[[dictionaryOf_userApplications objectForKey:@"apps"] count] + 10 ) + (100 * [[dictionaryOf_userApplications objectForKey:@"apps"] count])
                                                                        , home_userApp_scrollView.frame.size.height);
    [home_userApp_scrollView  setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:home_userApp_scrollView];
    
    
     Button *btn_enter_logout,*btn_enter_syncn ;
            btn_enter_syncn  =[[Button alloc]initWithFrame:@"dash_btn_sync.png" :900 :25];
            btn_enter_syncn.tag=1;
    [btn_enter_syncn addTarget:self action:@selector(enter_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_enter_syncn];

    btn_enter_logout  =[[Button alloc]initWithFrame:@"dash_btn_relogin.png" :50 :25];
    btn_enter_logout.tag=2;
    [btn_enter_logout addTarget:self action:@selector(enter_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_enter_logout];
    
    Image *tacc = [[Image alloc] initWithFrame:@"dash_logo.png" :700 :600];
    [self.view addSubview:tacc];
   
    Button *appManagement = [[Button alloc] initWithFrame:[NSString stringWithFormat:@"ic_file_download"] : 20  : 700 ];
    [appManagement addTarget:self action:@selector(goToAppManagement:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:appManagement];

    [self checkedProducts];
}


-(void)viewDidAppear:(BOOL)animated{
    if (!img_noti) {
    img_noti =  [[Image alloc ] initWithFrame:@"dash_Motifi.png" :350 :180];
    img_noti.frame =  CGRectMake(700, 590, 50, 50);
    [self.view addSubview:img_noti];

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
}
-(IBAction)go_toNotificationsView:(id)sender{
    
    NotificationViewController *noti=[self.storyboard instantiateViewControllerWithIdentifier:@"notificationView"];
    [self presentViewController:noti animated:YES completion:nil];
}
-(IBAction)goToAppManagement:(id)sender{
    if ([home_netChecked Checked]) {
        AppDetailsController *app=[self.storyboard instantiateViewControllerWithIdentifier:@"appManagVC"];
    [self presentViewController:app animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"Sorry no internet connection"
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
                                                  message:NSLocalizedString(@"Are you sure you want to Re-login again ? \r  NB : 'All unsynchronized calls will be deleted.'", nil)
                                                  preferredStyle:UIAlertControllerStyleActionSheet | UIAlertControllerStyleAlert] ;
            
                UIAlertAction *delete_Action = [UIAlertAction
                                               actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                               style:UIAlertActionStyleDestructive
                                               handler:^(UIAlertAction *action)
                                               {
                                          
                                                NSFileManager *fileManager = [NSFileManager defaultManager];
                                                NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                NSString *documentsDirectorys = [path objectAtIndex:0];
                                                NSString *fullPath = [documentsDirectorys  stringByAppendingPathComponent:@"tacit.db"];
                                                [fileManager removeItemAtPath: fullPath error:NULL];
                                                exit(0);
                                                       
                                                   
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
                                          alertMessage:@"Sorry no internet connection"];
        }
        
        
    
    }

    
    
    
}







#pragma mark - Go To Contaner ViewController
//! if user really downloaded application
-(IBAction)home_userApp_Action:(id)sender{
    numberOfProjectSelected = [sender tag];
    if ([Download_Remove_Content checkExistFileWithFileName:[[[dictionaryOf_userApplications objectForKey:@"apps"] objectAtIndex:[sender tag]] objectForKey:@"name"]] &&
        !isReallyMakeDownload){
        
     NSString *str_StartAppName =[NSString stringWithFormat:@"%@" , [[[dictionaryOf_userApplications objectForKey:@"apps"] objectAtIndex:[sender tag]] objectForKey:@"name"]] ;
    ApplicationData *appData = [[ApplicationData getSharedInstance] initWithApplicationName:str_StartAppName];
                    [appData getMasterData];
        
    ContanerAppView *conView =[self.storyboard instantiateViewControllerWithIdentifier:@"contanerView"];
    [[TimerCalculate getSharedInstance]init_fire:[[ApplicationData getSharedInstance] getSlideNumber] + 1 ];
    [self presentViewController:conView animated:YES completion:nil] ;
}
}

#pragma mark - Go To Download Application
//! if user not  Download Application
-(IBAction)home_DownloadUserApp_Action:(id)sender{
      numberOfProjectSelected = [sender tag];
    if (![Download_Remove_Content checkExistFileWithFileName:[[[dictionaryOf_userApplications objectForKey:@"apps"] objectAtIndex:[sender tag]] objectForKey:@"name"]] &&
                        !isReallyMakeDownload) {
  
    home_loader = [[Activity_indicator_loading alloc] initWithFrame:CGRectMake(0, 0, [sender frame].size.width, [sender frame].size.height)];
    home_loader.backgroundColor = [UIColor whiteColor];
    [sender addSubview:home_loader];
    
        //get application name to download
    NSString *str_DownloadAppName = [NSString stringWithFormat:@"%@" , [[[dictionaryOf_userApplications objectForKey:@"apps"] objectAtIndex:[sender tag]] objectForKey:@"name"]] ;
   
        Download_Remove_Content  *downContent = [[Download_Remove_Content alloc] init];
                            downContent.downloadDelegate = self ;
                            [downContent _StartDownloadFromServer:str_DownloadAppName];

    [sender setAlpha:1];
    [sender addTarget:self action:@selector(home_userApp_Action:)forControlEvents:UIControlEventTouchUpInside];
    isReallyMakeDownload = true ;
        
    }
}





#pragma mark - fire Download Delegate
-(void)didStartDownloadContanet{
    
    
}
-(void)didFinshDownloadContanet:(NSString *)file_name{

}
-(void)didFinshDownloadContanet{
    [home_loader stop];
    [home_loader removeFromSuperview];
    UILongPressGestureRecognizer *btn_LongPress_gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(home_RemoveApp:)];
    btn_LongPress_gesture.minimumPressDuration  = 1.5 ;
    [[home_btn_Apps objectAtIndex:1]  addGestureRecognizer:btn_LongPress_gesture];
    isReallyMakeDownload = false ;
   
}-(void)didFinshDownloadContanetWithError{
    [AlertController showAlertWithSingleButton:@"Cancel" presentOnViewController:self alertTitle:@"Info" alertMessage:@"Error to Download Files ... "];
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

//
//    
//    NSString *valueToSave = @"someValue";

//    

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *_enter_arrMotifations = [[prefs objectForKey:@"motification"] mutableCopy];
    
    if (!_enter_arrMotifations && [home_netChecked Checked]) {
        _enter_arrMotifations = [Read_WriteJSONFile readJsonfromServer:@"http://tacitapp.com/Yahia/Motification/motification.json"];
        [[NSUserDefaults standardUserDefaults] setObject:_enter_arrMotifations forKey:@"motification"];
        [[NSUserDefaults standardUserDefaults] synchronize] ;
    }
    
    UIColor *_fontColor ;
    
          NSDate *currentDate = [NSDate date];
          NSCalendar* calendar = [NSCalendar currentCalendar];
          NSDateComponents* components = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
          
          int __CalcMonth  =[components month];
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
    NSString *strMSG = [[_enter_arrMotifations objectForKey:@"msg"] objectAtIndex:__CalcMonth] ;
            _fontColor = [UIColor whiteColor];
    
    Label *lbl = [[Label alloc] initWithFrame:CGRectMake((img_noti.frame.size.width/2 )-((img_noti.frame.size.width-70) /2) , 40, img_noti.frame.size.width-100, img_noti.frame.size.height-200) :[strMSG uppercaseString]:500];
    lbl.center =  CGPointMake(img_noti.frame.size.width / 2, img_noti.frame .size.height / 2 -25    );
       lbl.font = [UIFont systemFontOfSize:36] ;
//    lbl.backgroundColor = [UIColor redColor];
    lbl.adjustsFontSizeToFitWidth  = YES;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor =   _fontColor;
    [img_noti addSubview:lbl];
 
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
                                          message:NSLocalizedString(@"Are you sure you want to Re-login again ? \r  NB : 'All unsynchronized calls will be deleted.'", nil)
                                          preferredStyle:UIAlertControllerStyleActionSheet | UIAlertControllerStyleAlert] ;
    
    UIAlertAction *delete_Action = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Yes", @"will Delete ")
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction *action)
                                    {
                                        UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
                                        int appNumber = recognizer.view.tag;
                                        NSString *appName =[NSString stringWithFormat:@"%@" , [[[dictionaryOf_userApplications objectForKey:@"apps"] objectAtIndex:appNumber] objectForKey:@"name"]] ;
                                        
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
    internetChecked *internet =[[internetChecked alloc] init];
    
    if (internet.Checked) {

       NSDictionary *appDetailOnServer = [Read_WriteJSONFile readJsonfromServer:@"http://www.tacitapp.com/Yahia/tacitapp/appVersion.txt"];
        NSDictionary *dic_userApplications = [[[NSMutableDictionary alloc]initWithDictionary:[Read_WriteJSONFile readJsonFileWithName:@"AppsForUser"]] objectForKey:@"apps"] ;

        for ( NSDictionary *appDic in dic_userApplications ) {
            NSString *app_versionOnServer =  [appDetailOnServer objectForKey:[[appDic objectForKey:@"name"] localizedCapitalizedString]] ;
            NSString *appVersion = [appDic objectForKey:@"version"];

            if ([appVersion doubleValue] < [app_versionOnServer doubleValue] ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                message:@"You have a new version update . please check verstion Updates"
                                                                delegate:self
                                                                cancelButtonTitle:@"Done"
                                                      otherButtonTitles:nil , nil];
                [alert show];

                break;
            }

        }
    }
}
-(void)SoapRequest:(id)Request didFinishWithData:(NSMutableDictionary *)dict{
    NSLog(@"My apps is %@",dict);
}
-(void)SoapRequest:(id)Request didFinishWithError:(int)ErrorCode{
    
}



@end
