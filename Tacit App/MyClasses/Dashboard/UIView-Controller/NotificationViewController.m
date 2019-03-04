//
//  NotificationViewController.m
//  Career Management Apps
//
//  Created by Yahia on 3/28/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import "NotificationViewController.h"
#import "Header.h"
#import "AppDelegate.h"
@interface NotificationViewController(){
@private   Activity_indicator_loading  *notification_Loader ;;
    
} @end

@implementation NotificationViewController


-(void)viewDidLoad{
    NSLog(@"__NotificationViewController");

    
    Image *bkg_Enter = [[Image  alloc] initWithFrame:@"dash_general_bkg.png" :0 :0];
    [self.view addSubview:bkg_Enter];
    Image *img_enter_Title = [[Image alloc] initWithFrame:@"dash_welcome.png" :450 :25];
    [self.view addSubview:img_enter_Title];
    
   
    
    //[[DBManager getSharedInstance]insertNotification:@"" message:@"Tws" sender:@"0" noti_Daye:@"Date"];
    
    //NSLog(@">>> NotiData %@ ",[[DBManager getSharedInstance] getNotifications]);
  
    Button *btnReload = [[Button alloc] initWithFrame:@"dash_btn_save1.png" :100 :40];
    [btnReload addTarget:self action:@selector(notification_ReloadTableView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReload];
    
    [self.tv_notifcationData removeFromSuperview];
    self.tv_notifcationData = [[UITableView alloc] initWithFrame:CGRectMake(50,100, 900, 500)];
    self.tv_notifcationData.center = CGPointMake(1024/2, 768/2);
    self.tv_notifcationData.delegate=self;
    self.tv_notifcationData.dataSource=self;
    self.tv_notifcationData.backgroundColor=[UIColor clearColor];
    self.tv_notifcationData.superview.backgroundColor = [UIColor clearColor];
    self.tv_notifcationData.userInteractionEnabled = YES;
    self.tv_notifcationData.separatorColor = [UIColor clearColor];
    
    [self.view addSubview:self.tv_notifcationData];

/*
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showReceivedMessage:)
                                                 name:appDelegate.messageKey
                                               object:nil];
*/
}


- (void) showReceivedMessage:(NSNotification *) notification {
    notification_Loader = [[Activity_indicator_loading alloc] init];
    [NSTimer scheduledTimerWithTimeInterval:1  target:self selector:@selector(notification_ReloadTableView:) userInfo:nil repeats:NO];
    [self.view addSubview:notification_Loader];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -TableView API

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //The Row Numbers

    return [[[[DBManager getSharedInstance] getNotifications] objectForKey:@"noti_id"] count] ;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //if (!cell) cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        //couldn't dequeue it, then initialize one
    }
    else {
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
    
    cell.textLabel.text = [[[[DBManager getSharedInstance] getNotifications] objectForKey:@"noti_string"] objectAtIndex:indexPath.row];
    return cell;
}

-(IBAction)notification_ReloadTableView:(id)sender{
    [self.tv_notifcationData reloadData];
    [notification_Loader removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion: nil];
}

@end
