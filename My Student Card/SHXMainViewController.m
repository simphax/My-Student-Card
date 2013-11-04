//
//  SHXViewController.m
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXMainViewController.h"
#import "SHXChalmersBProvider.h"

@interface SHXMainViewController ()
{
@private
    id<SHXIBalanceProvider> balanceProvider;
}

@end

@implementation SHXMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshData:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) refreshData:(id)sender
{
    [[self balanceLabel] setText:[NSString stringWithFormat:@"Loading..."]];
    
    balanceProvider = [[SHXChalmersBProvider alloc] initWithCardNumber:@"3819276125717221"];
    
    [balanceProvider getBalanceWithCompletionHandler:^(int result, NSError *error) {
        if(error)
        {
            [[self balanceLabel] setText:[NSString stringWithFormat:@"ERROR: %i",[error code]]];
        }
        else
        {
            [[self balanceLabel] setText:[NSString stringWithFormat:@"%i kr",result]];
        }
    }];
}

@end
