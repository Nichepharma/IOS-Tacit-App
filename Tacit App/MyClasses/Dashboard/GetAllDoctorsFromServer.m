//
//  GetAllDoctorsFromServer.m
//  DashboardSQL
//
//  Created by Yahia on 2/18/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//

#import "GetAllDoctorsFromServer.h"

#define TABUK_URL     @"http://tacitapp.com/tabuk/jsonFiles/"
#define CHIESI_URL    @"http://tacitapp.com/tabuk/jsonFiles/"
#define DERMAZONE_URL @"http://tacitapp.com/tabuk/jsonFiles/"

#define FUNCTION_NAME @"getRepDoctors"

static GetAllDoctorsFromServer *sharedInstance = nil ;

@implementation GetAllDoctorsFromServer


+(GetAllDoctorsFromServer*)get_Doc{
    
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance callSoapFunction];
    
    }
    return sharedInstance;
}



-(void)callSoapFunction{
    
    //first Call Function in php file on server
//    
    //first Call Function in php file on server
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com/m"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data) {

        int company_id = 0 ;
        if ([[[DBManager getSharedInstance] getUserCompany] isEqualToString:@"tabuk"]) {
            company_id  = 1 ;
        }else if ([[[DBManager getSharedInstance] getUserCompany] isEqualToString:@"chiesi"]){
            company_id = 2 ;
        }else if ([[[DBManager getSharedInstance] getUserCompany] isEqualToString:@"dermazon"]){
            company_id = 3 ;
        }
        
        SoapRequest *soapR = [[SoapRequest alloc] initWithFunction:FUNCTION_NAME company_id:company_id];
        soapR.delegate=self;
        NSDictionary *par = @{@"username":[[DBManager getSharedInstance] getUsername]};
        [soapR sendRequestWithAttributes:par];
        
    }

}


-(void) SoapRequest:(id)Request didFinishWithData:(NSMutableDictionary *)dict
{
    [sharedInstance setDocInDB];
//    SoapRequest *s = Request;
//    NSLog(@"error >>>> %@",s);
}

-(void)setDocInDB{
    NSMutableArray *login_docID ,*login_docName ,*login_docSpec ;
    login_docID =[[NSMutableArray alloc] init];
    login_docName =[[NSMutableArray alloc] init];
    login_docSpec =[[NSMutableArray alloc] init];
    for (NSDictionary *d in [self callDoctors]){
        [login_docID addObject:d[@"did"]];
        [login_docName addObject:d[@"FullName"]] ;
        [login_docSpec addObject:d[@"speciality"]] ;
        
    }
    for (int i =0; i<[login_docID count]; i++) {
        [[DBManager getSharedInstance]saveData:[login_docID objectAtIndex:i] name:[login_docName objectAtIndex:i]  spec:[login_docSpec objectAtIndex:i] ];
        
    }
    
    
}

-(NSMutableArray *)callDoctors {
           // then get json file from server
    NSMutableArray *arr_Doc ;
    NSString * urlString_name = [NSString stringWithFormat:@"%@%@.json",TABUK_URL,[[DBManager getSharedInstance] getUsername]];
    NSURL * url_name = [NSURL URLWithString:urlString_name];
    NSData * data_name = [NSData dataWithContentsOfURL:url_name];
    NSError * error_name;
    arr_Doc = [NSJSONSerialization JSONObjectWithData:data_name options:kNilOptions error:&error_name];
  
    
    return arr_Doc ;

}



    
-(void)SoapRequest:(id)Request didFinishWithError:(int)ErrorCode{
    SoapRequest *s = Request;
    NSLog(@"error %@",s);
}


@end
