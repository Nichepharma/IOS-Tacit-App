//
//  PDFViewer.m
//  Career Management Apps
//
//  Created by Yahia on 3/27/16.
//  Copyright © 2016 nichepharma.com. All rights reserved.
//

#import "PDFViewer.h"

@implementation PDFViewer


UIWebView *webView_pdf ;
+(UIWebView *)openPDF_withName : (NSString *)strPath_name{
    
    webView_pdf = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    webView_pdf.scalesPageToFit = YES;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:strPath_name];
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView_pdf loadRequest:request];
    
 return webView_pdf;
}


@end
