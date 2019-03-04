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

    if (numberOfDownload > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"please wait Product finishing the Download"
                                                       delegate:self
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:nil , nil];
        [alert show];
    }else{
    [sender setHidden:true];
    [_app_details_indecator_load startAnimating] ;

    int index = (int)[sender tag];
    NSMutableDictionary * dictionaryOf_userApplications  = [[NSMutableDictionary alloc]initWithDictionary:[Read_WriteJSONFile readJsonFileWithName:@"AppsForUser"]];
    NSString *app_name    = [[NSString alloc] initWithFormat:@"%@",[[[dictionaryOf_userApplications objectForKey:@"product"] objectAtIndex:index] objectForKey:@"pName"]];
    [Download_Remove_Content removeApplication: app_name];

    Download_Remove_Content  *downContent = [[Download_Remove_Content alloc] init];
    downContent.downloadDelegate = self ;
    [downContent _StartDownloadFromServer:app_name];

    }
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
    [[self delegate] finshWithError];
}



@end
