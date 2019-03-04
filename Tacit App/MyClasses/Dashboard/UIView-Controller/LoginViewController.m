
//  DashboardSQL
//
//  Created by Yahia on 2/18/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (){
@private  UIView *_loginView_ ;
@private NSArray *arr_myCompany ;
}

@end

Activity_indicator_loading *_Login_loading ;

@implementation LoginViewController

float __Login_x,__Login_y;
bool __Login_a=0;
NSString *__Login_filePath;
NSString *__Login_v;
NSURL *__Login_url;
UIView *__login_View_;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"__LoginViewController");

    
    __login_View_ = [[ UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:__login_View_];
    
    Image *_LoginBKG_ = [[Image alloc] initWithFrame:@"dash_intro_bkg.png" :0 :0];
    [__login_View_  addSubview: _LoginBKG_];
    
    Image *_Login_Title_ = [[Image alloc] initWithFrame:@"dash_intro_title.png" :50 :-50];
    [__login_View_ addSubview:_Login_Title_];
    
    Image *_Login_TacitLogo_ = [[Image alloc] initWithFrame:@"dash_logo.png" :630 :130];
    _Login_TacitLogo_.alpha = 0 ;
    [__login_View_ addSubview:_Login_TacitLogo_];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        _Login_Title_.frame = CGRectMake(_Login_Title_.frame.origin.x, 50, _Login_Title_.frame.size.width, _Login_Title_.frame.size.height) ;
    } completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:1.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        _Login_TacitLogo_.alpha = 1 ;
    } completion:^(BOOL finished){
        if (![self _Firist_Time_] ) {
            [__login_View_ addSubview:[self _LoginForm]];
        }else{
            [self _goToHoemView];
            
        }
    }];
    
}

-(void)_goToHoemView {
    HomeViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"enter"];
    [self presentViewController:homeVC animated:YES completion:nil];
}

-(BOOL)_Firist_Time_{
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] init];
    NSString *userID = [userDefault objectForKey:@"userID"];
    NSString *companyID = [userDefault objectForKey:@"companyID"];
    
    if (userID && companyID) {
        return true ;
    }
    return false;
}

-(UIView *)_LoginForm{
    
    _loginView_ = [[UIView alloc] initWithFrame:CGRectMake(640, 665, 0, 0 )];
    _loginView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_login_frame.png"] ];
    
    [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        _loginView_.frame = CGRectMake( 620, 620, 306 ,-356);
        
    } completion:^(BOOL finished){
        Image *_Logo_img_USERNAME_LOGO = [[Image alloc] initWithFrame:@"dash_p1_03.png" :50 :100];
        Image *_Logo_img_PASSWORD_LOGO = [[Image alloc] initWithFrame:@"dash_p1_04.png" :_Logo_img_USERNAME_LOGO.frame.origin.x :
                                          _Logo_img_USERNAME_LOGO.frame.size.height + _Logo_img_USERNAME_LOGO.frame.origin.y + 20 ];
        
        self.username = [[UITextField alloc] initWithFrame:CGRectMake(_Logo_img_USERNAME_LOGO.frame.origin.x + _Logo_img_USERNAME_LOGO.frame.size.width +.5, _Logo_img_USERNAME_LOGO.frame.origin.y, 170, _Logo_img_USERNAME_LOGO.frame.size.height)];
        self.username.delegate = self ;
        self.username.backgroundColor = [UIColor whiteColor];
        self.username.returnKeyType = UIReturnKeyNext ;
        self.username.keyboardType = UIKeyboardTypeEmailAddress ;
        [self.username becomeFirstResponder];
        [_loginView_ addSubview:self.username];
        
        [_loginView_ addSubview:_Logo_img_USERNAME_LOGO];
        
        //         [_loginView_ addSubview:[self btnDropMenu]];
        
        self.password = [[UITextField alloc] initWithFrame:CGRectMake(_Logo_img_PASSWORD_LOGO.frame.origin.x + _Logo_img_PASSWORD_LOGO.frame.size.width +.5, _Logo_img_PASSWORD_LOGO.frame.origin.y, 170, _Logo_img_PASSWORD_LOGO.frame.size.height)];
        self.password.backgroundColor = [UIColor whiteColor];
        self.password.secureTextEntry = YES;
        self.password.delegate = self ;
        self.password.returnKeyType = UIReturnKeyDone;
        [_loginView_ addSubview:self.password];
        
        [_loginView_ addSubview:_Logo_img_PASSWORD_LOGO];
        
        self.username.placeholder = @"USERNAME";
        self.password.placeholder = @"PASSWORD";
        
        __login_View_.frame = CGRectMake( 0 , -100 , __login_View_.frame.size.width    , __login_View_.frame.size.height);
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        Button *_btn_Login = [[Button alloc] init];
        _btn_Login .frame = CGRectMake(155,  _Logo_img_PASSWORD_LOGO.frame.size.height + _Logo_img_PASSWORD_LOGO.frame.origin.y + 20, [UIImage imageNamed:@"dash_p1_05_2.png"].size.width, [UIImage imageNamed:@"dash_p1_05_2.png"].size.height);
        [_btn_Login setBackgroundImage:[UIImage imageNamed:@"dash_p1_05_2.png"] forState:UIControlStateNormal];
        [_btn_Login setBackgroundImage:[UIImage imageNamed:@"dash_p1_05.png"] forState:UIControlStateHighlighted];
        [_btn_Login addTarget:self action:@selector(loginfun:) forControlEvents:UIControlEventTouchUpInside];
        
        [_loginView_ addSubview:_btn_Login];
    }];
    
    return _loginView_;
    
}

NSString *str_username = @"" ;

-(IBAction) loginfun:(id)sender {
    
    internetChecked *internet =[[internetChecked alloc] init];
    
    if (internet.Checked) {
        NSString *str_username = [_username.text lowercaseString];
        NSString *password = [_password.text lowercaseString];

        if(![ str_username isEqualToString:@""]&&!
           [password isEqualToString:@""] &&
           [str_username containsString:@"@"]){
            _Login_loading = [[Activity_indicator_loading alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
            [__login_View_ addSubview:_Login_loading];
            
#pragma mark - CREATE DB AND TABLES AT FIRST TIME
            // [DBManager getSharedInstance];
            [PostDataToServer checkLoginWithUsername:str_username whithPassword:password CompletionHandler:^(NSDictionary *result) {
                if (result.count != 0 && [result[@"success"]  boolValue]) {
                    NSString *userID =  result[@"id"];
                    NSString *companyID = result[@"companyID"];
                    NSString *companyName = result[@"companyName"];
                    NSString *pharmacyStatus = result[@"pharmacyWork_asSession"];
                    NSString *pharmacyTitle = result[@"pharmacyTitle"];
                    BOOL haveHospital = [result[@"haveHospital"] boolValue];
                    BOOL havePharmacy = [result[@"havePharmacy"] boolValue];
                    BOOL haveDoctor =  [result[@"haveDoctor"] boolValue];
                    BOOL haveAnalysis =  [result[@"haveAnalysis"] boolValue];

                    NSUserDefaults *userDefault =  [[NSUserDefaults alloc] init];
                    [userDefault setObject:userID forKey:@"userID"];
                    [userDefault setObject:companyID forKey:@"companyID"];
                    [userDefault setObject:pharmacyStatus forKey:@"pharmacySessionStatus"];
                    [userDefault setObject:companyName forKey:@"companyName"];
                    [userDefault setBool:haveAnalysis forKey:@"haveAnalysis"];
                    [userDefault setBool:haveHospital forKey:@"haveHospital"];
                    [userDefault setBool:havePharmacy forKey:@"havePharmacy"];
                    [userDefault setObject:pharmacyTitle forKey:@"pharmacyTitle"];
                    [userDefault setBool:haveDoctor forKey:@"haveDoctor"];
                    [userDefault synchronize];
                    
                    if (haveAnalysis) {
                        
#pragma mark - GET PRODUCT FORM SERVER
                        [GetDataFromServer getProductsWithCompanyID:companyID userID:userID CompletionHandler:^(NSDictionary *result) {
#pragma mark - REMOVE PRODUCT LIST
                    [Read_WriteJSONFile writeStringWithData:@"" fileName:@"AppsForUser"];
                            if (result.count != 0){
#pragma mark - SAVE PRODUCT ON JSON FILE
                                NSDictionary *product = @{@"product":result};
                                NSData *data = [NSJSONSerialization dataWithJSONObject:product options:NSJSONWritingPrettyPrinted error:nil];
                                NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#pragma mark - write data on json file
                                [Read_WriteJSONFile writeStringWithData:jsonStr fileName:@"AppsForUser"];
                            }

                            
                            if (haveDoctor) {
#pragma mark - GET DOCTORS FROM SERVER
                                [GetDataFromServer getDoctorWithCompanyID:companyID userID:userID CompletionHandler:^(NSDictionary *result) {
                                    if (result.count != 0){
#pragma mark - SAVE DOCTORS
                                        [[DBManager getSharedInstance] saveDoctors:result];
                                        [userDefault setBool:true forKey:@"haveDoctor"];
                                        
                                    }else {
                                        [userDefault setBool:false forKey:@"haveDoctor"];
                                    }
                                    
                                    if (havePharmacy) {
#pragma mark -get pharmacies from server
                                        [GetDataFromServer getPharmaciesWithCompanyID:companyID  userID:userID CompletionHandler:^(NSDictionary *result) {
                                            if (result.count != 0){
#pragma mark - SAVE PHARMACIES
                                                [[DBManager getSharedInstance] savePharmacies:result];
                                                [userDefault setBool:true forKey:@"havePharmacy"];
                                            }else{
                                                [userDefault setBool:false forKey:@"havePharmacy"];
                                            }
                                            if (haveHospital) {
#pragma mark - GET HOSPITAL
                                                [GetDataFromServer getHospitalsWithCompanyID:companyID  userID:userID  CompletionHandler:^(NSDictionary *result) {
                                                    if (result.count != 0) {
#pragma mark - SAVE HOSPITALS
                                                        [[DBManager getSharedInstance] saveHospitals:result];
                                                        [userDefault setBool:true forKey:@"haveHospital"];
                                                    }else{
                                                        [userDefault setBool:false forKey:@"haveHospital"];
                                                    }
#pragma mark - REMOVE INDICATORS
                                                    [_Login_loading removeFromSuperview];
                                                    [self  _goToHoemView];
                                                }];//getHospitals
                                            }else{
#pragma mark - REMOVE INDICATORS
                                                [_Login_loading removeFromSuperview];
                                                [self  _goToHoemView];
                                            }
                                        }];//Pharmacies
                                    }else
                                        if (haveHospital) {
#pragma mark - GET HOSPITAL
                                            [GetDataFromServer getHospitalsWithCompanyID:companyID  userID:userID  CompletionHandler:^(NSDictionary *result) {
                                                if (result.count != 0) {
#pragma mark - SAVE HOSPITALS
                                                    [[DBManager getSharedInstance] saveHospitals:result];
                                                    [userDefault setBool:true forKey:@"haveHospital"];
                                                }else{
                                                    [userDefault setBool:false forKey:@"haveHospital"];
                                                }
#pragma mark - REMOVE INDICATORS
                                                [_Login_loading removeFromSuperview];
                                                [self  _goToHoemView];
                                            }];//getHospitals
                                        }else{
#pragma mark - REMOVE INDICATORS
                                            [_Login_loading removeFromSuperview];
                                            [self  _goToHoemView];
                                        }
                                    
                                    
                                }];//getDoctor
                            }else{
                                if (havePharmacy) {
#pragma mark -get pharmacies from server
                                    [GetDataFromServer getPharmaciesWithCompanyID:companyID  userID:userID CompletionHandler:^(NSDictionary *result) {
                                        if (result.count != 0){
#pragma mark - SAVE PHARMACIES
                                            [[DBManager getSharedInstance] savePharmacies:result];
                                            [userDefault setBool:true forKey:@"havePharmacy"];
                                        }else{
                                            [userDefault setBool:false forKey:@"havePharmacy"];
                                        }
                                        if (haveHospital) {
#pragma mark - GET HOSPITAL
                                            [GetDataFromServer getHospitalsWithCompanyID:companyID  userID:userID  CompletionHandler:^(NSDictionary *result) {
                                                if (result.count != 0) {
#pragma mark - SAVE HOSPITALS
                                                    [[DBManager getSharedInstance] saveHospitals:result];
                                                    [userDefault setBool:true forKey:@"haveHospital"];
                                                }else{
                                                    [userDefault setBool:false forKey:@"haveHospital"];
                                                }
#pragma mark - REMOVE INDICATORS
                                                [_Login_loading removeFromSuperview];
                                                [self  _goToHoemView];
                                            }];//getHospitals
                                        }else{
#pragma mark - REMOVE INDICATORS
                                            [_Login_loading removeFromSuperview];
                                            [self  _goToHoemView];
                                        }
                                    }];//Pharmacies
                                }else
                                    if (haveHospital) {
#pragma mark - GET HOSPITAL
                                        [GetDataFromServer getHospitalsWithCompanyID:companyID  userID:userID  CompletionHandler:^(NSDictionary *result) {
                                            if (result.count != 0) {
#pragma mark - SAVE HOSPITALS
                                                [[DBManager getSharedInstance] saveHospitals:result];
                                                [userDefault setBool:true forKey:@"haveHospital"];
                                            }else{
                                                [userDefault setBool:false forKey:@"haveHospital"];
                                            }
#pragma mark - REMOVE INDICATORS
                                            [_Login_loading removeFromSuperview];
                                            [self  _goToHoemView];
                                        }];//getHospitals
                                    }else{
#pragma mark - REMOVE INDICATORS
                                        [_Login_loading removeFromSuperview];
                                        [self  _goToHoemView];
                                    }
                            }
                            
                            
                        }];//getProducts
                    }else {
                        // if no have Analysis enter to home view
#pragma mark - GET PRODUCT FORM SERVER
                        [GetDataFromServer getProductsWithCompanyID:companyID userID:userID CompletionHandler:^(NSDictionary *result) {
                            if (result.count != 0){
#pragma mark - SAVE PRODUCT ON JSON FILE
                                NSDictionary *product = @{@"product":result};
                                NSData *data = [NSJSONSerialization dataWithJSONObject:product options:NSJSONWritingPrettyPrinted error:nil];
                                NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#pragma mark - write data on json file
                                [Read_WriteJSONFile writeStringWithData:jsonStr fileName:@"AppsForUser"];
                            }
                            [self  _goToHoemView];

                        }
                         ];
                        return;
                    }
                    
                }//result count // Success Checked
                else {
                    
                    [AlertController showAlertWithSingleButton:@"Okay"
                                       presentOnViewController:self
                                                    alertTitle:@"Info"
                                                  alertMessage:@"Invalid username or password. "];
                    
                    [_Login_loading removeFromSuperview];
                    
                }
            }];
            
            
        }else {
            
            [AlertController showAlertWithSingleButton:@"Okay"
                               presentOnViewController:self
                                            alertTitle:@"Info"
                                          alertMessage:@"Please enter username and password. "];
            
            [_Login_loading removeFromSuperview];
        }
    }else{
        
        [AlertController showAlertWithSingleButton:@"Okay"
                           presentOnViewController:self
                                        alertTitle:@"Info"
                                      alertMessage:@"No internet connection."];
        
    }
    
}


-(void)getProductsFromServerWithCompanyID :(NSString*) comp_id  userID:(NSString*) uid {

}
-(void)getDcotorsFromServerWithCompanyID :(NSString*) comp_id  userID:(NSString*) uid {
    
}
-(void)getPharmaciessFromServerWithCompanyID :(NSString*) comp_id  userID:(NSString*) uid {
    
}
-(void)getHospitalsFromServerWithCompanyID :(NSString*) comp_id  userID:(NSString*) uid {
    
}
/*
 -(void) SoapRequest:(id)Request didFinishWithData:(NSMutableDictionary *)dict
 {
 SoapRequest *s = Request;
 
 for (NSDictionary *d in s.Dicts){
 if(d[@"success"] ){
 if([d[@"success"] isEqualToString:@"true"]){
 //insert user name and password in DB
 
 NSString *strUid=[[NSString alloc] initWithFormat:@"%@",d[@"id"]];
 NSString *login_str_companyInsert =@"" ;
 if (company_id == 1 ) {
 login_str_companyInsert = @"tabuk";
 }else if (company_id == 2){
 login_str_companyInsert = @"chiesi";
 }else if(company_id == 3 ){
 login_str_companyInsert =@"dermazon" ;
 }
 
 GetUserProductFromServer *getUsers = [[GetUserProductFromServer alloc] init:strUid];
 getUsers.delegate = self ;
 
 //   [GetUserProductFromServer get_userApps:strUid];
 
 
 }else{
 [AlertController showAlertWithSingleButton:@"Okay"
 presentOnViewController:self
 alertTitle:@"Info"
 alertMessage:@"Invalid username or password."];
 [_Login_loading removeFromSuperview];
 }
 
 }
 
 }
 
 }*/

-(void)didFinshFeatchProduct{
    //[GetAllDoctorsFromServer get_Doc] ;
    [_Login_loading removeFromSuperview];
    
    [self _goToHoemView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [_password becomeFirstResponder];
    }else if (textField.returnKeyType == UIReturnKeyDone) {
        [self loginfun:nil];
    }
    return YES;
}
-(void)onKeyboardHide:(NSNotification *)notification{
    
    __login_View_.frame = CGRectMake( 0 , 0 , 1024 , 768);
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    __login_View_.frame = CGRectMake( 0 , -150 , __login_View_.frame.size.width    , __login_View_.frame.size.height);
}





/*
 
 UIView *dropMenuContant ;
 Button *MenuFirst_btn ;
 
 
 #pragma mark - Drop Menu Button
 -(Button *)btnDropMenu {
 
 arr_myCompany =@[@"@\tSelect ▼",@"@\tTabuk ▲",@"@\tChiesi ▲",@"@Dermazon ▲"];
 numberOfSelect = 0 ;
 
 MenuFirst_btn = [[Button alloc] init];
 MenuFirst_btn.tag = 0 ;
 [MenuFirst_btn setFrame:CGRectMake(self.username.frame.origin.x + self.username.frame.size.width,
 self.username.frame.origin.y ,
 140, self.username.frame.size.height)];
 MenuFirst_btn.backgroundColor = [UIColor blackColor];
 [MenuFirst_btn setTitle:arr_myCompany[numberOfSelect] forState:UIControlStateNormal];
 [MenuFirst_btn addTarget:self action:@selector(login_openCloseDropMenu:) forControlEvents:UIControlEventTouchUpInside];
 
 return MenuFirst_btn ;
 }
 
 -(IBAction)login_openCloseDropMenu:(id)sender{
 
 if ([sender tag] == 0) {
 if (!dropMenuContant) {
 
 dropMenuContant  = [[UIView alloc] initWithFrame:CGRectMake([sender frame].origin.x,
 [sender frame].origin.y + [sender frame].size.height,
 [sender frame].size.width,
 ( [sender frame].size.height * ([arr_myCompany count] + 1) ) )];
 dropMenuContant.hidden = YES ;
 dropMenuContant .backgroundColor = [UIColor grayColor];
 [_loginView_ addSubview:dropMenuContant];
 
 Button *btn_Tabuk = [[Button alloc] initWithFrame:CGRectMake(0, 0, dropMenuContant.frame.size.width, 50)];
 [btn_Tabuk setTitle:arr_myCompany[1] forState:UIControlStateNormal];
 
 Button *btn_Chiesi = [[Button alloc] initWithFrame:CGRectMake(0, btn_Tabuk.frame.size.height + btn_Tabuk.frame.origin.y , dropMenuContant.frame.size.width, btn_Tabuk.frame.size.height)];
 [btn_Chiesi setTitle:arr_myCompany[2] forState:UIControlStateNormal];
 
 Button *btn_Dermazon = [[Button alloc] initWithFrame:CGRectMake(0, btn_Chiesi.frame.size.height + btn_Chiesi.frame.origin.y , dropMenuContant.frame.size.width, btn_Tabuk.frame.size.height)];
 [btn_Dermazon setTitle:arr_myCompany[3] forState:UIControlStateNormal];
 
 
 btn_Tabuk.tag = 1 ;
 btn_Chiesi.tag = 2 ;
 btn_Dermazon.tag = 3 ;
 [btn_Tabuk addTarget:self action:@selector(login_openCloseDropMenu:) forControlEvents:UIControlEventTouchUpInside];
 [btn_Chiesi addTarget:self action:@selector(login_openCloseDropMenu:) forControlEvents:UIControlEventTouchUpInside];
 [btn_Dermazon addTarget:self action:@selector(login_openCloseDropMenu:) forControlEvents:UIControlEventTouchUpInside];
 
 [dropMenuContant addSubview:btn_Tabuk];
 [dropMenuContant addSubview:btn_Chiesi];
 [dropMenuContant addSubview:btn_Dermazon];
 dropMenuContant.hidden  = NO ;
 
 }else {
 if (dropMenuContant.hidden)   dropMenuContant.hidden = NO ;
 else dropMenuContant.hidden = YES ;
 }
 
 }else{
 numberOfSelect = [sender tag];
 [MenuFirst_btn setTitle:arr_myCompany[numberOfSelect] forState:UIControlStateNormal];
 dropMenuContant.hidden = YES ;
 }
 }
 */
@end
