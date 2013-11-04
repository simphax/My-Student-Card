//
//  SHXChalmersBProviderTest.m
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXChalmersBProviderTest.h"
#import "SHXChalmersBProvider.h"

@interface SHXChalmersBProviderTest (){
    SHXChalmersBProvider *provider;
}

@end

@implementation SHXChalmersBProviderTest

- (void)setUp
{
    [super setUp];
    provider = [[SHXChalmersBProvider alloc] initWithCardNumber:@"3819276125717221"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetBalance
{
    //We need something that waits for the asynchronus result.
    [provider getBalanceWithCompletionHandler:^(int result) {
        NSLog(@"Balance: %i",result);
    }];
}

@end
