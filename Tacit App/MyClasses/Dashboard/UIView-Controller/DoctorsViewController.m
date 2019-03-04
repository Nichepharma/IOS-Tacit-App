//
//  DoctorsViewController.m
//  DashboardSQL
//
//  Created by Yahia on 2/22/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "DoctorsViewController.h"

@interface DoctorsViewController ()

@property NSMutableDictionary *doctorsList ;
@property (strong,nonatomic) NSMutableArray *filteredDoctorList ,*alphabetsArray,*array_Name , *array_id, *array_other , *array_CID , *array_Loc,*array_DocFromHospitals_name ,*array_DocFromHospitals_id,*array_DocFromHospitals_cid,*array_DocFromHospitals_spec ,*array_DocFromHospitals_loc;
@property (strong , nonatomic) UITableView *tv_allDoc ,*tv_selectedDoc , *tv_DocFromHospitals;
@property (strong,nonatomic) IBOutlet UISearchDisplayController *SDController;
@property (strong,nonatomic) IBOutlet UISearchBar *SearchBar;


@end

@implementation DoctorsViewController

@synthesize array_id,array_Name,array_other , array_CID , array_Loc ,alphabetsArray,doctorsList;
@synthesize array_DocFromHospitals_name , array_DocFromHospitals_id, array_DocFromHospitals_cid, array_DocFromHospitals_spec,array_DocFromHospitals_loc ;

NSString *str_HospitalNameSelected ;

NSMutableArray  *arr_choose_CID , *arr_Choose_name,*arr_Choose_id,*arr_Choose_other;
Activity_indicator_loading *loaded ;
internetChecked *doc_checkedInternet ;
NSInteger countOfItem =0 ;
bool selectChecked =false;
Button *btn_Enter ,*btn_refreshing;
int _SBY = 64 ;
int _SBX = 14 ;

BOOL doc_pharmacySessionStatus = false ;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"__DoctorsViewController");

    
    NSUserDefaults *userDefault =  [[NSUserDefaults alloc] init];
    doc_pharmacySessionStatus = [[userDefault objectForKey:@"pharmacySessionStatus"] boolValue] ;

    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_general_bkg.png"]]];
    Image *img_Doctor_Title = [[Image alloc] initWithFrame:@"dash_doc_select_doctor_title.png" :420 :25];
    [self.view addSubview:img_Doctor_Title];

    Image *tacc_Doctors = [[Image alloc] initWithFrame:@"dash_logo.png" :700 :620];
    [self.view addSubview:tacc_Doctors];

    Button *syncView_btn_home =[[Button alloc] initWithFrame:@"dash_back.png" :50 :27];
    syncView_btn_home.tag = 1;
    [syncView_btn_home addTarget:self action:@selector(GoToBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:syncView_btn_home];
    
    [arr_Choose_name removeAllObjects];
    [arr_Choose_id removeAllObjects];
    [arr_Choose_other removeAllObjects];
    [arr_choose_CID removeAllObjects]; // if company is equal chiesi

    arr_Choose_name =[[NSMutableArray alloc] init];
    arr_Choose_id =[[NSMutableArray alloc] init];
    arr_Choose_other =[[NSMutableArray alloc] init];
    arr_choose_CID =[[NSMutableArray alloc] init];
    _filteredDoctorList =[[NSMutableArray alloc] init];

    countOfItem = 0 ;

    [self getDocData];

    UIView *_DocTVBKG = [[UIView alloc] initWithFrame:CGRectMake(14, 65, 392, 700)];
            _DocTVBKG.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_doc_table_bkg.png"]];
    [self.view addSubview:_DocTVBKG];
    
    self.tv_allDoc = [[UITableView alloc] initWithFrame:CGRectMake(14,115, 392, 650)];
    self.tv_allDoc.delegate=self;
    self.tv_allDoc.dataSource=self;
    self.tv_allDoc.backgroundColor=[UIColor clearColor];
    self.tv_allDoc.superview.backgroundColor = [UIColor clearColor];
    self.tv_allDoc.userInteractionEnabled = YES;
   [self.view addSubview:self.tv_allDoc];
    
    
    self.tv_selectedDoc = [[UITableView alloc] initWithFrame:CGRectMake(406,190, 550, 440)];
    self.tv_selectedDoc.delegate=self;
    self.tv_selectedDoc.dataSource=self;
    self.tv_selectedDoc.backgroundColor=[UIColor clearColor];
    self.tv_selectedDoc.separatorColor = [UIColor clearColor];
    self.tv_selectedDoc.superview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tv_selectedDoc];

    
    _SearchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(14  , 64, 392, 44)];
    [_SearchBar setBackgroundColor:[UIColor whiteColor]];
    _SDController = [[UISearchDisplayController alloc] initWithSearchBar:_SearchBar contentsController:self];
    _SDController.delegate = self;
    _SDController.searchResultsDataSource = self;
    _SDController.searchResultsTableView.delegate=self.tv_allDoc.delegate;
    _SDController.searchResultsTableView.dataSource=self.tv_allDoc.dataSource;

    _SearchBar.tintColor = [UIColor whiteColor];
    _SearchBar.barTintColor = [UIColor clearColor];
    _SearchBar.showsCancelButton=NO;
    [_SearchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor blackColor]];
    [self.view addSubview:_SearchBar];


    [self createAlphabetArray];

    btn_Enter=[[Button alloc] initWithFrame:@"dash_done.png" :900 :27];
    btn_Enter.tag=1;
    [btn_Enter addTarget:self action:@selector(doc_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_Enter];
    
    [_SearchBar bringSubviewToFront:btn_Enter];
    [btn_refreshing bringSubviewToFront:_SearchBar];

    
    self.tv_DocFromHospitals.alpha=0;
    [self.tv_DocFromHospitals removeFromSuperview];
    if (self.visit_Type == 2) {
        self.tv_DocFromHospitals = [[UITableView alloc] initWithFrame:CGRectMake(410,_SBY, 270, 300)];
        self.tv_DocFromHospitals.delegate=self;
        self.tv_DocFromHospitals.dataSource=self;
        self.tv_DocFromHospitals.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_doc_table_bkg.png"]];
        self.tv_DocFromHospitals.superview.backgroundColor = [UIColor clearColor];
        self.tv_DocFromHospitals.userInteractionEnabled = YES;
        self.tv_DocFromHospitals.alpha=0;
        [self.view addSubview:self.tv_DocFromHospitals];
    }


    [self.tv_allDoc reloadData];

}


-(void)getDocData{
    [array_CID removeAllObjects];
    [array_id removeAllObjects];
    [array_Name removeAllObjects];
    [array_other removeAllObjects];
    
    if (self.visit_Type == 1){
     //   if (![array_id count] ||![array_Name count]||![array_other count]) {
            // get Private Doctors
            NSDictionary *docInfo = [[DBManager getSharedInstance]getAllDoctors:@"0":@"0"] ;
            array_CID=[[NSMutableArray alloc] initWithArray:[docInfo objectForKey:@"cid"]];
            array_id=[[NSMutableArray alloc] initWithArray:[docInfo objectForKey:@"did"]];
            array_Name =[[NSMutableArray alloc] initWithArray:[docInfo objectForKey:@"name"]];
            array_other=[[NSMutableArray alloc] initWithArray:[docInfo objectForKey:@"spec"]];
            array_Loc=[[NSMutableArray alloc] initWithArray:[docInfo  objectForKey:@"loc"]];
     //   }
        
    }
    else if (self.visit_Type == 2) {
        NSDictionary *hospitalInfo = [[DBManager getSharedInstance]getAllHospitals] ;
        array_CID   = [[NSMutableArray alloc] initWithArray:[hospitalInfo objectForKey:@"cid"]];
        array_id    = [[NSMutableArray alloc] initWithArray:[hospitalInfo objectForKey:@"did"]];
        array_Name  = [[NSMutableArray alloc] initWithArray:[hospitalInfo objectForKey:@"name"]];
        array_other = [[NSMutableArray alloc] initWithArray:[hospitalInfo objectForKey:@"spec_or_loc"]];
    }
    else if (self.visit_Type == 3) {
        // get only pharmacy
        array_CID=[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllPharmacies]objectForKey:@"did"]];
        array_id=[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllPharmacies] objectForKey:@"cid"]];
        array_Name =[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllPharmacies] objectForKey:@"name"]];
        array_other=[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllPharmacies] objectForKey:@"spec_or_loc"]];
        //return ;
    }
  

    //NSLog(@"%@ >> %@ >>> %@ >> %@ >> %@", array_CID,array_id,array_Name,array_other,array_Loc);

    //NSLog(@"Doc ID = %@ , Doc Name = %@ , Doc Spec  = %@",array_id ,array_Name,array_other  );
    [self createAlphabetArray];
    [self.tv_allDoc reloadData];
}
#pragma Button Action
-(IBAction)doc_buttonAction:(id)sender{
    
    Button *btn_tag = sender ;
    
    switch (btn_tag.tag) {
        case 0:
            loaded =[[Activity_indicator_loading alloc] initWithFrame:CGRectMake(14,0, 392, 768)];
            [self.view addSubview:loaded];
            [NSTimer scheduledTimerWithTimeInterval:5  target:self selector:@selector(doc_counterFire:) userInfo:nil repeats:NO];
            break;
        case 1:
            if (selectChecked&&countOfItem>0) {
//                TimerCalculate *timeclc =[[TimerCalculate alloc] init];
                NSString * did=@"";
                NSString * cid=@"";
                NSString * dname=@"";
                NSString * dspec=@"";

                for (NSString *n in arr_Choose_id )    did   = [did   stringByAppendingFormat:@"%@|",n];
                for (NSString *n in arr_Choose_name )  dname = [dname stringByAppendingFormat:@"%@|",n];
                for (NSString *n in arr_Choose_other ) dspec = [dspec stringByAppendingFormat:@"%@|",n];
                for (NSString *n in arr_choose_CID )   cid   = [cid   stringByAppendingFormat:@"%@|",n];

                NSString *visitType  = [NSString stringWithFormat:@"%ld" , (long)self.visit_Type];

            if (self.reUpdateSession == true) {
                NSMutableDictionary *docData  = [[NSMutableDictionary alloc] init];
                  [docData setObject:did forKey:@"did"];
                  [docData setObject:dname forKey:@"dname"];
                  [docData setObject:dspec forKey:@"dspec"];
                  [docData setObject:cid forKey:@"dcid"];
                [docData setObject:visitType forKey:@"visitType"];
                
                  [docData setObject:self.str_SesstionID forKey:@"visit"];
                 [[DBManager getSharedInstance] update_e_SyncData:docData];

                }else{
                    NSString *strTotalTime = [[NSString alloc] initWithFormat:@"%f",self.doc_totalTime];
                    [[DBManager getSharedInstance] saveSync:self.str_SesstionID
                                             sync_totalTime: strTotalTime
                                                   acc_time:self.doc_ACC
                                                     doc_id:did
                                                   doc_cid :cid
                                                   doc_name:dname
                                                   doc_spec:dspec
                                               call_inquiry:@""
                                             call_objection:@""
                                                call_remark:@""
                                                 doc_notice:@""
                                                sample_drop:@""
                                                 visitType : [NSString stringWithFormat:@"%ld", (long)self.visit_Type] ];
                }

                SyncViewController *syncView = [self.storyboard instantiateViewControllerWithIdentifier:@"sync"];
                syncView.isComeFromHomeViewController = true ;
                [self presentViewController:syncView animated:NO completion:^(void){}];
                
            }else{
               
                [AlertController showAlertWithSingleButton:@"OK" presentOnViewController:self alertTitle:@"Worng" alertMessage:@"Minimum selection 1 doctor." ];

            }
            break;
        default:
            break;
}
    
}
-(IBAction)doctorsAction_backToHome:(id)sender{

    if (self.reUpdateSession ) {
        SyncViewController *syncView = [self.storyboard instantiateViewControllerWithIdentifier:@"sync"];
        syncView.isComeFromHomeViewController = true ;
        [self presentViewController:syncView animated:NO completion:^(void){}];
    }
    NSString *strTotalTime = [[NSString alloc] initWithFormat:@"%f",self.doc_totalTime];
    [[DBManager getSharedInstance] saveSync:self.str_SesstionID
                             sync_totalTime: strTotalTime
                                   acc_time:self.doc_ACC
                                     doc_id:@""
                                   doc_cid :@""
                                   doc_name:@""
                                   doc_spec:@""
                               call_inquiry:@""
                             call_objection:@""
                                call_remark:@""
                                 doc_notice:@""
                                sample_drop:@""
                                 visitType :[NSString stringWithFormat:@"%ld" , (long)self.visit_Type]
     ];

    HomeViewController *syncView = [self.storyboard instantiateViewControllerWithIdentifier:@"enter"];
    [self presentViewController:syncView animated:NO completion:^(void){}];
}




-(IBAction)doc_counterFire:(id)sender{
    doc_checkedInternet =[[internetChecked alloc] init];
    if (doc_checkedInternet.Checked ) {
     //     [GetAllDoctorsFromServer get_Doc] ;
      //  [self getDocData];
      //  [self.tv_allDoc reloadData];

    }else{

           [AlertController showAlertWithSingleButton:@"OK" presentOnViewController:self alertTitle:@"Worng" alertMessage:@"No internet connection" ];

    }
    [loaded stop];
    [loaded removeFromSuperview];
    
}
#pragma TableView API

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // section number .. alphabetical array
    
   if (tableView == _SDController.searchResultsTableView ||
       tableView==self.tv_selectedDoc ||
       tableView==self.tv_DocFromHospitals) {
        return 1;
    }else {
        return [alphabetsArray count];
    }
    
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    [tableView setSectionIndexColor:[UIColor blackColor]];
    [tableView setSectionIndexBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_doc_1.png"]]];
    
    if (tableView == _SDController.searchResultsTableView|| tableView==self.tv_selectedDoc) {
        return nil;
    } else {
        
        return alphabetsArray;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == _SDController.searchResultsTableView|| tableView==self.tv_selectedDoc) {
        return 0;
    } else {
        return [alphabetsArray indexOfObject:title];
    }
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    // Header Title
//    if (tableView == self.tv_allDoc) {
//        return [alphabetsArray objectAtIndex:section];
//    }
//    else
//        return Nil ;
//}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //The Row Numbers
    
    if (tableView == self.tv_allDoc) {
        NSArray *values = [doctorsList valueForKey:[alphabetsArray objectAtIndex:section]];
        return [values count];
    }
     else if (tableView == _SDController.searchResultsTableView) return [_filteredDoctorList count];
     else if (tableView == self.tv_DocFromHospitals) return [array_DocFromHospitals_cid count ];
     else if (tableView == self.tv_selectedDoc) return arr_Choose_name.count ;

    return  0 ;

}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
 
   if(tableView == self.tv_selectedDoc){

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       NSString *strObject =[[NSString alloc] initWithFormat:@"%li - %@",indexPath.row+1 ,[arr_Choose_name objectAtIndex:indexPath.row]];
        cell.textLabel.text =strObject ;
        if (indexPath.row %2 != 0 ) {
        
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_blue_heder.png"]];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
    } else if (tableView == self.tv_allDoc) {
        
           cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
        UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tv_allDoc.frame.size.width, self.tv_allDoc.frame.size.height)];
        [bgColorView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_doc_cell_select.png"]]];
        [cell setSelectedBackgroundView:bgColorView];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        NSArray *values = [doctorsList valueForKey:[alphabetsArray objectAtIndex:indexPath.section]];
        
        cell.textLabel.text = [values objectAtIndex:indexPath.row];
        
        cell.backgroundColor=[UIColor clearColor];
        NSInteger rowNumber = 0;
        for (NSInteger i = 0; i < indexPath.section; i++) {
            rowNumber += [self tableView:tableView numberOfRowsInSection:i];
        }
        rowNumber += indexPath.row; // calculate the index but adding of section index + row index of the sesion
//        NSString *strCellDetail = [[NSString alloc] initWithFormat:@"%@", [[[[DBManager getSharedInstance]getAllDoctors] objectForKey:@"spec"] objectAtIndex:rowNumber]];
        NSString *strCellDetail;
//        strCellDetail = [[NSString alloc] initWithFormat:@"%@",[array_other objectAtIndex:rowNumber]];

        if (self.visit_Type == 1) {
            strCellDetail = [[NSString alloc] initWithFormat:@"%@",[array_other objectAtIndex:rowNumber]];
        }else if (self.visit_Type == 2){
            strCellDetail = [[NSString alloc] initWithFormat:@"%@",[array_other objectAtIndex:rowNumber]];
        }else if (self.visit_Type == 3){
            strCellDetail = [[NSString alloc] initWithFormat:@"%@",[array_other objectAtIndex:rowNumber]];
        }

        cell.detailTextLabel.text=strCellDetail;
        cell.detailTextLabel.textColor=[UIColor whiteColor];

    } else if (tableView == _SDController.searchResultsTableView) {
        cell.textLabel.text = [_filteredDoctorList objectAtIndex:indexPath.row];
    } else if (tableView==self.tv_DocFromHospitals){
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text=[array_DocFromHospitals_name objectAtIndex:indexPath.row];
        cell.detailTextLabel.text=[array_DocFromHospitals_spec objectAtIndex:indexPath.row];

    }
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (self.visit_Type != 2 ) {
        NSArray *values = [doctorsList valueForKey:[alphabetsArray objectAtIndex:indexPath.section]]; // get whole section into an array
    if (tableView == self.tv_allDoc  ) {
            if (countOfItem<10) {
            BOOL isTheObjectThere = [arr_Choose_name containsObject: [values objectAtIndex:indexPath.row ] ]; // check that object does not already exist
            if (!isTheObjectThere) {
                NSInteger rowNumber = 0;
                for (NSInteger i = 0; i < indexPath.section; i++) {
                    rowNumber += [self tableView:tableView numberOfRowsInSection:i];
                }
                rowNumber += indexPath.row; // calculate the index but adding of section index + row index of the sesion

               /* if (checkCompany_id  == 1) {
                    [arr_Choose_id addObject:    [array_id objectAtIndex:rowNumber]];
                }
                // if company is Chiesi
                else if (  checkCompany_id  == 2 ){
                    [arr_choose_CID addObject:   [array_id objectAtIndex:rowNumber]];
                    [arr_Choose_id addObject:    [array_CID objectAtIndex:rowNumber]];
                }else{
                    [arr_choose_CID addObject:[array_CID objectAtIndex:rowNumber]];
                    [arr_Choose_id  addObject:[array_id objectAtIndex:rowNumber]];
                }
                */
                [arr_choose_CID addObject:[array_CID objectAtIndex:rowNumber]];
                [arr_Choose_id  addObject:[array_id objectAtIndex:rowNumber]];
                 [arr_Choose_name addObject:  [array_Name objectAtIndex:rowNumber ] ] ;
                 [arr_Choose_other addObject: [array_other objectAtIndex:rowNumber ]];
                countOfItem ++;
                [self.tv_selectedDoc reloadData];
            }
            
            selectChecked =TRUE;
        }else{
            
            [AlertController showAlertWithSingleButton:@"OK" presentOnViewController:self alertTitle:@"!" alertMessage:@"Maximum selection 10 doctors." ];

        }


    } else if(tableView == self.SDController.searchResultsTableView){

            NSString * firstLetter = [[_filteredDoctorList objectAtIndex:indexPath.row]substringToIndex:1];
            NSArray *values = [doctorsList valueForKey: firstLetter];
            NSInteger sectionNum = [alphabetsArray indexOfObject:firstLetter];
            NSInteger indexInSection = [values indexOfObject:[_filteredDoctorList objectAtIndex:indexPath.row]];
            NSInteger rowNumber = 0 ;
            for (NSInteger i = 0; i < sectionNum; i++)
            {
                rowNumber += [[doctorsList valueForKey:[alphabetsArray objectAtIndex:i]] count];
            }
            rowNumber += indexInSection;

            if (countOfItem<10) {
                BOOL isTheObjectThere = [arr_Choose_name containsObject: [_filteredDoctorList objectAtIndex:indexPath.row] ]; // check that object does not already exist
                if (!isTheObjectThere) {
                    [arr_Choose_name addObject: [_filteredDoctorList objectAtIndex:indexPath.row]] ;
                    // if company is chiesi
                   /* if (  checkCompany_id  == 2 ){
                        [arr_Choose_id addObject:  [array_CID objectAtIndex:rowNumber]];
                        [arr_choose_CID addObject: [array_id  objectAtIndex:rowNumber]];
                    }else if( checkCompany_id == 1 ){
                        [arr_Choose_id addObject:  [array_id objectAtIndex:rowNumber]];
                    }*/
                    [arr_Choose_id addObject:  [array_id objectAtIndex:rowNumber]];
                    [arr_choose_CID addObject: [array_CID  objectAtIndex:rowNumber]];
                    [arr_Choose_other addObject: [array_other objectAtIndex:rowNumber ]];
                    countOfItem ++;
                    [self.tv_selectedDoc reloadData];
                }

                selectChecked =TRUE;
                
            }
            
            
        }
    }


    else if (tableView != self.tv_selectedDoc){

        if (tableView == self.tv_allDoc ) {
            CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath: indexPath];
            CGRect rectOfCellInSuperview = [tableView convertRect: rectOfCellInTableView toView: [tableView superview]];
            self.tv_DocFromHospitals.frame = CGRectMake(self.tv_DocFromHospitals.frame.origin.x
                                                        , rectOfCellInSuperview.origin.y / 2 + 70, self.tv_DocFromHospitals.frame.size.width, self.tv_DocFromHospitals.frame.size.height);

            self.tv_DocFromHospitals.alpha=1;

            NSInteger rowNumber = 0;
            for (NSInteger i = 0; i < indexPath.section; i++) {
                rowNumber += [self tableView:tableView numberOfRowsInSection:i];
            }  rowNumber += indexPath.row;
            self.tv_selectedDoc.frame= CGRectMake(710,190, 300, 440) ;
            NSString *str_idSelected = [array_id objectAtIndex:rowNumber] ;
            NSDictionary *docInHospital = [[DBManager getSharedInstance] getAllDoctors:[NSString stringWithFormat:@"%ld", _visit_Type] : str_idSelected] ;
            array_DocFromHospitals_id   = [docInHospital objectForKey:@"did"];
            array_DocFromHospitals_cid  = [docInHospital objectForKey:@"cid"];
            array_DocFromHospitals_name = [docInHospital objectForKey:@"name"];
            array_DocFromHospitals_spec = [docInHospital objectForKey:@"spec"];
            array_DocFromHospitals_loc  = [docInHospital objectForKey:@"loc"];

            str_HospitalNameSelected =[[NSString alloc] initWithFormat:@"%@", [array_Name objectAtIndex:rowNumber ]];

            
            [self.tv_DocFromHospitals reloadData];

            return ;
        }

        if(tableView == self.SDController.searchResultsTableView){
            CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath: indexPath];
            CGRect rectOfCellInSuperview = [tableView convertRect: rectOfCellInTableView toView: [tableView superview]];
            self.tv_DocFromHospitals.frame = CGRectMake(self.tv_DocFromHospitals.frame.origin.x
                                                        , rectOfCellInSuperview.origin.y / 2 + 70, self.tv_DocFromHospitals.frame.size.width, self.tv_DocFromHospitals.frame.size.height);

            self.tv_DocFromHospitals.alpha=1;

            NSString * firstLetter = [[_filteredDoctorList objectAtIndex:indexPath.row]substringToIndex:1];
            NSArray *values = [doctorsList valueForKey: firstLetter];
            NSInteger sectionNum = [alphabetsArray indexOfObject:firstLetter];
            NSInteger indexInSection = [values indexOfObject:[_filteredDoctorList objectAtIndex:indexPath.row]];
            NSInteger rowNumber = 0 ;
            for (NSInteger i = 0; i < sectionNum; i++)
            {
                rowNumber += [[doctorsList valueForKey:[alphabetsArray objectAtIndex:i]] count];
            }
            rowNumber += indexInSection;

            self.tv_selectedDoc.frame= CGRectMake(710,190, 300, 440) ;

            array_DocFromHospitals_id=[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllDoctors:@"3":[array_id objectAtIndex:rowNumber]] objectForKey:@"did"]];
            array_DocFromHospitals_cid=[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllDoctors:@"3":[array_id objectAtIndex:rowNumber]] objectForKey:@"cid"]];
            array_DocFromHospitals_name=[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllDoctors:@"3":[array_id objectAtIndex:rowNumber]] objectForKey:@"name"]];
            array_DocFromHospitals_spec=[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllDoctors:@"3":[array_id objectAtIndex:rowNumber]] objectForKey:@"spec"]];

            array_DocFromHospitals_loc=[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllDoctors:@"3":[array_id objectAtIndex:rowNumber]] objectForKey:@"loc"]];

            str_HospitalNameSelected =[[NSString alloc] initWithFormat:@"%@", [array_Name objectAtIndex:rowNumber ]];

            [self.view addSubview:self.tv_DocFromHospitals];
            [self.tv_DocFromHospitals reloadData];
            return ;
        }

        if (tableView==self.tv_DocFromHospitals) {
            if (countOfItem<10) {

                BOOL isTheObjectThere = [arr_Choose_name containsObject: [array_DocFromHospitals_name objectAtIndex:indexPath.row] ]; // check that object does not already exist

                if (!isTheObjectThere) {
                    NSString *str_hos_doc =[[NSString alloc]initWithFormat:@"%@ - %@ ",str_HospitalNameSelected,[array_DocFromHospitals_name objectAtIndex:indexPath.row ] ];
                    [arr_choose_CID addObject:[array_DocFromHospitals_id objectAtIndex:indexPath.row]];
                    [arr_Choose_name addObject: str_hos_doc ] ;
                    [arr_Choose_id addObject:[array_DocFromHospitals_cid objectAtIndex:indexPath.row]];
                    [arr_Choose_other addObject: [array_DocFromHospitals_spec objectAtIndex:indexPath.row]];
                    countOfItem ++ ;
                    [self.tv_selectedDoc reloadData];
                }

                selectChecked =TRUE;
            }else{
                UIAlertView* alert;
                alert = [[UIAlertView alloc] initWithTitle:@"Worng" message:@"Maximum selection 10 doctors." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
            }
            
        }
    }

 }


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView ==self.tv_allDoc) {
        //1. Setup the CATransform3D structure
        CATransform3D rotation;
        rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
        rotation.m34 = 1.0/ -600;
        
        //2. Define the initial state (Before the animation)
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        //cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
        //3. Define the final state (After the animation) and commit the animation
        [UIView beginAnimations:@"rotation" context:NULL];
        [UIView setAnimationDuration:0.8];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = .9;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
        
        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //yahia
    
    if (tableView == self.tv_selectedDoc) {
        
        // delete
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            [arr_Choose_id removeObjectAtIndex:indexPath.row];
            [arr_choose_CID removeObjectAtIndex:indexPath.row];
            [arr_Choose_name removeObjectAtIndex:indexPath.row];
            [arr_Choose_other removeObjectAtIndex:indexPath.row] ; 
            [self.tv_selectedDoc deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tv_selectedDoc reloadData];
            countOfItem--;
            if (countOfItem==0) {
                selectChecked=false;
            }
        } else {
            NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
        }
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tv_selectedDoc)
        
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
}


- (void)createAlphabetArray {
    
    NSMutableArray *tempFirstLetterArray = [[NSMutableArray alloc] init];
    doctorsList = [[NSMutableDictionary alloc] init];
    
    
    for (int i = 0; i < [array_id count]; i++) {
        NSString *letterString = [[array_Name objectAtIndex:i] substringToIndex:1];
        if (![tempFirstLetterArray containsObject:letterString]) {
            [tempFirstLetterArray addObject:letterString];
            NSMutableArray *tempDoctorsList = [[NSMutableArray alloc] init];
            for (int j = 0; j < [array_id count]; j++) {
                NSString *letterString2 = [[array_Name objectAtIndex:j] substringToIndex:1];
                if([letterString isEqualToString:letterString2]){
                    [tempDoctorsList addObject:[array_Name objectAtIndex:j]];
                }
            }
            [doctorsList setValue:tempDoctorsList forKey:letterString];
        }
    }
    alphabetsArray = tempFirstLetterArray;
    
}


#pragma SearchDisplayController

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    _SearchBar.frame = CGRectMake(14  , 64, 392, 44);
    _SearchBar.showsCancelButton = YES;
    [self.view addSubview:btn_Enter];
    
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    _SearchBar.frame = CGRectMake(14  , 64, 392, 44);
    [_filteredDoctorList removeAllObjects];
    [self.tv_allDoc reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"dismissed");
    [_filteredDoctorList removeAllObjects];
    [self.tv_allDoc reloadData];
    [_SearchBar resignFirstResponder];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [_filteredDoctorList removeAllObjects];
    NSString *element;
    
    for(element in array_Name){
        
        NSRange range = [element rangeOfString:searchString options:NSCaseInsensitiveSearch];
        
        if (range.length > 0) {
            
            [_filteredDoctorList addObject:element];
        }
    }
    [_SDController.searchResultsTableView reloadData];
    return YES;
}

-(void)searchDisplayController: (UISearchDisplayController*)controller  didShowSearchResultsTableView: (UITableView*)tableView {
    if (tableView ==self.tv_allDoc) {
        
        
        self.tv_allDoc.frame = CGRectMake(14 ,10 , 392, 300);
    }
    else if (tableView ==_SDController.searchResultsTableView){
        tableView.frame = CGRectMake(14 ,10 , 392, [_filteredDoctorList count]* 50);
    }
    
}

//- (void) keyboardWillHideHandler:(NSNotification *)notification {
//    //Close Keyboard
//    [self.searchDisplayController setActive:YES animated:YES];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//----------------------------------BackButton----------------------------------//



BeforeDoctorView *doc_ReloadDocView ;
-(IBAction)GoToBack:(id)sender{

    if (!doc_pharmacySessionStatus) {
        [self beforeDocList_backToHome:sender];
        return ;
    }
    self.tv_DocFromHospitals.alpha=0;
    [self.tv_DocFromHospitals removeFromSuperview];
    [self.tv_selectedDoc setFrame:CGRectMake(406,190, 550, 440)];
    
    [arr_Choose_name removeAllObjects];
    [arr_Choose_id removeAllObjects];
    [arr_Choose_other removeAllObjects];
    [arr_choose_CID removeAllObjects]; // if company is equal chiesi
    
    [self.tv_selectedDoc reloadData];
    
    doc_ReloadDocView =  [[BeforeDoctorView alloc] initWithReload];
    doc_ReloadDocView._BDoc_delegate = self ;
    [self.view addSubview:doc_ReloadDocView];
}

-(IBAction)reloadDoctorView:(id)sender{


    [doc_ReloadDocView removeFromSuperview];
    countOfItem = 0 ;
    Button *btn = sender;
    self.visit_Type= btn.tag ;

    [self getDocData ];


    [self.tv_DocFromHospitals setAlpha : 0];
    self.tv_selectedDoc.frame = CGRectMake(406,190, 550, 440) ;
   
    if (self.visit_Type == 2) {
        [self.tv_DocFromHospitals setAlpha : 1];
        self.tv_selectedDoc.frame= CGRectMake(710,190, 300, 440) ;
        
        self.tv_DocFromHospitals = [[UITableView alloc] initWithFrame:CGRectMake(410,_SBY, 270, 300)];
        self.tv_DocFromHospitals.delegate=self;
        self.tv_DocFromHospitals.dataSource=self;
        self.tv_DocFromHospitals.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_doc_table_bkg.png"]];
        self.tv_DocFromHospitals.superview.backgroundColor = [UIColor clearColor];
        self.tv_DocFromHospitals.userInteractionEnabled = YES;
        self.tv_DocFromHospitals.alpha=0;
        [self.view addSubview:self.tv_DocFromHospitals];
    }

}

-(void)beforeDocList_backToHome:(id)sender{
    if (self.reUpdateSession) {
        [self dismissViewControllerAnimated:true completion:nil];
        return ;
    }
    if (self.visit_Type == 3 && !doc_pharmacySessionStatus) {
        HomeViewController *syncView = [self.storyboard instantiateViewControllerWithIdentifier:@"enter"];
        [self presentViewController:syncView animated:NO completion:^(void){}];
        return;
    }
    NSString *strTotalTime = [[NSString alloc] initWithFormat:@"%f",self.doc_totalTime];
    [[DBManager getSharedInstance] saveSync:self.str_SesstionID
                             sync_totalTime: strTotalTime
                                   acc_time:self.doc_ACC
                                     doc_id:@""
                                   doc_cid :@""
                                   doc_name:@""
                                   doc_spec:@""
                               call_inquiry:@""
                             call_objection:@""
                                call_remark:@""
                                 doc_notice:@""
                                sample_drop:@""
                                 visitType :[NSString stringWithFormat:@"%ld", self.visit_Type]
     ];

    HomeViewController *syncView = [self.storyboard instantiateViewControllerWithIdentifier:@"enter"];
    [self presentViewController:syncView animated:NO completion:^(void){}];
}








@end
