//
//  Read_WriteJSONFile.h
//  Career Management Apps
//
//  Created by Yahia on 3/13/16.
//  Copyright © 2016 Nichepharma.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Read_WriteJSONFile : NSObject

+ (NSMutableDictionary*)readStringFromFileFromApplicationName :(NSString *)str_AppName ;
+ (NSMutableDictionary*)readJsonFileWithName :(NSString *)str_FileName ;
+(void)writeStringWithData:(NSString*)_Value  fileName :(NSString *)str_JsonFileName ;
+(NSDictionary*)readJsonfromServer :(NSString *)json_url ;
@end
