//
//  SHXViewController.h
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHXMainViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction) refreshData:(id)sender;

@property UIPageViewController *pageController;

@property IBOutlet UILabel *balanceLabel;
@property IBOutlet UIView *contentView;
@property IBOutlet UIView *refreshStatusView;

@property IBOutlet UIView *lunchesView;

@end
