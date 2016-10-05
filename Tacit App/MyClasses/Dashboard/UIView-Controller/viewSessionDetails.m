//
//  viewSessionDetails.m
//  DashboardSQL
//
//  Created by Yahia on 2/25/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "viewSessionDetails.h"

@implementation viewSessionDetails


UITableView *tv_detailData , *tv_detailData2;

NSMutableArray *_viewSession_arr_docName ,*_viewSession_arr_docSpec ;
NSString *_viewSession_str_du ,*_viewSession_str_sessionID;

int _viewSession_y =0;

const int __Sesstion_BigView_X = 550 ;
- (id)initWithFrame:(CGRect)frame :(double)num_SesstionBigView_Y {
    self = [super initWithFrame:frame];
    
    if (self) {
      
        
        
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:.5];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
        
       
        UIView *__Sesstion_BigView =  [[UIView alloc] initWithFrame:CGRectMake(__Sesstion_BigView_X, num_SesstionBigView_Y -20 , 240, 280)];
        __Sesstion_BigView.backgroundColor = [self colorWithHexString:@"666666"];
        
        Image *__viewSession_arrow = [[Image alloc ] initWithFrame:@"dash_session_2.png" :-65 :30];
        [__Sesstion_BigView addSubview:__viewSession_arrow];
        
        
        
        
        Image *_viewSession = [[Image alloc] initWithFrame:@"dash_session_1.png" :0 :0];
        _viewSession.frame = CGRectMake(0, 0, 240, _viewSession.frame.size.height);
        [__Sesstion_BigView addSubview:_viewSession];
      
        Button *btn_SessionSamaryClose =[UIButton buttonWithType:UIButtonTypeContactAdd];
         btn_SessionSamaryClose.frame=CGRectMake(200, 5, 30, 30);
        [btn_SessionSamaryClose addTarget:self action:@selector(_sesstion_samaryClosed:) forControlEvents:UIControlEventTouchUpInside] ;
        [btn_SessionSamaryClose.layer setBorderColor:[[UIColor whiteColor] CGColor]];
         btn_SessionSamaryClose.transform=CGAffineTransformMakeRotation(2.4);
        [__Sesstion_BigView addSubview:btn_SessionSamaryClose];
  
        _viewSession_arr_docName = [[NSMutableArray alloc] initWithArray:[[[ReturnSesstionDetails sharedInstance] getData] objectForKey:@"docName"]];
        [_viewSession_arr_docName removeLastObject];
    
        _viewSession_arr_docSpec = [[NSMutableArray alloc] initWithArray:[[[ReturnSesstionDetails sharedInstance] getData] objectForKey:@"docSpec"]];
        [_viewSession_arr_docSpec removeLastObject];
        
        _viewSession_str_sessionID =[[[ReturnSesstionDetails sharedInstance] getData] objectForKey:@"id"] ;
        _viewSession_str_du =[[[ReturnSesstionDetails sharedInstance] getData] objectForKey:@"du"] ;
        
        
        
        Label *__lblSession = [[Label alloc] initWithFrame:CGRectMake(0,   _viewSession.frame.size.height+ _viewSession.frame.origin.y +10, __Sesstion_BigView.frame.size.width , 50) : [NSString stringWithFormat:@"  Session:\n  %@",_viewSession_str_sessionID ]:14];
        __lblSession.textColor = [UIColor whiteColor];
        __lblSession.backgroundColor = [self colorWithHexString:@"979797"];
        [__Sesstion_BigView addSubview:__lblSession];
        
        
        
        
            tv_detailData = [[UITableView alloc] initWithFrame:CGRectMake(0, __lblSession.frame.size.height+ __lblSession.frame.origin.y +10
                                                                                , __Sesstion_BigView.frame.size.width, 113 )];
                tv_detailData.delegate=self;
                tv_detailData.dataSource=self;
                tv_detailData.backgroundColor= [self colorWithHexString:@"979797"];
                tv_detailData.superview.backgroundColor = [self colorWithHexString:@"979797"];
                tv_detailData.userInteractionEnabled = YES;
                //tv_detailData.backgroundColor=[UIColor yellowColor];
                tv_detailData.separatorColor=[UIColor clearColor];
                [__Sesstion_BigView addSubview:tv_detailData];
        
        
        
      int  durr = [_viewSession_str_du doubleValue];

        int seconds = durr % 60;
        int minutes = (durr/ 60) % 60;
        int hours = durr / 3600;


        
        Label *__lblSession_Du = [[Label alloc] initWithFrame:CGRectMake(0,   tv_detailData.frame.size.height+ tv_detailData.frame.origin.y +10, __Sesstion_BigView.frame.size.width , 30) : [NSString stringWithFormat:@"  Duration:  %d:%d:%d",hours, minutes, seconds]:16];
        __lblSession_Du.textColor = [UIColor whiteColor];
        __lblSession_Du.backgroundColor = [self colorWithHexString:@"979797"];
        [__Sesstion_BigView addSubview:__lblSession_Du];

        
        
//        Label *__lblSession_DoctorSpecTitle = [[Label alloc] initWithFrame:CGRectMake(20,   tv_detailData.frame.size.height+ tv_detailData.frame.origin.y +10, self.frame.size.width - 20, 20) : [NSString stringWithFormat:@"Spec:"]:14];
//        __lblSession_DoctorSpecTitle.textColor = [UIColor whiteColor];
//        [self addSubview:__lblSession_DoctorSpecTitle];
//        
//        
//        tv_detailData2 = [[UITableView alloc] initWithFrame:CGRectMake(20, __lblSession_DoctorSpecTitle.frame.size.height+ __lblSession_DoctorSpecTitle.frame.origin.y
//                                                                      , self.frame.size.width-30, 100 )];
//        tv_detailData2.delegate=self;
//        tv_detailData2.dataSource=self;
//        tv_detailData2.backgroundColor=[UIColor clearColor];
//        tv_detailData2.superview.backgroundColor = [UIColor clearColor];
//        tv_detailData2.userInteractionEnabled = YES;
//        //tv_detailData2.backgroundColor=[UIColor yellowColor];
//        tv_detailData2.separatorColor=[UIColor clearColor];
//        [self addSubview:tv_detailData2];
        
        
        
        [self addSubview:__Sesstion_BigView];
    }
    
    return self;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{   return @"Doctors"; }



-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  return [_viewSession_arr_docName count]; }

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
   
    cell.textLabel.text = [_viewSession_arr_docName objectAtIndex:indexPath.row] ;
    cell.detailTextLabel.text = [_viewSession_arr_docSpec objectAtIndex:indexPath.row] ;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
    
}
-(UIColor*)colorWithHexString:(NSString*)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}




-(IBAction) _sesstion_samaryClosed:(id)sender{
    [self removeFromSuperview];
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
   // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
        [self removeFromSuperview];
}

@end
