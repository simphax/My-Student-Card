//
//  SHXLunchRowViewController.m
//  My Student Card
//
//  Created by Simon on 2013-11-05.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXLunchRowViewController.h"

@interface SHXLunchRowViewController ()

@end

@implementation SHXLunchRowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self mealLabel] setText:[[self lunchRow] meal]];
    [[self typeLabel] setText:[[[self lunchRow] type] uppercaseString]];
    [[self restaurantLabel] setText:[[[self lunchRow] restaurant] uppercaseString]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
