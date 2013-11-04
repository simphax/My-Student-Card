//
//  SHXChalmersBProviderTest.m
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXChalmersBProviderTest.h"
#import "SHXChalmersBProvider.h"

@interface SHXChalmersBProviderTest () {
    SHXChalmersBProvider *provider;
}

@end

@implementation SHXChalmersBProviderTest

- (void)setUp
{
    [super setUp];
    provider = [[SHXChalmersBProvider alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetBalance
{
    int balance = [provider getBalance];
    
    NSLog(@"Balance is: %i",balance);
}

@end
