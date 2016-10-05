//
//  AppDetailCustomCell.m
//  Tacit App
//
//  Created by Yahia El-Dow on 10/3/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import "AppDetailCustomCell.h"
#import "AlertController.h"
#import "Read_WriteJSONFile.h"

@implementation AppDetailCustomCell

int numberOfDownload = 0 ;


- (IBAction)makeUpdate:(id)sender {

    [sender setHidden:true];
    [_app_details_indecator_load startAnimating] ;

    int index = [sender tag];
    NSMutableDictionary * dictionaryOf_userApplications  = [[NSMutableDictionary alloc]initWithDictionary:[Read_WriteJSONFile readJsonFileWithName:@"AppsForUser"]];
    NSString *app_name    = [[[dictionaryOf_userApplications objectForKey:@"apps"] objectAtIndex:index] objectForKey:@"name"];

    Download_Remove_Content  *downContent = [[Download_Remove_Content alloc] init];
    downContent.downloadDelegate = self ;
    [downContent _StartDownloadFromServer:app_name];


}


-(void)didStartDownloadContanet{
    numberOfDownload ++ ;
    [[self delegate]didStartUpdate];
}
-(void)didFinshDownloadContanet{

}
-(void)didFinshDownloadContanet:(NSString *)file_name{
        numberOfDownload -- ;
    if (numberOfDownload == 0) {
        [[self delegate] didFinshUpdate:file_name];
    }
    [_app_details_indecator_load stopAnimating] ;

}

-(void)didFinshDownloadContanetWithError{
[AlertController showAlertWithSingleButton:@"Cancel" presentOnViewController:self alertTitle:@"Info" alertMessage:@"Error to Download Files ... "];
    [[self delegate] finshWithError];
}



@end
