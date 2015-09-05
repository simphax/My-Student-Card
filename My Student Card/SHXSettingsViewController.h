//
//  SHXSettingsViewController.h
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHXSettingsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

- (IBAction) dismissModal:(id)sender;

@property IBOutlet UITableView *tableView;
@property IBOutlet UITextField *cardNumberTextField;

@end
