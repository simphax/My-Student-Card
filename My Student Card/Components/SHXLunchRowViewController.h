//
//  SHXLunchRowViewController.h
//  My Student Card
//
//  Created by Simon on 2013-11-05.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHXLunchRow.h"

@interface SHXLunchRowViewController : UIViewController

@property SHXLunchRow *lunchRow;

@property (weak, nonatomic) IBOutlet UILabel *mealLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLabel;

@property NSInteger pageIndex;

@end
