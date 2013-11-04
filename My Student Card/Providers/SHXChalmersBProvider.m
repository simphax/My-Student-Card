//
//  SHXChalmersBProvider.m
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXChalmersBProvider.h"

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

-(void)getBalanceWithCompletionHandler:(void(^)(int))handler
{
    NSString *urlString = [NSString stringWithFormat:@"http://kortladdning.chalmerskonferens.se/bgw.aspx?type=getCardAndArticles&card=%@",cardNumber];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:3.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSLog(@"Response: %@",response);
                               NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"Data: %@",datastr);
                               handler(250);
                           }];
}

@end
