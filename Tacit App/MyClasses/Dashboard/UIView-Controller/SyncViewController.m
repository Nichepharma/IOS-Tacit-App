//
//  SyncViewController.m
//  DashboardSQL
//
//  Created by Yahia on 2/23/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "SyncViewController.h"
#import "BeforeDoctorView.h"

@interface SyncViewController ()<_BeforeDocView >

//@property (nonatomic,strong) SendSyncSession *sendS;
@end

@implementation SyncViewController

//NSInteger numberOfRows;
viewSessionDetails *sd ;
NSDictionary *sync_Dic  ;
UITableView *tv_data;
Button *syncView_btn_syncAll  ;

int sync_companyID = 0 ;
int sync_userID = 0 ;
BOOL sync_pharmacyStatus = false;
BOOL sync_have_hospital = false ;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"__SyncViewController");

    
    
    NSUserDefaults *userDefault =  [[NSUserDefaults alloc] init];
    sync_companyID = [[userDefault objectForKey:@"companyID"] intValue];
    sync_userID = [[userDefault objectForKey:@"userID"] intValue];
    sync_pharmacyStatus = [[userDefault objectForKey:@"pharmacySessionStatus"] boolValue];
    sync_have_hospital = [userDefault objectForKey:@"haveHospital"];

    if (self.isComeFromHomeViewController) {
        sync_Dic = [[DBManager getSharedInstance] getAllSyncSessionByAppID: @"" ] ;
    }else{
        sync_Dic = [[DBManager getSharedInstance] getAllSyncSessionByAppID: [[ApplicationData getSharedInstance] getApplicationID]] ;
    }


    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_general_bkg.png"]]];
    Image *img_Doctor_Title = [[Image alloc] initWithFrame:@"dash_sync_title.png" :420 :25];
    [self.view addSubview:img_Doctor_Title];
    Image *tacc_Sync = [[Image alloc] initWithFrame:@"dash_logo.png" :700 :620];
    [self.view addSubview:tacc_Sync];
    
    
    //btn_close =[[Button alloc] initWithFrame:@"dash_btn_close.png" :900 :27];
    //btn_close.tag=0;
    //[btn_close addTarget:self action:@selector(syncActionButton:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:btn_close];


    Button *syncView_btn_home =[[Button alloc] initWithFrame:@"dash_home.png" :50 :27];
    syncView_btn_home.tag = 1;
    [syncView_btn_home addTarget:self action:@selector(syncActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:syncView_btn_home];

    syncView_btn_syncAll = [[Button alloc] initWithFrame:@"syncall_btn_save4.jpeg" :900 :20 ];
    syncView_btn_syncAll.tag = 1;
    [syncView_btn_syncAll addTarget:self action:@selector(syncAllActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [syncView_btn_syncAll setHidden:true];
    [self.view addSubview:syncView_btn_syncAll];
    
    // numberOfRows =[[[[DBManager getSharedInstance] getAllSyncSession] objectForKey:@"sync_id"] count];
    
    Label *lblSession_title = [[Label alloc] initWithFrame:CGRectMake(160,80, 250, 50) :@"Session Date" :20];
    [lblSession_title setTextAlignment:NSTextAlignmentCenter];
    [lblSession_title setTextColor:[UIColor grayColor]];
    [self.view addSubview:lblSession_title];

    Label *lblAppName_title = [[Label alloc] initWithFrame:CGRectMake(610,80, 250, 50) :@"Product Name" :20];
    [lblAppName_title setTextAlignment:NSTextAlignmentCenter];
    [lblAppName_title setTextColor:[UIColor grayColor]];
    [self.view addSubview:lblAppName_title];

    Label *lblStatus_title = [[Label alloc] initWithFrame:CGRectMake(880 ,80, 90, 50) :@"Status" :20];
    [lblStatus_title setTextAlignment:NSTextAlignmentCenter];
    [lblStatus_title setTextColor:[UIColor grayColor]];
    [self.view addSubview:lblStatus_title];

    [tv_data removeFromSuperview];
    tv_data = [[UITableView alloc] initWithFrame:CGRectMake(50,100, 910, 500)];
    tv_data.center = CGPointMake(1024/2, 768/2);
    tv_data.delegate =self;
    tv_data.dataSource = self;
    tv_data.bounces    = false ;
    tv_data.backgroundColor=[UIColor clearColor];
    tv_data.superview.backgroundColor = [UIColor clearColor];
    tv_data.userInteractionEnabled = YES;

    tv_data.separatorColor = [UIColor clearColor];
    
    [self.view addSubview:tv_data];

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [syncView_btn_syncAll setHidden:[self hiddenSyncAllButton] ] ;

}

-(BOOL)hiddenSyncAllButton{
    
    
    for (int index = 0 ; index < [[sync_Dic objectForKey:@"sync_id"] count] ; index ++) {
        // CHEKED FEEDBACK DATA
        if ([[[sync_Dic objectForKey:@"sample_drop"]objectAtIndex:index] isEqualToString:@""]
            ||[[[sync_Dic objectForKey:@"call_objection"]objectAtIndex:index] isEqualToString:@""]
            || [[[sync_Dic objectForKey:@"call_remark"]objectAtIndex:index] isEqualToString:@""]
            ){
            continue ;
            
        }
        return false;
    }
    
    return  true ;
}
-(IBAction)syncActionButton:(id)sender{
    Button *btn = sender ;
    
    if (btn.tag==0) {
        exit(0);
    }else if (btn.tag==1){
        HomeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"enter"];
        [self presentViewController:home animated:NO completion:^(void){}];
    }
}

#pragma TableView API
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"Synchronize";
//}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //The Row Numbers
    return [[sync_Dic objectForKey:@"sync_id"] count] ;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];


    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (!cell) cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (!cell) { cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    
    if (indexPath.row %2 != 0 )cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_blue_heder.png"]];
    else cell.backgroundColor = [UIColor whiteColor];

    
    NSString *strCellText ;
    strCellText=[[NSString alloc] initWithFormat:@"%li. : %@",indexPath.row+1,[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:indexPath.row]];
    
 
    NSString *docString =[[sync_Dic objectForKey:@"name"] objectAtIndex:indexPath.row];
    NSArray* doc_Array = [docString componentsSeparatedByString: @"|"];
    NSString *docSpec = [[sync_Dic objectForKey:@"spec"] objectAtIndex:indexPath.row];
    NSArray* docSpecArray = [docSpec componentsSeparatedByString: @"|"];
    
    if ([doc_Array count]-1>1) {
        NSString *str =[[NSString alloc]initWithFormat:@"%@ - %@ and more doctors ...",[doc_Array objectAtIndex:0],[docSpecArray objectAtIndex:0]];
        cell.detailTextLabel.text=str;
    }else{
        NSString *str = [[NSString alloc] initWithFormat:@"%@ - %@",[doc_Array objectAtIndex:0],[docSpecArray objectAtIndex:0]];
        cell.detailTextLabel.text=str;
    }

    cell.textLabel.text=strCellText;
   
    NSString *str_app_name =[[sync_Dic objectForKey:@"app_name"] objectAtIndex:indexPath.row];
    Label *lbl_app_name = [[Label alloc] initWithFrame:CGRectMake(600, 0, 150 , cell.frame.size.height) :str_app_name :14];
    [lbl_app_name setTextAlignment:NSTextAlignmentCenter];
    [cell.contentView addSubview:lbl_app_name];

    Button *btnCell= [[Button alloc] initWithFrame:@"dash_sync_btn_feedback" :850 :0];
    btnCell.frame = CGRectMake(835 , 0 , btnCell.frame.size.width +30 , cell.frame.size.height);
    btnCell.tag=indexPath.row;
    //btnCell.backgroundColor=[UIColor blackColor];
    [cell.contentView addSubview:btnCell];
    btnCell.accessibilityLabel=[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:indexPath.row];
    
    if ([docString isEqualToString:@""] || [docSpec isEqualToString:@""]) {
        [btnCell setImage:[UIImage imageNamed:@"ic_person"] forState:UIControlStateNormal];
        [btnCell addTarget:self action:@selector(editDoctors:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([[[sync_Dic objectForKey:@"sample_drop"]objectAtIndex:indexPath.row] isEqualToString:@""]
        ||[[[sync_Dic objectForKey:@"call_objection"]objectAtIndex:indexPath.row] isEqualToString:@""]
        || [[[sync_Dic objectForKey:@"call_remark"]objectAtIndex:indexPath.row] isEqualToString:@""]
        )
    {
        [btnCell setImage:[UIImage imageNamed:@"dash_sync_btn_feedback"] forState:UIControlStateNormal];
        [btnCell addTarget:self action:@selector(buttonActionFeedback:) forControlEvents:UIControlEventTouchUpInside];

    }else{
        
        [btnCell setImage:[UIImage imageNamed:@"dash_sync_send.png"] forState:UIControlStateNormal];
        [btnCell addTarget:self action:@selector(buttonActionSync:) forControlEvents:UIControlEventTouchUpInside];
        cell.imageView.image= [UIImage imageNamed:@"dash_btn_edit.png"];
        [cell.imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editFeedbacks:)];
        tapped.numberOfTapsRequired = 1;
        cell.imageView.tag= indexPath.row;
        [cell.imageView addGestureRecognizer:tapped];
        cell.imageView.transform = CGAffineTransformMakeScale(5,5);
        
    }
    
    //document_edit.png
    cell.textLabel.textColor = [ Image _HexaColor:@"4d4d4d"] ;
    cell.detailTextLabel.textColor = [ Image _HexaColor:@"4d4d4d"];
}
    return cell;
    
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



NSString *sync_strVisitTime ;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    //yahia
    
    sync_strVisitTime =@"";
    sync_strVisitTime=[[NSString alloc] initWithFormat:@"%@",[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:indexPath.row]];
    
    NSString *strMSG_Alert =[[NSString alloc] initWithFormat: @"Are you sure you want to delete? \r '%@' ? " ,sync_strVisitTime];
    UIAlertView* message = [[UIAlertView alloc]initWithTitle: @"Message" message: strMSG_Alert
                                                    delegate: self
                                           cancelButtonTitle: @"Cancel" otherButtonTitles: @"Yes", nil];
    [message show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [[DBManager getSharedInstance] deleteSyncData:sync_strVisitTime];

        if (self.isComeFromHomeViewController) {
            sync_Dic = [[DBManager getSharedInstance] getAllSyncSessionByAppID: @"" ] ;
        }else{
            sync_Dic = [[DBManager getSharedInstance] getAllSyncSessionByAppID: [[ApplicationData getSharedInstance] getApplicationID]] ;
        }
        [syncView_btn_syncAll setHidden:[self hiddenSyncAllButton] ] ;

    }

    [tv_data removeFromSuperview];
    tv_data = [[UITableView alloc] initWithFrame:CGRectMake(50,100, 910, 500)];
    tv_data.center = CGPointMake(1024/2, 768/2);
    tv_data.delegate =self;
    tv_data.dataSource = self;
    tv_data.bounces    = false ;
    tv_data.backgroundColor=[UIColor clearColor];
    tv_data.superview.backgroundColor = [UIColor clearColor];
    tv_data.separatorColor = [UIColor clearColor];

    [self.view addSubview:tv_data];

    sync_strVisitTime=@"";
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

-(IBAction)buttonActionFeedback:(id)sender{

    Button *btn =sender;
    FeedViewController *feeds = [self.storyboard instantiateViewControllerWithIdentifier:@"feed"];
    feeds.strVisitTime=[[NSString alloc] initWithFormat:@"%@",[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:btn.tag]];
    feeds.strfeed_sample = @"0" ;
    feeds._isPharmacy = [[[sync_Dic objectForKey:@"app_name"] objectAtIndex:btn.tag] isEqualToString:@"Pharmacy"] ? true : false ;
    feeds._HomeViewStatus = self.isComeFromHomeViewController ;
    feeds.strAPP_name  = [[sync_Dic objectForKey:@"app_name"] objectAtIndex:btn.tag] ;
    [self presentViewController:feeds animated:NO completion:^(void){}];
    
}
bool isStellContectToServer = false ;
-(IBAction)buttonActionSync:(id)sender{
    internetChecked *check = [[internetChecked alloc] init];
    if (check.Checked) {
        if (!isStellContectToServer) {
         
            isStellContectToServer = true ;
            [sender removeFromSuperview];

            Button *btn = sender;
            int index  = (int) btn.tag;

           int visitType = [[[sync_Dic objectForKey:@"vistiType"] objectAtIndex:index] intValue];
                /*
                 visitType == 1 => IS A DOCTORS
                 visitType == 2 => IS A HOSPITAL
                 visitType == 3 => IS A PHARMACY
                 */
                if (sync_pharmacyStatus == false && visitType == 3) {
                    [self syncPharmacyWithoutSession: index];
                    return ;
                }
                [self syncSession:index];
     }
        
    }else{
        UIAlertView* alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"No internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}
-(void)syncSession : (int)index {
   Activity_indicator_loading *indicator =[[Activity_indicator_loading alloc] initWithFrame:CGRectMake(0, 0, 990, 500)];
    [self.view addSubview:indicator];
    
    NSString *app_id = [[sync_Dic objectForKey:@"app_id"] objectAtIndex:index] ;
    NSString *session_date = [[sync_Dic objectForKey:@"sync_id"] objectAtIndex:index] ;
    NSString *acc_time = [[sync_Dic objectForKey:@"acc_time"] objectAtIndex:index] ;
    NSString *total_time = [[sync_Dic objectForKey:@"total_time"] objectAtIndex:index] ;
    NSString *doc_cid = [[sync_Dic objectForKey:@"cid"] objectAtIndex:index] ;
    NSString *doc_did = [[sync_Dic objectForKey:@"did"] objectAtIndex:index] ;
    NSString *sample_dropped = [[sync_Dic objectForKey:@"sample_drop"] objectAtIndex:index] ;
    NSString *sample_type = [[sync_Dic objectForKey:@"sample_type"] objectAtIndex:index] ;
    NSString *objection = [[sync_Dic objectForKey:@"call_objection"] objectAtIndex:index] ;
    NSString *call_remark = [[sync_Dic objectForKey:@"call_remark"] objectAtIndex:index] ;
    int visitType = [[[sync_Dic objectForKey:@"vistiType"] objectAtIndex:index] intValue];

    NSDictionary *dic = @{@"app_id": app_id ,
                          @"session_date":session_date ,
                          @"visitType" : [NSString stringWithFormat:@"%d",visitType] ,
                          @"doctors_id" : doc_did ,
                          @"doctors_cid" : doc_cid ,
                          @"acc":acc_time,
                          @"duration" : total_time ,
                          @"sample":sample_dropped ,
                          @"sample_type":sample_type ,
                          @"callRemarks":call_remark ,
                          @"callObjection":objection
                          };
    
[PostDataToServer saveSessionWithCompanyID:sync_companyID userID:sync_userID sessionInfo:dic CompletionHandler:^(NSDictionary *result) {
                                 
     isStellContectToServer = false ;
     if ([result[@"success"] boolValue]
         //                  &&
         //    [result[@"visit_id"] intValue] > 0
         //                  &&
         //    [result[@"feedback_id"] intValue]>0
         ){
     
         [[DBManager getSharedInstance] deleteSyncData:session_date];
         
         if (self.isComeFromHomeViewController) {
             sync_Dic = [[DBManager getSharedInstance] getAllSyncSessionByAppID: @"" ] ;
         }else{
             sync_Dic = [[DBManager getSharedInstance] getAllSyncSessionByAppID: [[ApplicationData getSharedInstance] getApplicationID]] ;
         }
  
     }else {
         UIAlertView* alert;
         alert = [[UIAlertView alloc] initWithTitle:session_date message:@"Data not sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];
     }
     [self reloadTableView];
     
     [indicator removeFromSuperview];
	}];
    
}

-(void)syncPharmacyWithoutSession : (int)index {
    Activity_indicator_loading *indicator =[[Activity_indicator_loading alloc] initWithFrame:CGRectMake(0, 0, 990, 500)];
    [self.view addSubview:indicator];
    
    NSString *pharm_id = [[sync_Dic objectForKey:@"cid"] objectAtIndex:index] ;
    NSString *session_date = [[sync_Dic objectForKey:@"sync_id"] objectAtIndex:index] ;
    NSString *odrder_collection = [[sync_Dic objectForKey:@"sample_drop"] objectAtIndex:index] ;
    NSString *pharmacist_name = [[sync_Dic objectForKey:@"name"] objectAtIndex:index] ;
    NSString *objection = [[sync_Dic objectForKey:@"call_objection"] objectAtIndex:index] ;
    
    NSDictionary *dic = @{@"pharm_id":pharm_id ,
                          @"session_date":session_date ,
                          @"odrder_collection" : odrder_collection ,
                          @"pharmacist_name":pharmacist_name,
                          @"objection":objection};
    [PostDataToServer savePharmaciesSessionWithCompanyID:sync_companyID userID:sync_userID sessionInfo:dic CompletionHandler:^(NSDictionary *result) {
        isStellContectToServer = false ;
        if ([result[@"success"] boolValue] && [result[@"visit_id"] intValue] > 0 && [result[@"feedback_id"] intValue]>0) {
            [[DBManager getSharedInstance] deleteSyncData:session_date];
            if (self.isComeFromHomeViewController) {
                sync_Dic = [[DBManager getSharedInstance] getAllSyncSessionByAppID: @"" ] ;
            }else{
                sync_Dic = [[DBManager getSharedInstance] getAllSyncSessionByAppID: [[ApplicationData getSharedInstance] getApplicationID]] ;
            }
        }else{
            UIAlertView* alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Data not sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            isStellContectToServer = false ;
        }
  
        
        [self reloadTableView];

        [indicator removeFromSuperview];
    }];
}


-(void)reloadTableView{
    
    [tv_data reloadData];
    for (int i = 0 ; i < [[sync_Dic objectForKey:@"sync_id"] count] ; i++ ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0] ;
        [tv_data reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    int tableViewIndex = (int) [tv_data numberOfRowsInSection:0];
        for (int i = 0 ; i < tableViewIndex ; i++) {
     NSIndexPath *indexPath =  [NSIndexPath indexPathForItem:i inSection:0];
     [tv_data reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
     }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath: indexPath];
    CGRect rectOfCellInSuperview = [tableView convertRect: rectOfCellInTableView toView: [tableView superview]];
    
    NSString *sessionDate =[[NSString alloc] initWithFormat:@"%@",[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:indexPath.row ]] ;
    
    [[ReturnSesstionDetails sharedInstance]setData:sessionDate];
    [sd removeFromSuperview];
    sd =[[viewSessionDetails alloc] initWithFrame: CGRectMake(0,0, 1024 , 768):rectOfCellInSuperview.origin.y];
    [self.view addSubview:sd ];
    
}



 NSString *sync_Session_id  ;
-(IBAction)editDoctors:(id)sender{
   
    NSInteger numberOfRowToEditDoctor = [sender tag];
   sync_Session_id  = [[NSString alloc] initWithFormat:@"%@",[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:numberOfRowToEditDoctor]];

    
    if (sync_pharmacyStatus || sync_have_hospital) {
        BeforeDoctorView *bDocView =  [[BeforeDoctorView alloc] init];
        bDocView._BDoc_delegate = self ;
        [self.view addSubview:bDocView];
    }else {
        // open Defualt Doctors
        UIButton *btn = sender ;
        btn.tag = 1;
        [self goToSync:btn];
    }
    
    
    /*
    if ([[[DBManager getSharedInstance] getUserCompany] isEqualToString:@"tabuk"]) {
        syncCheckCompany_id  = 1 ;
        DoctorsViewController *edv=[self.storyboard instantiateViewControllerWithIdentifier:@"dv"];
        edv.str_SesstionID = sync_Session_id;
        edv.str_Type = @"0" ;
        edv.reUpdateSession = true;
        [self presentViewController:edv animated:NO completion:^(void){}];
    }else if ([[[DBManager getSharedInstance] getUserCompany] isEqualToString:@"chiesi"]){
        syncCheckCompany_id = 2 ;
        BeforeDoctorView *bDocView =  [[BeforeDoctorView alloc] init];
        bDocView._BDoc_delegate = self ;
        [self.view addSubview:bDocView];
    }
     */
}




-(IBAction)goToSync:(id)sender
{

//    NSLog(@"visit_Type = %ld " , [sender tag]);
    DoctorsViewController *edv = [self.storyboard instantiateViewControllerWithIdentifier:@"dv"];
    edv.visit_Type = [sender  tag] ;
    edv.str_SesstionID = sync_Session_id;
    edv.reUpdateSession = true;
    [self presentViewController:edv animated:YES completion:nil];
    return ;
    
}














-(void)editFeedbacks:(id)sender{


   UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSUInteger numberOfRowToEditDoctor = gesture.view.tag;
    FeedViewController *feeds = [self.storyboard instantiateViewControllerWithIdentifier:@"feed"];
    feeds.strAPP_name  = [[sync_Dic objectForKey:@"app_name"] objectAtIndex:numberOfRowToEditDoctor] ;
    feeds.strVisitTime=[[NSString alloc] initWithFormat:@"%@",[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:numberOfRowToEditDoctor]];
    feeds.strfeed_sample=[[sync_Dic objectForKey:@"sample_drop"]objectAtIndex:numberOfRowToEditDoctor] ;
    feeds.strfeed_remark=[[sync_Dic objectForKey:@"call_remark"]objectAtIndex:numberOfRowToEditDoctor];
    feeds.strfeed_objection=[[sync_Dic objectForKey:@"call_objection"]objectAtIndex:numberOfRowToEditDoctor];
    feeds.feedback_sampleTypeSelected = [[sync_Dic objectForKey:@"sample_type"]objectAtIndex:numberOfRowToEditDoctor];

    feeds._HomeViewStatus = self.isComeFromHomeViewController ;

    [self presentViewController:feeds animated:NO completion:^(void){}];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
-(void)beforeDocList_backToHome:(id)sender
{
    [self.view.subviews[self.view.subviews.count - 1 ] removeFromSuperview ];
}
*/


-(IBAction)syncAllActionButton:(id)sender{
    
    internetChecked *check = [[internetChecked alloc] init];
    if (!check.Checked) {
        UIAlertView* alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"No internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return ;
        
    }
    [sender setHidden:true];

        if (!isStellContectToServer) {
            
            for (int index = 0 ; index < [[sync_Dic objectForKey:@"sync_id"] count] ; index ++) {
                int visitType = [[[sync_Dic objectForKey:@"vistiType"] objectAtIndex:index] intValue];
               // CHEKED FEEDBACK DATA
                if ([[[sync_Dic objectForKey:@"sample_drop"]objectAtIndex:index] isEqualToString:@""]
                    ||[[[sync_Dic objectForKey:@"call_objection"]objectAtIndex:index] isEqualToString:@""]
                    || [[[sync_Dic objectForKey:@"call_remark"]objectAtIndex:index] isEqualToString:@""]
                    ){
                    continue ;
                    }
                /*
                 visitType == 1 => IS A DOCTORS
                 visitType == 2 => IS A HOSPITAL
                 visitType == 3 => IS A PHARMACY
                 */
                if (sync_pharmacyStatus == false && visitType == 3) {
                    [self syncPharmacyWithoutSession: index];
                    continue ;
                }
                [self syncSession:index];
                
            }
            
/*
            
//            syncAll_index = [[sync_Dic objectForKey:@"sync_id"] count] - 1;
        if ([[sync_Dic objectForKey:@"sync_id"] count] > syncAll_index  ) {

            NSString *call_objection = [sync_Dic[@"call_objection"] objectAtIndex:syncAll_index];
            NSString *call_remark = [sync_Dic[@"call_remark"] objectAtIndex:syncAll_index];
            NSString *sample_drop = [sync_Dic[@"sample_drop"] objectAtIndex:syncAll_index];

            if (
                ![call_objection isEqualToString:@""] &&
                ![call_remark isEqualToString:@""] &&
                ![sample_drop isEqualToString:@""]
                ){
//                sync_load =[[Activity_indicator_loading alloc] initWithFrame:CGRectMake(0, 0, 990, 500)];
//                [self.view addSubview:sync_load];
                syncAll = true ;
                NSString *strSessionID = [sync_Dic[@"sync_id"] objectAtIndex:syncAll_index] ;
//                self.sendS = [[SendSyncSession alloc] init];
//                self.sendS.syncDelegate=self;
//                [self.sendS syncData:strSessionID];
                syncAll_index = syncAll_index + 1 == [[sync_Dic objectForKey:@"sync_id"] count]  ?
                [[sync_Dic objectForKey:@"sync_id"] count]  - 1 : syncAll_index ++   ;
                return ;
            }

            syncAll_index ++ ;
            [self syncAllActionButton:sender];
            return ;

        }
            syncAll_index = 0 ;
            syncAll = false ;
//            [sync_load stop];
//            [sync_load removeFromSuperview];
            return ;
*/
        }
    
//    [sync_load stop];
//    [sync_load removeFromSuperview];


}
@end
