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
} @end
@implementation ClosingViewController
char closSlideNumber  ;



int closing_companyID = 0 ;
int closing_userID = 0 ;
BOOL closing_pharmacySessionStatus = false ;
BOOL have_hospital = false ;

-(void)viewDidLoad{
     [super viewDidLoad];
    NSLog(@"__ClosingViewController");

    
    NSUserDefaults *userDefault =  [[NSUserDefaults alloc] init];
    closing_companyID = [[userDefault objectForKey:@"companyID"] intValue];
    closing_userID = [[userDefault objectForKey:@"userID"] intValue];
    closing_pharmacySessionStatus = [[userDefault objectForKey:@"pharmacySessionStatus"] boolValue] ;
    have_hospital = [userDefault objectForKey:@"haveHospital"];

     if ([[ApplicationData getSharedInstance] appIsAnalytics]){
        strTimeStart =[[TimerCalculate getSharedInstance] TimeNow];
     }
    closSlideNumber = [[ApplicationData getSharedInstance] getSlideNumber]-1;
    
    NSString *str_ClosingBKG = [[[[[ApplicationData getSharedInstance] getMasterData]
                                  objectForKey:@"slideshows"] objectAtIndex:closSlideNumber]
                                objectForKey:@"slideBKG"];
    
 
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[Image loadimageFromDocumentWithName:str_ClosingBKG
                                                                     stringWithApplicationDidSelected:[[ApplicationData getSharedInstance] getAppName]
                                                                  ]]];

}
-(void)viewDidAppear:(BOOL)animated{
     [super viewDidAppear:animated];

    NSMutableDictionary *dicArray  = [[[[ApplicationData getSharedInstance] getMasterData ] objectForKey:@"slideshows"] objectAtIndex:closSlideNumber];
//    UIView *view_Closing = [[CreateViewWithArray alloc] initWithArray:dicArray setXView:0];
    [self.view addSubview: [[CreateViewWithArray alloc] initWithArray:dicArray setXView:0]];
    

    
    Button *Btn_close_  =[[Button alloc]init];
    Btn_close_.tag=0;
     [Btn_close_ addTarget:self action:@selector(close_Tabuk:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary * applicationDataContent = [[ApplicationData getSharedInstance] getMasterData ] ;
    CGFloat logo_xPostion , logo_yPostion ,logo_width  , logo_height = 0 ;

    if ([applicationDataContent objectForKey:@"companyLogo"]) {
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
                [Btn_close_ setImage:logoImage forState:UIControlStateNormal];
            }
        }
        
    } else {
        NSString *companyLogo = @"dash_back.png";
        if(closing_companyID == 1){
            companyLogo = @"tabukLogo.png";
        } else if (closing_companyID == 2){
            companyLogo = @"chiesi_logo.png";
        }
        [Btn_close_ setImage:[UIImage imageNamed:companyLogo] forState:UIControlStateNormal];
        [[Btn_close_ imageView] setContentMode:UIViewContentModeCenter];
       
        logo_xPostion = self.view.frame.size.width-110 ;
        logo_yPostion =  self.view.frame.size.height-30 ;
        logo_width = 100 ;
        logo_height = 26 ;
        [Btn_close_ setImage:[UIImage imageNamed:companyLogo] forState:UIControlStateNormal];
        [[Btn_close_ imageView] setContentMode:UIViewContentModeCenter];
    }
    Btn_close_.frame=CGRectMake(logo_xPostion , logo_yPostion , logo_width , logo_height);
    [self.view addSubview:Btn_close_];

    
    Button *btnSync=[[Button alloc]initWithFrame:@"dash_btn_save3.png" :0 :720];
    btnSync.tag  = 0;
     if ([[ApplicationData getSharedInstance] appIsAnalytics]){
          [btnSync addTarget:self action:@selector(syncButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     } else{


          NSString *stringColor = [NSString stringWithFormat:@"%@" ,  [[[[[ApplicationData getSharedInstance] getMasterData] objectForKey:@"slideshows"] objectAtIndex:closSlideNumber] objectForKey:@"homeButtonColor"]] ;
          UIColor *btn_color = [UIColor blackColor];

          if (stringColor) {
               btn_color  = [Image _HexaColor:stringColor];
          }

          NSLog(@"stringColor = %@ ", btn_color);

          [btnSync setImage:[UIImage imageNamed:@"dash_home"] forState:UIControlStateNormal];
          [btnSync setImage:[UIImage imageNamed:@"dash_home"]  forState:UIControlStateHighlighted];
          [btnSync setTintColor:[UIColor whiteColor]];

          [btnSync setBackgroundColor:btn_color];
          [btnSync addTarget:self action:@selector(beforeDocList_backToHome:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:btnSync];
    
    
}

-(IBAction)close_Tabuk:(id)sender{
     if ([[ApplicationData getSharedInstance] appIsAnalytics]){
          [[TimerCalculate getSharedInstance] updateSlide:strTimeStart :[[[TimerCalculate getSharedInstance] arr_accu ] count ]-1];
     }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(IBAction)syncButtonAction:(id)sender
{
    if (closing_pharmacySessionStatus || have_hospital) {
        BeforeDoctorView *bDocView =  [[BeforeDoctorView alloc] init];
        bDocView._BDoc_delegate = self ;
        [self.view addSubview:bDocView];
    } else {
        // open Defualt Doctors 
        UIButton *btn = sender ;
        btn.tag = 1;
        [self goToSync:btn];
    }
    
}
-(IBAction)goToSync:(id)sender
{
    [[TimerCalculate getSharedInstance] updateSlide:strTimeStart :[[[TimerCalculate getSharedInstance] arr_accu ] count]-1];
//    NSLog(@"visit_Type = %ld " , [sender tag]);
        DoctorsViewController *dv = [self.storyboard instantiateViewControllerWithIdentifier:@"dv"];
        dv.visit_Type = [sender  tag] ;
        dv.str_SesstionID=[[NSString alloc] initWithString:[[TimerCalculate getSharedInstance] str_SessionID]];
        dv.doc_ACC=[[NSString alloc] initWithString:[[TimerCalculate getSharedInstance] getAccTime]];
        dv.doc_totalTime = [[TimerCalculate getSharedInstance] getTimeSetInApplication];
//        [self presentViewController:dv animated:YES completion:nil];
    [self presentViewController:dv animated:YES completion:^{
        [[ApplicationData getSharedInstance] clearAppData];
    }];
        return ;

}


-(void)beforeDocList_backToHome:(id)sender{
   if ([[ApplicationData getSharedInstance] appIsAnalytics]){
    [[DBManager getSharedInstance] saveSync:[[TimerCalculate getSharedInstance]  str_SessionID]
                             sync_totalTime:[NSString stringWithFormat:@"%f" , [[TimerCalculate getSharedInstance]  getTimeSetInApplication]]
                                   acc_time:[[TimerCalculate getSharedInstance]  getAccTime]
                                     doc_id:@""
                                   doc_cid :@""
                                   doc_name:@""
                                   doc_spec:@""
                               call_inquiry:@""
                             call_objection:@""
                                call_remark:@""
                                 doc_notice:@""
                                sample_drop:@""
                                 visitType : @""
     ];
   }
    HomeViewController *syncView = [self.storyboard instantiateViewControllerWithIdentifier:@"enter"];
    [self presentViewController:syncView animated:NO completion:^(void){
        [[ApplicationData getSharedInstance] clearAppData];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
