//
//  SyncViewController.m
//  DashboardSQL
//
//  Created by Yahia on 2/23/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "SyncViewController.h"

@interface SyncViewController ()
@property (strong , nonatomic)UITableView *tv_data;
@property (nonatomic,strong) SendSyncSession *sendS;
@end

@implementation SyncViewController

//NSInteger numberOfRows;
Button *btn_close , *btn_home ;
viewSessionDetails *sd ;
Activity_indicator_loading *sync_load ;
NSDictionary *sync_Dic  ;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (self.isComeFromHomeViewController) {
        sync_Dic = [[DBManager getSharedInstance] getAllSyncSessionByAppID: @"" ] ;
    }else{
        sync_Dic = [[DBManager getSharedInstance] getAllSyncSessionByAppID: [[ApplicationData getSharedInstance] getApplicationID]] ;
    }

    for ( NSString *element  in [sync_Dic objectForKey:@"app_name"]) {
        NSLog(@"element %@ ", element);
    }
    

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_general_bkg.png"]]];
    Image *img_Doctor_Title = [[Image alloc] initWithFrame:@"dash_sync_title.png" :420 :25];
    [self.view addSubview:img_Doctor_Title];
    Image *tacc_Sync = [[Image alloc] initWithFrame:@"dash_logo.png" :700 :620];
    [self.view addSubview:tacc_Sync];
    
    
    btn_close =[[Button alloc] initWithFrame:@"dash_btn_close.png" :900 :27];
    btn_close.tag=0;
    [btn_close addTarget:self action:@selector(syncActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_close];


    btn_home =[[Button alloc] initWithFrame:@"dash_home.png" :50 :27];
    btn_home.tag = 1;
    [btn_home addTarget:self action:@selector(syncActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_home];

    // numberOfRows =[[[[DBManager getSharedInstance] getAllSyncSession] objectForKey:@"sync_id"] count];
    
    Label *lblSession_title = [[Label alloc] initWithFrame:CGRectMake(160,80, 250, 50) :@"Session Date" :20];
    [lblSession_title setTextAlignment:NSTextAlignmentCenter];
    [lblSession_title setTextColor:[UIColor grayColor]];
    [self.view addSubview:lblSession_title];

    Label *lblAppName_title = [[Label alloc] initWithFrame:CGRectMake(610,80, 250, 50) :@"Application Name" :20];
    [lblAppName_title setTextAlignment:NSTextAlignmentCenter];
    [lblAppName_title setTextColor:[UIColor grayColor]];
    [self.view addSubview:lblAppName_title];

    Label *lblStatus_title = [[Label alloc] initWithFrame:CGRectMake(880 ,80, 90, 50) :@"Status" :20];
    [lblStatus_title setTextAlignment:NSTextAlignmentCenter];
    [lblStatus_title setTextColor:[UIColor grayColor]];
    [self.view addSubview:lblStatus_title];



    [self.tv_data removeFromSuperview];
    self.tv_data = [[UITableView alloc] initWithFrame:CGRectMake(50,100, 910, 500)];
    self.tv_data.center = CGPointMake(1024/2, 768/2);
    self.tv_data.delegate =self;
    self.tv_data.dataSource = self;
    self.tv_data.bounces    = false ;
    self.tv_data.backgroundColor=[UIColor clearColor];
    self.tv_data.superview.backgroundColor = [UIColor clearColor];
    self.tv_data.userInteractionEnabled = YES;
    
    self.tv_data.separatorColor = [UIColor clearColor];
    
    [self.view addSubview:self.tv_data];

    
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
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    return @"Synchronize";
//    
//}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //The Row Numbers
    return [[sync_Dic objectForKey:@"sync_id"] count] ;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //    if (!cell) cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (!cell)  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    
    else
    {
        //To remove the subview of cell.
        for (UIView *vwSubviews in [cell.contentView subviews])
        {
            [vwSubviews removeFromSuperview];
        }
        
    }
    
    if (indexPath.row %2 != 0 ) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_blue_heder.png"]];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *strCellText ;
    strCellText=[[NSString alloc] initWithFormat:@"%i. : %@",indexPath.row+1,[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:indexPath.row]];
    
 
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
//
    cell.textLabel.text=strCellText;
   
    NSString *str_app_name =[[sync_Dic objectForKey:@"app_name"] objectAtIndex:indexPath.row];
    Label *lbl_app_name = [[Label alloc] initWithFrame:CGRectMake(600, 0, 150 , cell.frame.size.height) :str_app_name :14];
    [lbl_app_name setTextAlignment:NSTextAlignmentCenter];
    [cell addSubview:lbl_app_name];

    Button *btnCell= [[Button alloc] initWithFrame:@"dash_sync_btn_feedback" :850 :0];
    btnCell.frame = CGRectMake(835 , 0 , btnCell.frame.size.width +30 , cell.frame.size.height);
    btnCell.tag=indexPath.row;
//    btnCell.backgroundColor=[UIColor blackColor];
    [cell.contentView addSubview:btnCell];
    btnCell.accessibilityLabel=[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:indexPath.row];
    
    if ([[[sync_Dic objectForKey:@"sample_drop"]objectAtIndex:indexPath.row] isEqualToString:@""]
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
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editDoctorsView:)];
        tapped.numberOfTapsRequired = 1;
        cell.imageView.tag= indexPath.row;
        [cell.imageView addGestureRecognizer:tapped];
        cell.imageView.transform = CGAffineTransformMakeScale(5,5);
        
    }
    
    //document_edit.png
    
     cell.textLabel.textColor = [ Image _HexaColor:@"4d4d4d"] ;
    cell.detailTextLabel.textColor = [ Image _HexaColor:@"4d4d4d"];
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
    
    NSString *strMSG_Alert =[[NSString alloc] initWithFormat: @"Are you sure you want to delete \r '%@' ? " ,sync_strVisitTime];
    UIAlertView* message = [[UIAlertView alloc]initWithTitle: @"Message" message: strMSG_Alert
                                                    delegate: self
                                           cancelButtonTitle: @"Cancel" otherButtonTitles: @"Yes", nil];
    [message show];
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [[DBManager getSharedInstance] deleteSyncData:sync_strVisitTime];
        [self.tv_data reloadData];
    } else if (buttonIndex == 0) {
        
    }
    sync_strVisitTime=@"";
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}



-(IBAction)buttonActionFeedback:(id)sender{
    Button *btn =sender;
    FeedViewController *feeds = [self.storyboard instantiateViewControllerWithIdentifier:@"feed"];
    feeds.strVisitTime=[[NSString alloc] initWithFormat:@"%@",[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:btn.tag]];
    
    [self presentViewController:feeds animated:NO completion:^(void){}];
    
}
-(IBAction)buttonActionSync:(id)sender{
    UITableViewCell *owningCell = (UITableViewCell*)[sender superview];
    
    //From the cell get its index path.
    NSIndexPath *pathToCell = [self.tv_data indexPathForCell:owningCell];
    NSLog(@"?>>>>> ?  %@",pathToCell);
    
    
    internetChecked *check = [[internetChecked alloc] init];
    if (check.Checked) {
        
        sync_load =[[Activity_indicator_loading alloc] initWithFrame:CGRectMake(0, 0, 990, 500)];
        
        Button *btn =sender;
        NSString *strSessionID=[[NSString alloc] initWithFormat:@"%@",[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:btn.tag]];
        
        self.sendS=[[SendSyncSession alloc] init];
        self.sendS.syncDelegate=self;
        [self.sendS syncData:strSessionID];
        
        [self.tv_data reloadData];
        self.tv_data.userInteractionEnabled = NO;
        [self viewDidLoad];
        
        
        [self.view addSubview:sync_load];
    }else{
        UIAlertView* alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"no internet connection " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void)stopLoad{
    [sync_load stop];
    [sync_load removeFromSuperview];
     [self.tv_data reloadData];
    NSLog(@"Stop");
}









NSString *_ShowSesstionDestials_strSessionID ;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath: indexPath];
    CGRect rectOfCellInSuperview = [tableView convertRect: rectOfCellInTableView toView: [tableView superview]];
    
    _ShowSesstionDestials_strSessionID =[[NSString alloc] initWithFormat:@"%@",[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:indexPath.row ]] ;
    
    [[ReturnSesstionDetails sharedInstance]setData:_ShowSesstionDestials_strSessionID];
    [sd removeFromSuperview];
    sd =[[viewSessionDetails alloc] initWithFrame: CGRectMake(0,0, 1024 , 768):rectOfCellInSuperview.origin.y];
    [self.view addSubview:sd ];
    
    
    
    
}







-(void)editDoctorsView:(id)sender{
    
    
   UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    int numberOfRowToEditDoctor = gesture.view.tag;

    //  NSString *strSessionID=[[NSString alloc] initWithFormat:@"%@",[[[[DBManager getSharedInstance] getAllSyncSession] objectForKey:@"sync_id"] objectAtIndex:numberOfRowToEditDoctor]] ;
    /*
     NSString *_docID_String =[[[[DBManager getSharedInstance] getAllSyncSession] objectForKey:@"did"] objectAtIndex:numberOfRowToEditDoctor];
     NSArray* _docID_Array = [_docID_String componentsSeparatedByString: @"|"];
     NSString *_docString =[[[[DBManager getSharedInstance] getAllSyncSession] objectForKey:@"name"] objectAtIndex:numberOfRowToEditDoctor];
     NSArray* _doc_Array = [_docString componentsSeparatedByString: @"|"];
     NSString *_docSpec = [[[[DBManager getSharedInstance] getAllSyncSession] objectForKey:@"spec"] objectAtIndex:numberOfRowToEditDoctor];
     NSArray* _docSpecArray = [_docSpec componentsSeparatedByString: @"|"];
     
     EditDoctorsViewController *ed=[self.storyboard instantiateViewControllerWithIdentifier:@"eDoc"];
     ed.eDic_docDetails =[[NSMutableDictionary alloc] init];
     [ed.eDic_docDetails setObject:strSessionID forKey:@"sesstionID"];
     [ed.eDic_docDetails setObject:_docID_Array forKey:@"docID"];
     [ed.eDic_docDetails setObject:_doc_Array forKey:@"docName"];
     [ed.eDic_docDetails setObject:_docSpecArray forKey:@"docSpec"];
     [self presentViewController:ed animated:NO completion:^(void){}];
     */
    
    
    FeedViewController *feeds = [self.storyboard instantiateViewControllerWithIdentifier:@"feed"];
    feeds.strVisitTime=[[NSString alloc] initWithFormat:@"%@",[[sync_Dic objectForKey:@"sync_id"] objectAtIndex:numberOfRowToEditDoctor]];
    feeds.strfeed_sample=[[sync_Dic objectForKey:@"sample_drop"]objectAtIndex:numberOfRowToEditDoctor] ;
    feeds.strfeed_remark=[[sync_Dic objectForKey:@"call_remark"]objectAtIndex:numberOfRowToEditDoctor];
    feeds.strfeed_objection=[[sync_Dic objectForKey:@"call_objection"]objectAtIndex:numberOfRowToEditDoctor];
    [self presentViewController:feeds animated:NO completion:^(void){}];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)syncSended:(NSInteger)checkedSync :(NSString *)str_sync_strVisitTime{
    
    if (checkedSync>1)  [[DBManager getSharedInstance] deleteSyncData:str_sync_strVisitTime];
    NSLog(@">>> %@",str_sync_strVisitTime);
    [sync_load stop];
    [sync_load removeFromSuperview];
    
    [self.tv_data removeFromSuperview];
    self.tv_data = [[UITableView alloc] initWithFrame:CGRectMake(50,100, 900, 500)];
    self.tv_data.center = CGPointMake(1024/2, 768/2);
    self.tv_data.delegate=self;
    self.tv_data.dataSource=self;
    self.tv_data.backgroundColor=[UIColor clearColor];
    self.tv_data.superview.backgroundColor = [UIColor clearColor];
    self.tv_data.userInteractionEnabled = YES;
    self.tv_data.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tv_data];

    
    
}









@end
