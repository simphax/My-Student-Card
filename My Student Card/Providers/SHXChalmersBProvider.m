//
//  SHXChalmersBProvider.m
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXChalmersBProvider.h"
#import "NSString+URLEncode.h"

#define VIEWSTATE_REGEX @"__VIEWSTATE\"\\s+value=\"([^\"]+)\""
#define EVENTVALIDATION_REGEX @"__EVENTVALIDATION\"\\s+value=\"([^\"]+)\""
#define CARDNAME_REGEX @"<span id=\"txtPTMCardName\">(.*?)</span>"
#define BALANCE_REGEX @"<span id=\"txtPTMCardValue\">(.*?)</span>"

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

-(void)postData:(void(^)(NSString *postString, NSError *error))handler
{
    NSString *urlString = @"http://kortladdning3.chalmerskonferens.se/Default.aspx";
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error) return handler(nil,error);
                               
                               NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            
                               NSMutableString *postString = [[NSMutableString alloc] init];
                               
                               //Find __VIEWSTATE
                               NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:VIEWSTATE_REGEX options:0 error:&error];
                               
                               NSTextCheckingResult *match = [regex firstMatchInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length])];
                               
                               
                               [postString appendString:@"__VIEWSTATE="];
                               [postString appendString:[[htmlStr substringWithRange:[match rangeAtIndex:1]] urlEncodedString]];
                               
                               //Find __EVENTVALIDATION
                               
                               regex = [NSRegularExpression regularExpressionWithPattern:EVENTVALIDATION_REGEX options:0 error:&error];
                               
                               match = [regex firstMatchInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length])];
                               
                               
                               [postString appendString:@"&__EVENTVALIDATION="];
                               [postString appendString:[[htmlStr substringWithRange:[match rangeAtIndex:1]] urlEncodedString]];
                               
                               
                               //Add card number and additional variables
                               [postString appendString:@"&txtCardNumber="];
                               [postString appendString:cardNumber];
                               
                               [postString appendString:@"&btnNext="];
                               [postString appendString:[@"Nästa" urlEncodedString]];
                               
                               [postString appendString:@"&hiddenIsMobile="];
                               [postString appendString:@"desktop"];
                               
                               
                               handler(postString,nil);
                           }
     ];
}

-(void)login:(void(^)(NSError *error))handler
{
    [self postData: ^(NSString *postString, NSError *error) {
        if(error) return handler(error);
        
        NSString *urlString = @"http://kortladdning3.chalmerskonferens.se/Default.aspx";
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   if(error) return handler(error);
                                   return handler(nil);
                               }
         ];
    }];
    
}

-(void)getBalanceWithCompletionHandler:(void(^)(NSString *name, NSNumber *balance, NSError *error))handler
{
    if(!cardNumber) return handler(nil, nil, [[NSError alloc] initWithDomain:@"com.simphax.MyStudentCard" code:2003 userInfo:nil]);
    [self login:^(NSError *error) {
        if(error) return handler(nil, nil, [[NSError alloc] initWithDomain:@"com.simphax.MyStudentCard" code:2004 userInfo:nil]);
        
        NSString *urlString = @"http://kortladdning3.chalmerskonferens.se/CardLoad_Order.aspx";
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:10.0];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if(error) return handler(nil, nil, [[NSError alloc] initWithDomain:@"com.simphax.MyStudentCard" code:2005 userInfo:nil]);
                                   
                                   NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                   //Find card name
                                   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:CARDNAME_REGEX options:0 error:&error];
                                   NSTextCheckingResult *match = [regex firstMatchInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length])];
                                   if(match == nil) return handler(nil,nil,[[NSError alloc] initWithDomain:@"com.simphax.MyStudentCard" code:2001 userInfo:nil]);
                                   
                                   NSString *name = [htmlStr substringWithRange:[match rangeAtIndex:1]];
                                   NSLog(@"Name: %@",name);
                                   
                                   //Find card balance
                                   regex = [NSRegularExpression regularExpressionWithPattern:BALANCE_REGEX options:0 error:&error];
                                   match = [regex firstMatchInString:htmlStr options:0 range:NSMakeRange(0, [htmlStr length])];
                                   if(match == nil) return handler(nil,nil,[[NSError alloc] initWithDomain:@"com.simphax.MyStudentCard" code:2002 userInfo:nil]);
                                   
                                   NSNumber *balance = [NSNumber numberWithFloat:[[htmlStr substringWithRange:[match rangeAtIndex:1]] floatValue]];
                                   NSLog(@"Balance: %@",balance);
                                   
                                   return handler(name, balance, nil);
                               }
         ];
        
    }];
}

@end
     
     
     

