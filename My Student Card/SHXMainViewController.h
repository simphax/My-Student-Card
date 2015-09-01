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
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardOwnerLabel;

@property IBOutlet UIView *lunchesView;

@property (weak, nonatomic) IBOutlet UIView *cardBalanceView;
@property (weak, nonatomic) IBOutlet UIView *cardErrorView;

@end
