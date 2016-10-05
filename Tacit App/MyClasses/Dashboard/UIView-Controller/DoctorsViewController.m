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
@property (strong,nonatomic) NSMutableArray *filteredDoctorList ,*alphabetsArray,*docName , *docId, *docSpec;
@property (strong , nonatomic) UITableView *tv_allDoc ,*tv_selectedDoc;
@property (strong,nonatomic) IBOutlet UISearchDisplayController *SDController;
@property (strong,nonatomic) IBOutlet UISearchBar *SearchBar;


@end

@implementation DoctorsViewController
@synthesize docId,docName,docSpec,alphabetsArray,doctorsList;

NSMutableArray *arr_docChoose_name,*arr_docChoose_id,*arr_docChoose_spec;
Activity_indicator_loading *loaded ;
internetChecked *doc_checkedInternet ;
NSInteger countOfItem =0 ;
bool selectChecked =false;
Button *btn_Enter ,*btn_refreshing;
- (void)viewDidLoad {


    NSLog(@"self.str_SesstionID  = %@" , self.str_SesstionID );


    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_general_bkg.png"]]];
    
    Image *img_Doctor_Title = [[Image alloc] initWithFrame:@"dash_doc_select_doctor_title.png" :420 :25];
    [self.view addSubview:img_Doctor_Title];
    
    Image *tacc_Doctors = [[Image alloc] initWithFrame:@"dash_logo.png" :700 :620];
    [self.view addSubview:tacc_Doctors];
    
    
    
    [self getDocData];
    
    [arr_docChoose_name removeAllObjects];
    [arr_docChoose_id removeAllObjects];
    [arr_docChoose_spec removeAllObjects];
    countOfItem = 0 ;
    arr_docChoose_name =[[NSMutableArray alloc] init];
    arr_docChoose_id =[[NSMutableArray alloc] init];
    arr_docChoose_spec =[[NSMutableArray alloc] init];

    _filteredDoctorList =[[NSMutableArray alloc] init];
    UIView *_DocTVBKG = [[UIView alloc] initWithFrame:CGRectMake(14, 65, 392, 700)];
    _DocTVBKG.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_doc_table_bkg.png"]];
    [self.view addSubview:_DocTVBKG];
    
    self.tv_allDoc = [[UITableView alloc] initWithFrame:CGRectMake(14,108, 392, 650)];
    self.tv_allDoc.delegate=self;
    self.tv_allDoc.dataSource=self;
    //self.tv_allDoc.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_doc_table_bkg.png"] ];
    self.tv_allDoc.backgroundColor=[UIColor clearColor];
    self.tv_allDoc.superview.backgroundColor = [UIColor clearColor];
    self.tv_allDoc.userInteractionEnabled = YES;
  //  self.tv_allDoc.
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





    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWillHideHandler:)
    //                                                 name:UIKeyboardWillHideNotification
    //                                               object:nil];
    [self createAlphabetArray];
    [self.tv_allDoc reloadData];
    
    
//   btn_refreshing =[[Button alloc] initWithFrame:@"refresh.png" :100 :700];
//    btn_refreshing.tag=0;
//    [btn_refreshing addTarget:self action:@selector(doc_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn_refreshing];
    
    
    btn_Enter=[[Button alloc] initWithFrame:@"dash_done.png" :900 :27];
    btn_Enter.tag=1;
    [btn_Enter addTarget:self action:@selector(doc_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_Enter];
    
    [_SearchBar bringSubviewToFront:btn_Enter];
    [btn_refreshing bringSubviewToFront:_SearchBar];
    
}
-(void)getDocData{
    [docId removeAllObjects];
    [docName removeAllObjects];
    [docSpec removeAllObjects];
    
    
    if (![docId count] ||![docName count]||![docSpec count]) {
        docId=[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllDoctors] objectForKey:@"did"]];
        docName =[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllDoctors] objectForKey:@"name"]];
        docSpec=[[NSMutableArray alloc] initWithArray:[[[DBManager getSharedInstance]getAllDoctors] objectForKey:@"spec"]];
    }
    
  //   NSLog(@"Doc ID = %@ , Doc Name = %@ , Doc Spec  = %@",docId ,docName,docSpec  );
    
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
                TimerCalculate *timeclc =[[TimerCalculate alloc] init];
            
                NSString * did=@"";
                NSString * dname=@"";
                NSString * dspec=@"";
                
                for (NSString *n in arr_docChoose_id ) {
                    did = [did stringByAppendingFormat:@"%@|",n];
                }
                for (NSString *n in arr_docChoose_name ) {
                    dname = [dname stringByAppendingFormat:@"%@|",n];
                    
                }
                for (NSString *n in arr_docChoose_spec ) {
                    dspec = [dspec stringByAppendingFormat:@"%@|",n];
                    
                }
                NSString *strTotalTime = [[NSString alloc] initWithFormat:@"%f",self.doc_totalTime];
    
                [[DBManager getSharedInstance] saveSync:self.str_SesstionID
                                               sync_totalTime: strTotalTime
                                               acc_time:self.doc_ACC
                                               doc_id:did
                                               doc_name:dname
                                               doc_spec:dspec
                                               call_inquiry:@""
                                               call_objection:@""
                                               call_remark:@""
                                               doc_notice:@""
                                               sample_drop:@""];
//                 NSLog(@">>>>> %@",[timeclc str_SessionID]);
                SyncViewController *syncView = [self.storyboard instantiateViewControllerWithIdentifier:@"sync"];
                [self presentViewController:syncView animated:NO completion:^(void){}];
                
            }else{
               
                [AlertController showAlertWithSingleButton:@"OK" presentOnViewController:self alertTitle:@"Worng" alertMessage:@"Please Select  Doctor First  " ];
 
            }
            break;
        default:
            break;
}
    
}

-(IBAction)doc_counterFire:(id)sender{
    doc_checkedInternet =[[internetChecked alloc] init];
    if (doc_checkedInternet.Checked ) {
          [GetAllDoctorsFromServer get_Doc] ;
        [self getDocData];
        [self.tv_allDoc reloadData];
   
    }else{
 
           [AlertController showAlertWithSingleButton:@"OK" presentOnViewController:self alertTitle:@"Worng" alertMessage:@"no internet connection ! " ];

    }
    [loaded stop];
    [loaded removeFromSuperview];
    
}
#pragma TableView API

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // section number .. alphabetical array
    
    if (tableView == _SDController.searchResultsTableView || tableView==self.tv_selectedDoc) {
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
//    
//}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //The Row Numbers
    
    if (tableView == self.tv_allDoc) {
        
        NSArray *values = [doctorsList valueForKey:[alphabetsArray objectAtIndex:section]];
        return [values count];
    }
    else if (tableView == _SDController.searchResultsTableView) {
        return [_filteredDoctorList count];
    }else{
        return arr_docChoose_name.count ;
    }
    
    
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
 

    
    
    if(tableView == self.tv_selectedDoc){

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *strObject =[[NSString alloc] initWithFormat:@"%i - %@",indexPath.row+1 ,[arr_docChoose_name objectAtIndex:indexPath.row]];
        cell.textLabel.text =strObject ;
        if (indexPath.row %2 != 0 ) {
        
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_blue_heder.png"]];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
    }else   if (tableView == self.tv_allDoc) {
        
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
        NSString *strCellDetail = [[NSString alloc] initWithFormat:@"%@", [[[[DBManager getSharedInstance]getAllDoctors] objectForKey:@"spec"] objectAtIndex:rowNumber]];
        cell.detailTextLabel.text=strCellDetail;
        cell.detailTextLabel.textColor=[UIColor whiteColor];

        
    }else if (tableView == _SDController.searchResultsTableView) {
        
        cell.textLabel.text = [_filteredDoctorList objectAtIndex:indexPath.row];
        
    }
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tv_allDoc  ) {
        
        
        NSArray *values = [doctorsList valueForKey:[alphabetsArray objectAtIndex:indexPath.section]]; // get whole section into an array
        if (countOfItem<10) {
            
            BOOL isTheObjectThere = [arr_docChoose_name containsObject: [values objectAtIndex:indexPath.row ] ]; // check that object does not already exist
            if (!isTheObjectThere) {
                NSInteger rowNumber = 0;
                for (NSInteger i = 0; i < indexPath.section; i++) {
                    rowNumber += [self tableView:tableView numberOfRowsInSection:i];
                }
                rowNumber += indexPath.row; // calculate the index but adding of section index + row index of the sesion
                
                [arr_docChoose_name addObject: [docName objectAtIndex:rowNumber ] ] ;
                [arr_docChoose_id addObject:   [docId objectAtIndex:rowNumber]];
                [arr_docChoose_spec addObject: [docSpec objectAtIndex:rowNumber ]];
                countOfItem ++;
                [self.tv_selectedDoc reloadData];
            }
            
            selectChecked =TRUE;
        }else{
            
            [AlertController showAlertWithSingleButton:@"OK" presentOnViewController:self alertTitle:@"!" alertMessage:@"No More than 10 Doctor can be selected" ];

        }
    }
    else if(tableView == self.SDController.searchResultsTableView){
        
        NSString * firstLetter = [[_filteredDoctorList objectAtIndex:indexPath.row]substringToIndex:1];
        NSArray *values = [doctorsList valueForKey: firstLetter];
        NSInteger sectionNum = [alphabetsArray indexOfObject:firstLetter];
        NSInteger indexInSection = [values indexOfObject:[_filteredDoctorList objectAtIndex:indexPath.row]];
        NSInteger rowNumber = 0 ;
        for (NSInteger i = 0; i < sectionNum; i++) {
            
            rowNumber += [[doctorsList valueForKey:[alphabetsArray objectAtIndex:i]] count];
        }
        rowNumber += indexInSection;
        
        if (countOfItem<10) {
            BOOL isTheObjectThere = [arr_docChoose_name containsObject: [_filteredDoctorList objectAtIndex:indexPath.row] ]; // check that object does not already exist
            if (!isTheObjectThere) {
                [arr_docChoose_name addObject: [_filteredDoctorList objectAtIndex:indexPath.row]] ;
                [arr_docChoose_id addObject:   [docId objectAtIndex:rowNumber]];
                [arr_docChoose_spec addObject: [docSpec objectAtIndex:rowNumber ]];
                countOfItem ++;
                [self.tv_selectedDoc reloadData];
            }
            
            selectChecked =TRUE;
            
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
            
            [arr_docChoose_id removeObjectAtIndex:indexPath.row];
            [arr_docChoose_name removeObjectAtIndex:indexPath.row];
            [arr_docChoose_spec removeObjectAtIndex:indexPath.row] ; 
            [self.tv_selectedDoc deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tv_selectedDoc reloadData];
            countOfItem--;
            if (countOfItem==0) {
                selectChecked=false;
            }
        } else {
            NSLog(@"Unhandled editing style! %d", editingStyle);
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
    
    
    for (int i = 0; i < [docId count]; i++) {
        NSString *letterString = [[docName objectAtIndex:i] substringToIndex:1];
        if (![tempFirstLetterArray containsObject:letterString]) {
            [tempFirstLetterArray addObject:letterString];
            NSMutableArray *tempDoctorsList = [[NSMutableArray alloc] init];
            for (int j = 0; j < [docId count]; j++) {
                NSString *letterString2 = [[docName objectAtIndex:j] substringToIndex:1];
                if([letterString isEqualToString:letterString2]){
                    [tempDoctorsList addObject:[docName objectAtIndex:j]];
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
    
    for(element in docName){
        
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

@end
