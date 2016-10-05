//
//  Read_WriteJSONFile.m
//  Career Management Apps
//
//  Created by Yahia on 3/13/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import "Read_WriteJSONFile.h"

@implementation Read_WriteJSONFile



+(NSDictionary*)readJsonfromServer :(NSString *)json_url{
    NSDictionary *jsonData ;
    NSURL * url_name = [NSURL URLWithString:json_url];
    NSData * data_name = [NSData dataWithContentsOfURL:url_name];
    NSError * error_name;
    jsonData = [NSJSONSerialization JSONObjectWithData:data_name options:kNilOptions error:&error_name];
    return jsonData ;
}



+ (NSMutableDictionary*)readStringFromFileFromApplicationName :(NSString *)str_AppName  {


    // Build the path...
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@/bookmark.json",str_AppName];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    // get json as String
    //[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding]
    #pragma get Json As Array
    NSError *err = nil;
    NSMutableDictionary *arr_contenerData =
    [NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
   return arr_contenerData;


    // then get json file from server
/*
    NSString * urlString_name = [NSString stringWithFormat:@"http://tacitapp.com/Yahia/jsonFileFinalAPP/bookmark.json"];
    // then get json file from server
    NSMutableDictionary *arr_Doc ;
    NSURL * url_name = [NSURL URLWithString:urlString_name];
    NSData * data_name = [NSData dataWithContentsOfURL:url_name];
    NSError * error_name;
    arr_Doc = [NSJSONSerialization JSONObjectWithData:data_name options:kNilOptions error:&error_name];
    return arr_Doc;
    */
    
}



+ (NSMutableDictionary*)readJsonFileWithName :(NSString *)str_FileName  {
    
    // Build the path...
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@.json",str_FileName];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    // get json as String
    //[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding]
    #pragma get Json As Array
    NSError *err = nil;
    NSMutableDictionary *arr_contenerData =
    [NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&err];
    
    // NSLog(@"Array = %@",arr_contenerData);
    return arr_contenerData;
    
    
}


+(void)writeStringWithData:(NSString*)_Value  fileName :(NSString *)str_JsonFileName {

    // Build the path, and create if needed.
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",str_JsonFileName]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }

    // The main act...
    [[_Value dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}

@end
