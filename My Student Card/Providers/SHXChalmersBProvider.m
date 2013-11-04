//
//  SHXChalmersBProvider.m
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXChalmersBProvider.h"
#import "GDataXMLNode.h"

@interface SHXChalmersBProvider() <NSURLConnectionDataDelegate>
{
@private
    NSString *cardNumber;
}
@end

@implementation SHXChalmersBProvider

-(id) initWithCardNumber:(NSString *)number
{
    self = [super init];
    
    cardNumber = number;
    
    return self;
}

-(void)getBalanceWithCompletionHandler:(void(^)(int balance, NSError *error))handler
{
    NSString *urlString = [NSString stringWithFormat:@"http://kortladdning.chalmerskonferens.se/bgw.aspx?type=getCardAndArticles&card=%@",cardNumber];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:3.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               int theBalance = -1;
                               
                               if(!error)
                               {
                                   GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data
                                                                                          options:0 error:&error];
                                   if(!error)
                                   {
                                       NSArray *balanceXmlSearch = [doc nodesForXPath:@"//ExtendedInfos/ExtendedInfo[@Name=\"Kortvarde\"]" error:&error];
                                       
                                       if([balanceXmlSearch count] > 0)
                                       {
                                           GDataXMLNode *balanceXmlObj = [balanceXmlSearch objectAtIndex:0];
                                           NSString *stringValue =[balanceXmlObj stringValue];
                                           
                                           //Not really sure if this will hold in all situations. The xml value is something like _x0035_00 if the balance is 500.
                                           stringValue = [stringValue substringWithRange:NSMakeRange(5, [stringValue length]-5)];
                                           stringValue = [stringValue stringByReplacingOccurrencesOfString:@"_" withString:@""];
                                           
                                           int intValue = [stringValue intValue];
                                           
                                           if(intValue != INT_MAX || intValue != INT_MIN) //Overflow
                                           {
                                               theBalance = intValue; //Success!
                                           }
                                           
                                       }
                                   }
                               }
                               
                               if(theBalance == -1 && !error)
                               {
                                   NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:@"Could not get balance. Unknown reason."
                                                                           forKey:@"error"];
                                   error = [[NSError alloc] initWithDomain:@"com.simphax.MyStudentCard" code:1001 userInfo:errorInfo];
                               }
                               
                               handler(theBalance, error);
                           }];
}

@end
