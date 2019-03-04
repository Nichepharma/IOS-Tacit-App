//
//  BeforeDoctorView.m
//  Atimos
//
//  Created by Yahia on 1/3/16.
//  Copyright © 2016 nichepharma. All rights reserved.
//

#import "BeforeDoctorView.h"
#import "Header.h"
@implementation BeforeDoctorView
Button  *btn_enterBtn,
        *btn_doctors,
        *btn_hospital;

UIButton *btn_pharmacy ;
SEL callMethods ;
-(id)init{
    CGRect frame =  CGRectMake(0, 0, 1024, 768);
    self = [super initWithFrame:frame];
    
    NSLog(@"__BeforeDoctorView");
    
    if (self) {
     
        [self setFrame];
        callMethods = @selector(homeButtonActions:) ;
            [self buttonsCreate];
        
    }
    
    return self;
}
-(id)initWithReload{
    CGRect frame =  CGRectMake(0, 0, 1024, 768);
    self = [super initWithFrame:frame];
    if (self) {
      [self setFrame];
             callMethods  =  @selector(_DocReloaded:);
            [self buttonsCreate];
   
    }
    
    return self;
    
}

-(void)setFrame {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_general_bkg.png"]];
    
    Image *img_Doctor_Title = [[Image alloc] initWithFrame:@"activity.png" :420 :25];
    [self addSubview:img_Doctor_Title];
    Image *tacc_Doctors = [[Image alloc] initWithFrame:@"dash_logo.png" :700 :620];
    [self addSubview:tacc_Doctors];
    
    
    [btn_doctors removeFromSuperview];
    [btn_hospital removeFromSuperview];
    [btn_pharmacy removeFromSuperview];
    
    
    btn_enterBtn=[[Button alloc] initWithFrame:@"dash_Notifi.png" : 400 :200];
    //        btn_enterBtn.tag=0;
    //[btn_enterBtn addTarget:self action:@selector(homeButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_enterBtn];

    Button *syncView_btn_home =[[Button alloc] initWithFrame:@"dash_home.png" :50 :27];
    syncView_btn_home.tag = 1;
    [syncView_btn_home addTarget:self action:@selector(_backToHome:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:syncView_btn_home];


}
-(void)buttonsCreate {
    NSUserDefaults *df = [[NSUserDefaults alloc] init];
    BOOL haveDoctor   = [[df objectForKey:@"haveDoctor"] boolValue];
    BOOL haveHospital = [[df objectForKey:@"haveHospital"] boolValue];
    BOOL havePharmacy = [[df objectForKey:@"havePharmacy"] boolValue];
  
    float enter_Btn_Dur = 0 ;
    
    if (haveDoctor) {
        
        btn_doctors =[[Button alloc] initWithFrame:@"dash_btn_privateMarket.png" :400 :270];
        btn_doctors.tag=1  ;
        [btn_doctors addTarget:self action:callMethods forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_doctors];
        btn_doctors.alpha=0;
        [UIView animateWithDuration:1 delay:enter_Btn_Dur +=  .3  options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            btn_doctors.alpha=1;
            btn_doctors.frame = CGRectMake(180, btn_doctors.frame.origin.y, btn_doctors.frame.size.width, btn_doctors.frame.size.height);
        } completion:^(BOOL finished){
            
        }];
        
    }
    
    if (haveHospital) {
        if (haveHospital) {
            btn_hospital =[[Button alloc] initWithFrame:@"dash_btn_hospitalMarket.png" :400 : 270 + 77];
            btn_hospital.tag= 2 ;
            [btn_hospital addTarget:self action:callMethods forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn_hospital];
            btn_hospital.alpha=0;
            [UIView animateWithDuration:1 delay:   enter_Btn_Dur+=.3  options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                btn_hospital.alpha=1;
                btn_hospital.frame = CGRectMake(180, btn_hospital.frame.origin.y, btn_hospital.frame.size.width, btn_hospital.frame.size.height);
                
            } completion:^(BOOL finished){
                
            }];
        }
    }
   
    if (havePharmacy) {
        
        NSString *str_pharmacyTitle = @"Pharmacy";
        NSUserDefaults *userDefault =  [[NSUserDefaults alloc] init];
        str_pharmacyTitle = [userDefault objectForKey:@"pharmacyTitle"];
        if (!str_pharmacyTitle) {
            str_pharmacyTitle = @"Pharmacy";
            
        }
        
        UIImage *imgPharmacyImageBKG = [UIImage imageNamed:@"dash_btn_pharmMarket.png"];
        btn_pharmacy = [[UIButton alloc]init];
        [btn_pharmacy setBackgroundImage:imgPharmacyImageBKG forState:UIControlStateNormal];
        btn_pharmacy.frame = CGRectMake(400,  270 + 77 + (77) , imgPharmacyImageBKG.size.width, imgPharmacyImageBKG.size.height);
        [btn_pharmacy setTitle: str_pharmacyTitle forState:UIControlStateNormal];
//        [btn_pharmacy titleLabel].font = [UIFont boldSystemFontOfSize:20];
        [btn_pharmacy setTintColor:[UIColor whiteColor]];
        btn_pharmacy.alpha = 0 ;
        btn_pharmacy.tag = 3 ;
        [btn_pharmacy.titleLabel setFont:[UIFont fontWithName:@"NeoSans-Medium"  size:0]];
        [btn_pharmacy.titleLabel setFont:[UIFont systemFontOfSize:26.0]];
//        btn_pharmacy.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn_pharmacy.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100);

        
        [btn_pharmacy addTarget:self action:callMethods forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn_pharmacy];
        [UIView animateWithDuration:1 delay: enter_Btn_Dur + 0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            btn_pharmacy.alpha=1;
            btn_pharmacy.frame = CGRectMake(180, btn_pharmacy.frame.origin.y, btn_pharmacy.frame.size.width, btn_pharmacy.frame.size.height);
        } completion:^(BOOL finished){
            
        }];
        
    }
    
        [self addSubview:btn_enterBtn];
    
}
-(IBAction)homeButtonActions:(id)sender{
    [self._BDoc_delegate goToSync:sender];
}
-(IBAction)_DocReloaded:(id)sender{
    [self._BDoc_delegate reloadDoctorView:sender];

}
-(IBAction)_backToHome:(id)sender{
    [self._BDoc_delegate beforeDocList_backToHome:sender];

}


@end
