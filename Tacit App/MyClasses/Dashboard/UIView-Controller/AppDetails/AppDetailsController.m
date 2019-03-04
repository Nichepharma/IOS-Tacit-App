//
//  AppDetailsController.m
//  Tacit App
//
//  Created by Yahia El-Dow on 10/3/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import "AppDetailsController.h"
#import "Read_WriteJSONFile.h"
#import "Activity_indicator_loading.h"
#import "ApplicationData.h"
#import "internetChecked.h"
#import "HomeViewController.h"
#define CUSTOM_CELL "appDetailCustomCell"

@implementation AppDetailsController

NSMutableDictionary * dictionaryOf_userApplications;
NSDictionary *appDetailsOnServer ;


-(void)viewDidLoad{
    [super viewDidLoad];
    internetChecked *internet =[[internetChecked alloc] init];
 dispatch_async(dispatch_get_main_queue(), ^{
    if (internet.Checked) {

        appDetailsOnServer = [GetDataFromServer serverApps_InfoArray];
    dictionaryOf_userApplications = [[NSMutableDictionary alloc]initWithDictionary:[Read_WriteJSONFile readJsonFileWithName:@"AppsForUser"]];

  //  NSLog(@"appDetailsOnServer %@ ",appDetailsOnServer);
    [self appDetail_TV].backgroundColor = [UIColor clearColor];

    [[self appDetail_TV] setBounces:false] ;
    [self.appDetail_TV reloadData];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"Sorry no internet connection"
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil , nil];
        [alert show];


    }
});

}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)dismissAppDetails:(id)sender {

    if (isDownload) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"please wait Product finishing the Download"
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil , nil];
        [alert show];
    }else{
        HomeViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"enter"];
        [self presentViewController:homeVC animated:YES completion:nil];
    }

}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //The Row Numbers
    return [[dictionaryOf_userApplications objectForKey:@"product"] count] ;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDetailCustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:@CUSTOM_CELL];
    customCell.delegate = self ;
    [customCell setBackgroundColor:[UIColor clearColor]];

    NSString *app_name    = [[[[dictionaryOf_userApplications objectForKey:@"product"] objectAtIndex:indexPath.row] objectForKey:@"pName"] capitalizedString];
    NSString *app_version = [NSString stringWithFormat:@"%@",[[[dictionaryOf_userApplications objectForKey:@"product"]  objectAtIndex:indexPath.row]objectForKey:@"version"]];
    NSString *app_versionOnServer =  [[NSString stringWithFormat:@"%@",[appDetailsOnServer objectForKey:[app_name localizedCapitalizedString]]] capitalizedString] ;

    [[customCell app_details_lbl_name]setText:app_name];
    [customCell  app_details_lbl_currentVersion].text  = [self applicationIsDownloaded:app_name] == true ? app_version : @"-" ;
    [[customCell app_details_lbl_versionOnServer]setText:app_versionOnServer];
    [[customCell app_details_btn_download]setEnabled:false];
    [[customCell app_details_indecator_load] stopAnimating];
    [[customCell app_details_btn_download]setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    if ([app_version doubleValue] < [app_versionOnServer doubleValue]  || ![self applicationIsDownloaded:app_name]) {
         [[customCell app_details_btn_download]setEnabled:true];
         [[customCell app_details_btn_download] setTag:indexPath.row];
         [[customCell app_details_btn_download]setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }

    return customCell;

    }


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDetailCustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:@CUSTOM_CELL];

    UIAlertController *deleteApp_alertController = [UIAlertController
                                                    alertControllerWithTitle:NSLocalizedString(@"Message", nil)
                                                    message:NSLocalizedString(@"please Wait, the application still download ", nil)
                                                    preferredStyle:UIAlertControllerStyleActionSheet | UIAlertControllerStyleAlert] ;

    UIAlertAction *delete_Action = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Yes", @"will Delete ")
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction *action)
                                    {
                                        NSString *appName =[NSString stringWithFormat:@"%@" , [[[dictionaryOf_userApplications objectForKey:@"product"] objectAtIndex:indexPath.row] objectForKey:@"pName"]] ;


                                        [Download_Remove_Content removeApplication: appName];

                                        [customCell reloadInputViews];
                                        [customCell.contentView reloadInputViews];
                                        [[self appDetail_TV] reloadData];

                                    }];

    UIAlertAction *cancel_Action = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                    style:UIAlertActionStyleCancel
                                    handler:nil];


    [deleteApp_alertController addAction:delete_Action];
    [deleteApp_alertController addAction:cancel_Action];
    [self presentViewController:deleteApp_alertController animated:YES completion:nil];
    


}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete;
}



-(BOOL)applicationIsDownloaded : (NSString *)app_name{
    return  [Download_Remove_Content checkExistFileWithFileName:app_name];
}


bool isDownload = false ;
-(void)didStartUpdate{
    isDownload = true ;
}




-(void)didFinshUpdate:(NSString *)app_name{

    for (int i = 0 ; i < [[dictionaryOf_userApplications objectForKey:@"product"] count] ; i++) {
       NSString *temp_appName =  [[[dictionaryOf_userApplications  objectForKey:@"product"] objectAtIndex:i]objectForKey:@"pName"];
       NSString *temp_appID =  [[[dictionaryOf_userApplications  objectForKey:@"product"] objectAtIndex:i]objectForKey:@"pid"];

        if ([[temp_appName lowercaseString] isEqualToString:[app_name lowercaseString]]) {

            if (![appDetailsOnServer objectForKey:[app_name localizedCapitalizedString]] ) {
                isDownload = false ;
                [[self appDetail_TV] reloadData];
                return;
            }

            NSDictionary *arr_newData =  @{ @"pName"    : app_name ,
                                            @"pid"   : temp_appID ,
                                            @"version" : [appDetailsOnServer objectForKey:[app_name localizedCapitalizedString]]  ,
                                            };
            // remove old data
            [[dictionaryOf_userApplications  objectForKey:@"product"] removeObjectAtIndex:i];
            [[dictionaryOf_userApplications  objectForKey:@"product"] insertObject:arr_newData atIndex:i];
            NSError * err;
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dictionaryOf_userApplications options:0 error:&err];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            NSLog(@"%@",myString);

            [Read_WriteJSONFile writeStringWithData:myString fileName:@"AppsForUser"];

            isDownload = false ;
            [[self appDetail_TV] reloadData];
            return;
        }
    }


}


-(void)finshWithError {
    [AlertController showAlertWithSingleButton:@"Cancel" presentOnViewController:self
                                    alertTitle:@"Info"
                                  alertMessage:@"Error to Download Files ... "];
    [[self appDetail_TV] reloadData];
}
@end
