//
//  DownloadContent.h
//  Career Management Apps
//
//  Created by Yahia on 3/10/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSZipArchive.h"

@protocol _DownloadContentDelegate
@required
//! when start Download file
-(void)didStartDownloadContanet ;
//! when dowload file without error
-(void)didFinshDownloadContanet ;
//! when dowload file with error
//! if no file in server 
-(void)didFinshDownloadContanetWithError ;

@optional
-(void)didFinshDownloadContanet:(NSString *)file_name ;

@end



@interface Download_Remove_Content : NSObject <SSZipArchiveDelegate , NSURLConnectionDelegate>

-(void)_StartDownloadFromServer :(NSString *)fileName ;
@property (nonatomic, weak)id<_DownloadContentDelegate> downloadDelegate ;
+(BOOL)removeApplication:(NSString *)str_ApplicationNameWillRemove;

+(BOOL)checkExistFileWithFileName :(NSString *)str_FileName ;



@end
