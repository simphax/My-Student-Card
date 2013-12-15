//
//  SHXSettingsViewController.m
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXAutoFormatTextFieldDelegate.h"
#import "SHXSettingsViewController.h"

@interface SHXSettingsViewController ()
{
@private
    SHXAutoFormatTextFieldDelegate *textFieldDelegate;
}

@end

@implementation SHXSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textFieldDelegate = [[SHXAutoFormatTextFieldDelegate alloc] init];
    _cardNumberTextField.delegate = textFieldDelegate;
    
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
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
    
    cell.textLabel.text = @"Linsen";
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Johanneberg";
}

- (IBAction) dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissKeyboard {
    [_cardNumberTextField resignFirstResponder];
}

@end
