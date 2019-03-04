//
//  AppDetailCustomCell.h
//  Tacit App
//
//  Created by Yahia El-Dow on 10/3/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Download_Remove_Content.h"



@protocol AppDetailsDelegate <NSObject>
-(void)didStartUpdate ;
-(void)didFinshUpdate :(NSString *) app_name ;
-(void)finshWithError ;

@end


@interface AppDetailCustomCell : UITableViewCell <_DownloadContentDelegate>

@property (strong,nonatomic) id<AppDetailsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *app_details_img_icon;
@property (weak, nonatomic) IBOutlet UILabel *app_details_lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *app_details_lbl_currentVersion;
@property (weak, nonatomic) IBOutlet UILabel *app_details_lbl_versionOnServer;
@property (weak, nonatomic) IBOutlet UIButton *app_details_btn_download;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *app_details_indecator_load;



@end
