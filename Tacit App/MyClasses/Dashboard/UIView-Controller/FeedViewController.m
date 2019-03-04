//
//  FeedViewController.m
//  DashboardSQL
//
//  Created by Yahia on 2/24/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()<UIPickerViewDataSource , UIPickerViewDelegate>

@end
UITextField *txt_callRemarks,*txt_callObjection ;
Button *btn_submit ;
//UIButton *btn_samplesDroped ;
NSMutableArray *_feedback_dataArray ;
NSString *_STR_SampleDrop = @"" ;
NSArray *feedback_sampleDic ;
@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"__FeedViewController");

    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_general_bkg.png"]]];
    

    Image *img_feed_Title = [[Image alloc] initWithFrame:@"dash_feedback_title.png" :420 :25];
    [self.view addSubview:img_feed_Title];

    NSString *str_img1 = @"dash_feed_1.png";
    NSString *str_img2 = @"dash_feed_2.png";
    NSString *str_img3 = @"dash_feed_3.png";

    _feedback_dataArray = [[NSMutableArray alloc] init];

    if (self._isPharmacy) {
        str_img1 = @"pharm_dash_feed_1.png";
        str_img2 = @"pharm_dash_feed_3.png";
        str_img3 = @"pharm_dash_feed_2.png";

        [_feedback_dataArray addObject:@"N/A"];
        [_feedback_dataArray addObject:@"YES"];
        [_feedback_dataArray addObject:@"NO"];

    } else {
        
        // Add some data for demo purposes. numbers for pickerView
        [_feedback_dataArray addObject:@"Zero"];
        [_feedback_dataArray addObject:@"One"];
        [_feedback_dataArray addObject:@"Two"];
        [_feedback_dataArray addObject:@"Three"];
        [_feedback_dataArray addObject:@"Four"];
        [_feedback_dataArray addObject:@"Five"];
        [_feedback_dataArray addObject:@"Six"];
        [_feedback_dataArray addObject:@"Seven"];
        [_feedback_dataArray addObject:@"Eight"];
        [_feedback_dataArray addObject:@"Nine"];
        [_feedback_dataArray addObject:@"Ten"];
        [_feedback_dataArray addObject:@"Eleven"];
        [_feedback_dataArray addObject:@"Twelve"];
        [_feedback_dataArray addObject:@"Thirteen"];
        [_feedback_dataArray addObject:@"Fourteen"];
        [_feedback_dataArray addObject:@"Fifteen"];
        [_feedback_dataArray addObject:@"Sixteen"];
        [_feedback_dataArray addObject:@"Seventeen"];
        [_feedback_dataArray addObject:@"Eighteen"];
        [_feedback_dataArray addObject:@"Nineteen"];
        [_feedback_dataArray addObject:@"Twenty"];
    }
    
    feedback_sampleDic = [[[ApplicationData getSharedInstance] initWithApplicationName:[self strAPP_name]] get_SAMPLETYPE_Array];
    
  

    Image *tac_feedback = [[Image alloc] initWithFrame:@"dash_logo.png" :700 :620];
    [self.view addSubview:tac_feedback];
    
    Image *feedback_sampleDroped = [[Image alloc] initWithFrame:str_img1 :95 :130];
    [self.view addSubview:feedback_sampleDroped];
    
    Image *feedback_allRemark = [[Image alloc] initWithFrame:str_img2 :feedback_sampleDroped.frame.origin.x :feedback_sampleDroped.frame.size.height + feedback_sampleDroped.frame.origin.y + 20 ];
    [self.view addSubview:feedback_allRemark];
    
    Image *feedback_callObjection = [[Image alloc] initWithFrame:str_img3 :feedback_sampleDroped.frame.origin.x  :feedback_allRemark.frame.size.height + feedback_allRemark.frame.origin.y + 20 ];
    [self.view addSubview:feedback_callObjection];

    _feedback_Pic =[[UIPickerView alloc] initWithFrame:CGRectMake(feedback_sampleDroped.frame.size.width + feedback_sampleDroped.frame.origin.x ,  feedback_sampleDroped.frame.origin.y +5, 600, feedback_sampleDroped.frame.size.height-10)];

    _feedback_Pic.dataSource = self;
    _feedback_Pic.delegate = self;
    [_feedback_Pic selectRow:[_strfeed_sample integerValue] inComponent:0 animated:YES];
    _feedback_Pic.showsSelectionIndicator = YES;
    
    //  _feedback_Pic.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_feedback_Pic];

    
    
    int selectedSampleTypeRow = 0 ;
    if (feedback_sampleDic.count > 0 && ![_feedback_sampleTypeSelected isEqualToString:@""]) {
        for (int i = 0 ; i < [feedback_sampleDic count ]; i++) {
            NSLog(@"Dic = %@ " , [[feedback_sampleDic objectAtIndex:i] uppercaseString]);
            NSLog(@"_feedback_sampleTypeSelected = %@ " , [_feedback_sampleTypeSelected uppercaseString]);
            if ([[[feedback_sampleDic objectAtIndex:i] uppercaseString] isEqualToString:[_feedback_sampleTypeSelected uppercaseString]]) {
                selectedSampleTypeRow = i ;
            }
        }
        if (selectedSampleTypeRow >= feedback_sampleDic.count) {
            selectedSampleTypeRow = 0;
        }
        [_feedback_Pic selectRow:selectedSampleTypeRow inComponent:1 animated:YES];
    }
    
    
    
    txt_callRemarks= [[UITextField alloc] initWithFrame:CGRectMake( _feedback_Pic.frame.origin.x ,  feedback_allRemark.frame.origin.y +5, 600, feedback_allRemark.frame.size.height-10)];
    txt_callRemarks.borderStyle = UITextBorderStyleRoundedRect;
    txt_callRemarks.delegate = self;
    txt_callRemarks.tag=1;
    txt_callRemarks.text=self.strfeed_remark ;
    [self.view addSubview:txt_callRemarks];
    
    txt_callObjection= [[UITextField alloc] initWithFrame:CGRectMake( txt_callRemarks.frame.origin.x ,  feedback_callObjection.frame.origin.y +5, 600, feedback_callObjection.frame.size.height-10)];
    txt_callObjection.borderStyle = UITextBorderStyleRoundedRect;
    txt_callObjection.delegate = self;
    txt_callObjection.tag=2;
    txt_callObjection.text=self.strfeed_objection;
    [self.view addSubview:txt_callObjection];
    
    Button *btn_cancel =[[Button alloc] initWithFrame:@"dash_cancel.png" :50:20];
    btn_cancel.tag=0;
    [btn_cancel addTarget:self action:@selector(feedback_ActionButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn_cancel];

    btn_submit=[[Button alloc] initWithFrame:@"Tacit-App_Rev00.jpeg" :900:20];
    btn_submit.tag=1;
    
    [btn_submit addTarget:self action:@selector(feedback_ActionButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn_submit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedback_keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


    UIPickerView *_feedback_Pic ;
//-(IBAction)txt_SampleActions:(id)sender{
//    NSLog(@">>>> %@",_STR_SampleDrop) ;
//    [_feedback_Pic removeFromSuperview ];
//    _feedback_Pic =[[UIPickerView alloc] initWithFrame:CGRectMake(btn_samplesDroped.frame.origin.x , 80 , btn_samplesDroped.frame.size.width, btn_samplesDroped.frame.size.height)];
//    _feedback_Pic.dataSource = self;
//    _feedback_Pic.delegate = self;
//    [_feedback_Pic selectRow:[_STR_SampleDrop integerValue] inComponent:0 animated:YES];
//    _feedback_Pic.showsSelectionIndicator = YES;
//  //  _feedback_Pic.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_feedback_Pic];
//    
//       [btn_samplesDroped setTitle:@"" forState:UIControlStateNormal];
//    
//
//    
//}
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{


    if ( self._isPharmacy)
    {
        _STR_SampleDrop =[_feedback_dataArray objectAtIndex:row];

    }
    else
    {
        if (component == 0 ) {
            _STR_SampleDrop = [NSString stringWithFormat:@"%ld",(long)row];
        }else{
           _feedback_sampleTypeSelected = [feedback_sampleDic objectAtIndex:row] ;
        }
        

    }

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([feedback_sampleDic count] > 0 ) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return  _feedback_dataArray.count ;
    }else if (component == 1){
       return feedback_sampleDic.count;
    }
    return 0 ;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (component == 0 ) {
        return [_feedback_dataArray objectAtIndex:row];

    }else {
       return [feedback_sampleDic objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    int sectionWidth = 50;
    
    return sectionWidth;
}

-(IBAction)feedback_ActionButtons:(id)sender{
    Button *btn =sender;
    if (btn.tag==0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else if (btn.tag==1){

        if ( self._isPharmacy)
        {
            _STR_SampleDrop = [_STR_SampleDrop isEqualToString:@""] ? @"Y/N" : _STR_SampleDrop ;
            
        }else{
            _STR_SampleDrop = [_STR_SampleDrop isEqualToString:@""] ? @"0" : _STR_SampleDrop ;
        }
        if (txt_callObjection.text.length==0||txt_callRemarks.text.length==0) {
            UIAlertView* alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Please enter full data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            [self submitFeedback];

        }

    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    if ( self._isPharmacy)
    {
        _STR_SampleDrop = [_STR_SampleDrop isEqualToString:@""] ? @"Y/N" : _STR_SampleDrop ;

    } else{
        _STR_SampleDrop = [_STR_SampleDrop isEqualToString:@""] ? @"0" : _STR_SampleDrop ;
    }



    if (txt_callObjection.text.length==0||txt_callRemarks.text.length==0) {
        UIAlertView* alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Please enter full data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
        
        [self submitFeedback];
        
    }
    
    
    
    return YES;
}
-(void)submitFeedback{
    NSString  *str_txt_samplesDroped =  [[[[[_STR_SampleDrop stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"]
                                            stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
                                           stringByReplacingOccurrencesOfString: @"'" withString: @"`"]
                                          stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"]
                                         stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
    
    NSString  *str_txt_callRemarks=  [[[[[txt_callRemarks.text stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"]
                                         stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
                                        stringByReplacingOccurrencesOfString: @"'" withString: @"`"]
                                       stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
    
    NSString  *str_txt_callObjection =  [[[[[txt_callObjection.text stringByReplacingOccurrencesOfString: @"&" withString: @"&amp;"]
                                            stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
                                           stringByReplacingOccurrencesOfString: @"'" withString: @"`"]
                                          stringByReplacingOccurrencesOfString: @">" withString: @"&gt;"]
                                         stringByReplacingOccurrencesOfString: @"<" withString: @"&lt;"];
    
    if (_feedback_sampleTypeSelected == nil) {
        _feedback_sampleTypeSelected = @"";
    }
    NSMutableArray *a=[[NSMutableArray alloc] initWithObjects:
                       str_txt_samplesDroped,
                       _feedback_sampleTypeSelected,
                       str_txt_callRemarks,
                       str_txt_callObjection ,
                       self.strVisitTime, nil];
    
    [[DBManager getSharedInstance] updateSyncData:a];
    SyncViewController *syncView = [self.storyboard instantiateViewControllerWithIdentifier:@"sync"];
    syncView.isComeFromHomeViewController = self._HomeViewStatus ;
    [self presentViewController:syncView animated:NO completion:^(void){}];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}
- (void) feedback_keyboardWillHideHandler:(NSNotification *)notification {
    //Close Keyboard
    [self.searchDisplayController setActive:NO animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    _strfeed_sample = @"" ;
    _STR_SampleDrop = @"" ;
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

@end
