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

#define CUSTOM_CELL "appDetailCustomCell"

@implementation AppDetailsController

NSMutableDictionary * dictionaryOf_userApplications;
NSDictionary *appDetailsOnServer ;



-(void)viewDidLoad{
    [super viewDidLoad];
    internetChecked *internet =[[internetChecked alloc] init];

    if (internet.Checked) {

    appDetailsOnServer = [Read_WriteJSONFile readJsonfromServer:@"http://www.tacitapp.com/Yahia/tacitapp/appVersion.txt"];
    dictionaryOf_userApplications = [[NSMutableDictionary alloc]initWithDictionary:[Read_WriteJSONFile readJsonFileWithName:@"AppsForUser"]];

    NSLog(@"appDetailsOnServer %@ ",dictionaryOf_userApplications);
    [self appDetail_TV].backgroundColor = [UIColor clearColor];

    [[self appDetail_TV] setBounces:false] ;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"Sorry no internet connection"
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil , nil];
        [alert show];


    }

}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)dismissAppDetails:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //The Row Numbers
    return [[dictionaryOf_userApplications objectForKey:@"apps"] count] ;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDetailCustomCell *customCell = [tableView dequeueReusableCellWithIdentifier:@CUSTOM_CELL];
    customCell.delegate = self ;
    [customCell setBackgroundColor:[UIColor clearColor]];

    NSString *app_name    = [[[dictionaryOf_userApplications objectForKey:@"apps"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *app_version = [[[dictionaryOf_userApplications objectForKey:@"apps"]  objectAtIndex:indexPath.row]objectForKey:@"version"];
    NSString *app_versionOnServer =  [appDetailsOnServer objectForKey:[app_name localizedCapitalizedString]] ;

    [[customCell app_details_lbl_name]setText:app_name];
    [customCell app_details_lbl_currentVersion].text  = [self applicationIsDownloaded:app_name] == true ? app_version : @"-" ;
    [[customCell app_details_lbl_versionOnServer]setText:app_versionOnServer];
    [[customCell app_details_btn_download]setEnabled:false];
    [[customCell  app_details_indecator_load] stopAnimating];

    if ([app_version doubleValue] < [app_versionOnServer doubleValue]  || ![self applicationIsDownloaded:app_name]) {
         [[customCell app_details_btn_download]setEnabled:true];
         [[customCell app_details_btn_download] setTag:indexPath.row];
    }

    return customCell;

    }


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    UIAlertController *deleteApp_alertController = [UIAlertController
                                                    alertControllerWithTitle:NSLocalizedString(@"Message", nil)
                                                    message:NSLocalizedString(@"Are you sure you want to Re-login again ? \r  NB : 'All unsynchronized calls will be deleted.'", nil)
                                                    preferredStyle:UIAlertControllerStyleActionSheet | UIAlertControllerStyleAlert] ;

    UIAlertAction *delete_Action = [UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Yes", @"will Delete ")
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction *action)
                                    {
                                        NSString *appName =[NSString stringWithFormat:@"%@" , [[[dictionaryOf_userApplications objectForKey:@"apps"] objectAtIndex:indexPath.row] objectForKey:@"name"]] ;


                                        [Download_Remove_Content removeApplication: appName];


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

-(void)didStartUpdate{}

-(void)didFinshUpdate:(NSString *)app_name{

    for (int i = 0 ; i < [[dictionaryOf_userApplications objectForKey:@"apps"] count] ; i++) {
       NSString *temp_appName =  [[[dictionaryOf_userApplications  objectForKey:@"apps"] objectAtIndex:i]objectForKey:@"name"];

        if ([[temp_appName lowercaseString] isEqualToString:[app_name lowercaseString]]) {

            NSDictionary *arr_newData =  @{ @"name"    : app_name ,
                                            @"appID"   : [[[dictionaryOf_userApplications  objectForKey:@"apps"] objectAtIndex:i]objectForKey:@"appID"],
                                            @"version" : [appDetailsOnServer objectForKey:[app_name localizedCapitalizedString]] ,
                                            };
            // remove old data
            [[dictionaryOf_userApplications  objectForKey:@"apps"] removeObjectAtIndex:i];
            [[dictionaryOf_userApplications  objectForKey:@"apps"] insertObject:arr_newData atIndex:i];
          break;
        }
    }
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dictionaryOf_userApplications options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    NSLog(@"%@",myString);

    [Read_WriteJSONFile writeStringWithData:myString fileName:@"AppsForUser"];
    [[self appDetail_TV] reloadData];

}


-(void)finshWithError {
    [[self appDetail_TV] reloadData];
}
@end
