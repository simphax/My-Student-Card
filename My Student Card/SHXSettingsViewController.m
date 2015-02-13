//
//  SHXSettingsViewController.m
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//


#import "SHXSettingsViewController.h"

#import "SHXAutoFormatTextFieldDelegate.h"
#import "SHXChalmersRestaurantDB.h"
#import "SHXChalmersLocation.h"
#import "SHXChalmersRestaurant.h"

#import "NSString+NRStringFormatting.h"

@interface SHXSettingsViewController ()
{
@private
    SHXAutoFormatTextFieldDelegate *textFieldDelegate;
    NSArray *restaurantLocations;
}

@end

@implementation SHXSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Might want to make this general (not only for chalmers)
    SHXChalmersRestaurantDB *restaurantsDB = [[SHXChalmersRestaurantDB alloc] init];
    restaurantLocations = [restaurantsDB getLocations];
    
    textFieldDelegate = [[SHXAutoFormatTextFieldDelegate alloc] init];
    _cardNumberTextField.delegate = textFieldDelegate;
    
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    NSString *cardNumber = [[[NSUserDefaults standardUserDefaults] stringForKey:@"cardNumber"] stringByFormattingAsCreditCardNumber];
    [_cardNumberTextField setText:cardNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RestaurantCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.textLabel.text = [[[[restaurantLocations objectAtIndex:[indexPath section]] restaurants] objectAtIndex:[indexPath row]] name];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [restaurantLocations count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[restaurantLocations objectAtIndex:section] restaurants] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[restaurantLocations objectAtIndex:section] name];
}

- (IBAction) dismissModal:(id)sender
{
    //Save settings
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //Strip away spaces
    NSString* cardNumberString = [[self.cardNumberTextField text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [userDefaults setObject:cardNumberString
                     forKey:@"cardNumber"];
    [userDefaults synchronize];
    
    //Reload main view...
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissKeyboard {
    [_cardNumberTextField resignFirstResponder];
}

@end
