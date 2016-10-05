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
UIButton *btn_samplesDroped ;
NSMutableArray *_feedback_dataArray ;
NSString *_STR_SampleDrop ;
@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_general_bkg.png"]]];
    Image *tac_feedback = [[Image alloc] initWithFrame:@"dash_logo.png" :700 :620];
    [self.view addSubview:tac_feedback];
    
    Image *feedback_sampleDroped = [[Image alloc] initWithFrame:@"dash_feed_1.png" :95 :130];
    [self.view addSubview:feedback_sampleDroped];
    
    Image *feedback_allRemark = [[Image alloc] initWithFrame:@"dash_feed_2.png" :feedback_sampleDroped.frame.origin.x :feedback_sampleDroped.frame.size.height + feedback_sampleDroped.frame.origin.y + 20 ];
    [self.view addSubview:feedback_allRemark];
    
    Image *feedback_callObjection = [[Image alloc] initWithFrame:@"dash_feed_3.png" :feedback_sampleDroped.frame.origin.x  :feedback_allRemark.frame.size.height + feedback_allRemark.frame.origin.y + 20 ];
    [self.view addSubview:feedback_callObjection];
    
    //[ txt_samplesDroped addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(txt_SampleActions:)]];

    
    
    
 

    btn_samplesDroped =[ [UIButton alloc] initWithFrame:CGRectMake(feedback_sampleDroped.frame.size.width + feedback_sampleDroped.frame.origin.x ,  feedback_sampleDroped.frame.origin.y +5, 600, feedback_sampleDroped.frame.size.height-10  ) ] ;
    btn_samplesDroped.backgroundColor = [UIColor whiteColor];
    btn_samplesDroped.layer.cornerRadius = 4.0f;
    [btn_samplesDroped setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_samplesDroped addTarget:self action:@selector(txt_SampleActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_samplesDroped];
    
    if ([_strfeed_sample isEqualToString:@"0"]||[self.strfeed_sample isEqualToString:@""]){
        [btn_samplesDroped setTitle:@"Zero"  forState:UIControlStateNormal];
    }else if ([_strfeed_sample isEqualToString:@"1"]) {
        [btn_samplesDroped setTitle:@"One"  forState:UIControlStateNormal];
    }else if ([_strfeed_sample isEqualToString:@"2"]){
        [btn_samplesDroped setTitle:@"Two"  forState:UIControlStateNormal];
    }else if ([_strfeed_sample isEqualToString:@"3"]){
        [btn_samplesDroped setTitle:@"Three"  forState:UIControlStateNormal];
    }else if ([_strfeed_sample isEqualToString:@"4"]){
        [btn_samplesDroped setTitle:@"Four"  forState:UIControlStateNormal];
    }else if ([_strfeed_sample isEqualToString:@"5"]){
        [btn_samplesDroped setTitle:@"Five"  forState:UIControlStateNormal];
    }
    
    if ([self.strfeed_sample length]<1) {
        _STR_SampleDrop = @"0";
         [btn_samplesDroped setTitle:@"Zero"  forState:UIControlStateNormal];
    }else   _STR_SampleDrop  =self.strfeed_sample ;
    
    
    txt_callRemarks= [[UITextField alloc] initWithFrame:CGRectMake( btn_samplesDroped.frame.origin.x ,  feedback_allRemark.frame.origin.y +5, 600, feedback_allRemark.frame.size.height-10)];
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
    
    
    btn_submit=[[Button alloc] initWithFrame:@"dash_btn_submit.png" :900:20];
    btn_submit.tag=1;
    
    [btn_submit addTarget:self action:@selector(feedback_ActionButtons:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: btn_submit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedback_keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
  _feedback_dataArray = [[NSMutableArray alloc] init];
    
    // Add some data for demo purposes.
   
    [_feedback_dataArray addObject:@"Zero"];
    [_feedback_dataArray addObject:@"One"];
    [_feedback_dataArray addObject:@"Two"];
    [_feedback_dataArray addObject:@"Three"];
    [_feedback_dataArray addObject:@"Four"];
    [_feedback_dataArray addObject:@"Five"];

    

    
}
    UIPickerView *_feedback_Pic ;
-(IBAction)txt_SampleActions:(id)sender{
    NSLog(@">>>> %@",_STR_SampleDrop) ;
    [_feedback_Pic removeFromSuperview ];
    _feedback_Pic =[[UIPickerView alloc] initWithFrame:CGRectMake(btn_samplesDroped.frame.origin.x , 80 , btn_samplesDroped.frame.size.width, btn_samplesDroped.frame.size.height)];
    _feedback_Pic.dataSource = self;
    _feedback_Pic.delegate = self;
    [_feedback_Pic selectRow:[_STR_SampleDrop integerValue] inComponent:0 animated:YES];
    _feedback_Pic.showsSelectionIndicator = YES;
  //  _feedback_Pic.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_feedback_Pic];
    
       [btn_samplesDroped setTitle:@"" forState:UIControlStateNormal];
    

    
}
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
 //   btn_samplesDroped.text = [_feedback_dataArray  objectAtIndex:row];
    
    
    if ([[_feedback_dataArray  objectAtIndex:row] isEqualToString:@"Zero"]) {
        _STR_SampleDrop = @"0";
    }else if ([[_feedback_dataArray  objectAtIndex:row] isEqualToString:@"One"]){
        _STR_SampleDrop = @"1";
    }else if ([[_feedback_dataArray  objectAtIndex:row] isEqualToString:@"Two"]){
        _STR_SampleDrop = @"2";
    }else if ([[_feedback_dataArray  objectAtIndex:row] isEqualToString:@"Three"]){
         _STR_SampleDrop = @"3";
    }else if ([[_feedback_dataArray  objectAtIndex:row] isEqualToString:@"Four"]){
         _STR_SampleDrop = @"4";
    }else if ([[_feedback_dataArray  objectAtIndex:row] isEqualToString:@"Five"]){
         _STR_SampleDrop = @"5";
    }
    
    
    [btn_samplesDroped setTitle:[_feedback_dataArray  objectAtIndex:row] forState:UIControlStateNormal];
        [_feedback_Pic removeFromSuperview ];
    
//    [UIView animateWithDuration:1.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void) {
//        
//        _feedback_Pic.frame =CGRectMake(0, 900, 1024,200) ;
//        
//    } completion:^(BOOL finished){
//
//    }];
//    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_feedback_dataArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return [_feedback_dataArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    int sectionWidth = 50;
    
    return sectionWidth;
}

-(IBAction)feedback_ActionButtons:(id)sender{
    Button *btn =sender;
    if (btn.tag==0) {
        SyncViewController  *sync = [self.storyboard instantiateViewControllerWithIdentifier:@"sync"];
        [self presentViewController:sync animated:NO completion:^(void){}];
        
    }else if (btn.tag==1){
        if (txt_callObjection.text.length==0||txt_callRemarks.text.length==0||_STR_SampleDrop.length==0) {
            UIAlertView* alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Please Enter Full Data " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{
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
            
            
            NSMutableArray *a=[[NSMutableArray alloc] initWithObjects:str_txt_samplesDroped,
                               str_txt_callRemarks,
                               str_txt_callObjection
                               ,self.strVisitTime, nil];
            NSLog(@"%hhd,", [[DBManager getSharedInstance] updateSyncData:a]);
            
            SyncViewController *syncView = [self.storyboard instantiateViewControllerWithIdentifier:@"sync"];
            [self presentViewController:syncView animated:NO completion:^(void){}];
            
        }
        
        
        
    }
}






- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (txt_callObjection.text.length==0||txt_callRemarks.text.length==0||_STR_SampleDrop.length==0) {
        UIAlertView* alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Please Enter Full Data " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
        
        NSMutableArray *a=[[NSMutableArray alloc] initWithObjects:_STR_SampleDrop,txt_callRemarks.text,txt_callObjection.text,self.strVisitTime, nil];
        NSLog(@"%hhd,", [[DBManager getSharedInstance] updateSyncData:a]);
        
        SyncViewController *syncView = [self.storyboard instantiateViewControllerWithIdentifier:@"sync"];
        [self presentViewController:syncView animated:NO completion:^(void){}];
        
    }
    
    
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void) feedback_keyboardWillHideHandler:(NSNotification *)notification {
    //Close Keyboard
    
    [self.searchDisplayController setActive:NO animated:YES];
}




@end
