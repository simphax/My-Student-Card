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
    NSMutableSet *selectedRestaurants;
    SHXChalmersRestaurantDB *restaurantsDB;
}

@end

@implementation SHXSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedRestaurants = [[NSMutableSet alloc] init];
    
    //Might want to make this general (not only for chalmers)
    restaurantsDB = [[SHXChalmersRestaurantDB alloc] init];
    restaurantLocations = [restaurantsDB getLocations];
    
    textFieldDelegate = [[SHXAutoFormatTextFieldDelegate alloc] init];
    _cardNumberTextField.delegate = textFieldDelegate;
    
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    tap.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tap];
    
    NSString *cardNumber = [[[NSUserDefaults standardUserDefaults] stringForKey:@"cardNumber"] stringByFormattingAsCreditCardNumber];
    [_cardNumberTextField setText:cardNumber];
    
    
    NSData *serializedSelectedRestaurants = [[NSUserDefaults standardUserDefaults] dataForKey:@"selectedRestaurants"];
    if(serializedSelectedRestaurants) {
        [selectedRestaurants addObjectsFromArray:[SHXChalmersRestaurantDB unserializeRestaurants:serializedSelectedRestaurants]];
    }
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    SHXChalmersRestaurant *restaurant = [[[restaurantLocations objectAtIndex:[indexPath section]] restaurants] objectAtIndex:[indexPath row]];
    
    if([selectedRestaurants containsObject:restaurant]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text = [restaurant name];
    
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

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    SHXChalmersRestaurant *restaurant = [[[restaurantLocations objectAtIndex:[indexPath section]] restaurants] objectAtIndex:[indexPath row]];
    
    [selectedRestaurants addObject:restaurant];
    //NSLog(@"didSelectRowAtIndexPath");
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    
    SHXChalmersRestaurant *restaurant = [[[restaurantLocations objectAtIndex:[indexPath section]] restaurants] objectAtIndex:[indexPath row]];
    
    [selectedRestaurants removeObject:restaurant];
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction) dismissModal:(id)sender
{
    //Save settings
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //Strip away spaces
    NSString* cardNumberString = [[self.cardNumberTextField text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [userDefaults setObject:cardNumberString
                     forKey:@"cardNumber"];
    [userDefaults setObject: [SHXChalmersRestaurantDB serializeRestaurants:selectedRestaurants]
                     forKey:@"selectedRestaurants"];
    [userDefaults synchronize];
    
    //Reload main view...
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissKeyboard {
    [_cardNumberTextField resignFirstResponder];
}

@end
