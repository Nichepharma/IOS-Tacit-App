//
//  DownloadContent.m
//  Career Management Apps
//
//  Created by Yahia on 3/10/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import "Download_Remove_Content.h"

#define SERVER_LINK_DONLOAD @"http://www.tacitapp.com/Yahia/tacitapp/"

@implementation Download_Remove_Content

-(void)_StartDownloadFromServer :(NSString *)fileName{
    
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    dispatch_queue_t main = dispatch_get_main_queue();
    dispatch_async(q, ^{
        //Path info
        NSLog(@"Starting Download...... %@",fileName) ;
   
        [self.downloadDelegate didStartDownloadContanet];
        NSString *stringURL = [NSString stringWithFormat:@"%@%@.zip",SERVER_LINK_DONLOAD,fileName];
        NSLog(@"Starting Download...... %@",stringURL) ;
        NSURL *url = [NSURL URLWithString:stringURL];
        NSData *data = [NSData  dataWithContentsOfURL:url];
        NSString *fileName = [[url path] lastPathComponent];
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [data writeToFile:filePath atomically:YES];
        dispatch_async(main, ^ {
            //Write To
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",[fileName substringToIndex:[fileName length]-4] ]];
            [SSZipArchive unzipFileAtPath:filePath toDestination:dataPath delegate:self];
             NSLog(@"Finish ....... %@",[fileName substringToIndex:fileName.length - 4]);


                [[self downloadDelegate] didFinshDownloadContanet:[fileName substringToIndex:fileName.length - 4]] ;


            if (![Download_Remove_Content checkExistFileWithFileName:[fileName substringToIndex:fileName.length - 4]]) {
                [self.downloadDelegate didFinshDownloadContanetWithError];
            }
                   });
});
    

}






-(void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath{

    //didFinshDownloadContanet
    [self.downloadDelegate didFinshDownloadContanet];
}




+(BOOL)removeApplication:(NSString *)str_ApplicationNameWillRemove{
    //    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
    //    int tag = recognizer.view.tag;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@",documentsPath);
    NSString *filePath = [documentsPath stringByAppendingPathComponent:str_ApplicationNameWillRemove];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"delete file ");
        return true ;
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        return false ;
    }
    
}



+(BOOL)checkExistFileWithFileName :(NSString *)str_FileName{
   NSString *documentsPath = [[NSString alloc] init] ;
    @try {
        documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* foofile = [documentsPath stringByAppendingPathComponent:str_FileName];
        return  [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    }@catch (NSException *exception) {
        return false ;
    }
    
}






/*
-(void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo{
//    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>");
}

-(void)zipArchiveDidUnzipArchiveFile:(NSString *)zipFile entryPath:(NSString *)entryPath destPath:(NSString *)destPath{
      NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>> 2");
}
-(void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath unzippedFilePath:(NSString *)unzippedFilePath{
      NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>> 3");
}-(void)zipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total{
      NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>> 4");
}-(BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo{
          NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>> 5");
    return true ;
}-(void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo{
      NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>> 6");
}-(void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo{
      NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>> 7 ");
}*/


@end
