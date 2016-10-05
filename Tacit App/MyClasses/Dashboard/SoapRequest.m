//

//  DashboardSQL
//
//  Created by Yahia on 2/18/15.
//  Copyright (c) 2015 nichepharma. All rights reserved.
//
#import "SoapRequest.h"
#import "DBManager.h"
@implementation SoapRequest
NSString *soap_str_Company , *soap_str_fileConnect ;
-(id) initWithFunction:(NSString*) fun company_id :(int) company_id
{
    //NSLog(@"%s",__FUNCTION__);
    self=[super init];
    
    if (self)
    {
        _function=fun;
        _att=@"";
        _dict=[[NSMutableDictionary alloc] init];
        _Keys=[[NSMutableArray alloc] init];
        _values=[[NSMutableArray alloc] init];
        _Dicts=[[NSMutableArray alloc]init];
        
      
            switch (company_id) {
                case 1:
                    soap_str_Company = @"tabuk";
                    soap_str_fileConnect =@"dataLink3.php";
                    break;
                case 2:
                    soap_str_Company = @"chiesi";
                    soap_str_fileConnect =@"dataLink.php";
                    break ;
                case 3:
                    soap_str_Company = @"dermazon";
                    soap_str_fileConnect =@"dataLink.php";
                    break ;
                default:
                    break;
            }
        
    }
    return self;
}

-(void) sendRequestWithAttributes:(NSDictionary*) dict
{
    
    NSString *conds = @"";

    if (dict != Nil && [_function isEqualToString: @"SyncSession"])
    {
        NSArray *keys = [NSArray arrayWithObjects:
                             @"doctorNotice"
                         ,   @"doctorLoc"
                         ,   @"username"
                         ,   @"callObjection"
                         ,   @"callRemarks"
                         ,   @"nextVisit"
                         ,   @"last_mod"
                         ,   @"did"
                         ,   @"samplesDroped"
                         ,   @"pid"
                         ,   @"acc_time"
                         ,   @"due"
                         ,   @"callInquiry",nil];
        
        
        for (int x = 0; x<keys.count; x++) {
            conds= [ conds stringByAppendingFormat:@"<%@>%@</%@>",[keys objectAtIndex:x],[dict valueForKey:[keys objectAtIndex:x]],[keys objectAtIndex:x] ] ;
        }

        
    }
    else if (dict != Nil)
    {
        for (NSString *key in [dict allKeys]) {
            conds= [ conds stringByAppendingFormat:@"<%@>%@</%@>",key,[dict valueForKey:key],key ] ;
        }
    }
    
    
	NSString *soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><%@ xmlns=\"http://www.tacitapp.com/%@/\">%@</%@></soap:Body></soap:Envelope>",_function,soap_str_Company,conds,_function];
   NSLog(@"%@",soapMsg);
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.tacitapp.com/%@/%@",soap_str_Company,soap_str_fileConnect]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:[NSString stringWithFormat:@"http://www.tacitapp.com/%@/%@/%@",soap_str_Company,[soap_str_fileConnect substringToIndex:soap_str_fileConnect.length - 4],_function]forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _connect = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode>400){
        NSLog(@"statusConde : %ld" , (long)httpResponse.statusCode);
        UIAlertView *alertConnection = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"We are sorry , there was some error while connecting to server, data will not be updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertConnection show];
    }
    
   //NSLog(@" connect respond %@", httpResponse);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSXMLParser *parser = [[NSXMLParser alloc]  initWithData:data];
	[parser setDelegate:self];
    [parser parse];
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    [_delegate SoapRequest:self didFinishWithData:_dict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if (![elementName isEqualToString:@"item"]){
        [_Keys addObject:elementName];
        [_values addObject:_att];
    }
    else{
        _dict = [NSMutableDictionary dictionaryWithObjects:_values forKeys:_Keys];
        [_Dicts addObject:_dict];
    }
    _add=NO;
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    // accumulatingParsedCharacterData = NO;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    _add=YES;
    _att=@"";
}
// The parser delivers parsed character data (PCDATA) in chunks, not necessarily all at once.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_add){
        _att=[_att stringByAppendingString:string];
    }
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    [_delegate SoapRequest:self didFinishWithError:parseError.code];
    NSLog(@"Error: %@", [parseError localizedDescription]);
}
@end
