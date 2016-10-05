
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
    BOOL loginChecked =[[DBManager getSharedInstance] chekLogin] ;
    return loginChecked ;
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


int company_id ;
NSString *str_username = @"" ;

-(IBAction) loginfun:(id)sender {

    internetChecked *internet =[[internetChecked alloc] init];
    
    if (internet.Checked) {
        
        if(![_username.text isEqualToString:@""]&&!
           [_password.text isEqualToString:@""] &&
           [_username.text containsString:@"@"]){
            
            _Login_loading = [[Activity_indicator_loading alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
            [__login_View_ addSubview:_Login_loading];
            
            NSString *function = @"checkLogin";
            NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com/m"];
            NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
            if (data) {
                
                NSRange postion = [_username.text rangeOfString:@"@"];
                str_username = [[_username.text substringToIndex:postion.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                NSString *company_name = [[_username.text  substringFromIndex:postion.location + 1] lowercaseString];
                if ([company_name isEqualToString:@"tabuk"]) {
                    company_id = 1 ;
                }else if ([company_name isEqualToString:@"chiesi"]){
                    company_id = 2 ;
                }else if (([company_name isEqualToString:@"dermazone"])){
                    company_id = 3 ;
                }
                
                
                SoapRequest *soapR = [[SoapRequest alloc] initWithFunction:function company_id:company_id];
                soapR.delegate=self;

                
//                NSLog(@"str_username = %@" , company_id );

                NSDictionary *par = @{@"username":str_username , @"password":_password.text};
                [soapR sendRequestWithAttributes:par];
            }
        }else {

             [AlertController showAlertWithSingleButton:@"Okay"
                                                presentOnViewController:self
                                             alertTitle:@"Info"
                                            alertMessage:@"Please Enter Username and Password "];
            
            [_Login_loading removeFromSuperview];
        }
    }else{
        
        [AlertController showAlertWithSingleButton:@"Okay"
                           presentOnViewController:self
                                        alertTitle:@"Info"
                                      alertMessage:@"no internet connection "];
        
    }

}

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
                
                
                [[DBManager getSharedInstance]saveUsername:str_username
                                                  password:_password.text userID:strUid
                                                   company:login_str_companyInsert];

                [Read_WriteJSONFile writeStringWithData: @"{\"apps\":[{ \"name\":\"Selphyl\" ,\"appID\":\"1\", \"version\":\"3\" },{ \"name\":\"Piramyl\" ,\"appID\":\"68\", \"version\":\"3\" },{\"name\":\"Bilobil\",\"appID\":\"2\", \"version\":\"1\"},{\"name\":\"Omiz\",\"appID\":\"3\", \"version\":\"4\"}]}"
                                               fileName:@"AppsForUser"];
                [GetAllDoctorsFromServer get_Doc] ;
                [self _goToHoemView];
                
                
            }
            else{
                
                [AlertController showAlertWithSingleButton:@"Okay"
                                   presentOnViewController:self
                                                alertTitle:@"Info"
                                              alertMessage:@"invalid user name or password"];
            }
            [_Login_loading removeFromSuperview];
        }
    }
}

-(void)SoapRequest:(id)Request didFinishWithError:(int)ErrorCode{
    NSLog(@"Error here ");
}

- (void)didReceiveMemoryWarning
{
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
