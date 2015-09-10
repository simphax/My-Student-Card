//
//  SHXViewController.m
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXMainViewController.h"
#import "SHXChalmersBProvider.h"
#import "SHXChalmersLProvider.h"
#import "SHXChalmersRestaurantDB.h"
#import "SHXLunchRow.h"
#import "SHXLunchRowViewController.h"
#import "NSString+NRStringFormatting.h"

@interface SHXMainViewController ()
{
@private
    id<SHXIBalanceProvider> balanceProvider;
    NSMutableArray *lunchProviders;
    NSMutableArray *lunchRows;
}

@end

@implementation SHXMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Read from settings
    //card number
    //favourite restaurant
    //current restaurant (selected)
    
    lunchProviders = [[NSMutableArray alloc] init];
    
    NSString *cardNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"cardNumber"];
    
    balanceProvider = [[SHXChalmersBProvider alloc] initWithCardNumber:cardNumber];
    
    [_cardNumberLabel setText:[cardNumber stringByFormattingAsCreditCardNumber]];
    [_cardOwnerLabel setText:@""];
    
    //Register for notification of when the application is resumed.
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationDidBecomeActive:)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    [self initPageController];
    
}

-(void) initPageController
{
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self lunchesView] bounds]];
    
    SHXLunchRowViewController *initialViewController = [self lunchRowAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self lunchesView] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.76 green:0 blue:0.32 alpha:0.5];
}

-(void) viewWillAppear:(BOOL)animated
{
    if(animated) { //This probably means we came from the settings view
        [self refreshData:self];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //If this is the first time using the app, go straight to setup
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"cardNumber"] == nil) {
        [self performSegueWithIdentifier:@"EditSegue" sender:self];
    } else {
        [self refreshData:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) refreshData:(id)sender
{
    //Show spinner
    [[self contentView] setHidden:YES];
    [[self refreshStatusView] setHidden:NO];
    
    
    //Fetch lunch providers
    
    [lunchProviders removeAllObjects];
    
    NSString *cardNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"cardNumber"];
    NSData *serializedSelectedRestaurants = [[NSUserDefaults standardUserDefaults] dataForKey:@"selectedRestaurants"];
    NSArray *selectedRestaurants;
    if(serializedSelectedRestaurants == nil) {
        selectedRestaurants = [[NSArray alloc] init];
    } else {
        selectedRestaurants = [SHXChalmersRestaurantDB unserializeRestaurants:serializedSelectedRestaurants];
    }
    
    for(SHXChalmersRestaurant *restaurant in selectedRestaurants) {
        id<SHXILunchProvider> lunchProvider = [[SHXChalmersLProvider alloc] initWithRestaurant:restaurant];
        
        [lunchProviders addObject:lunchProvider];
    }
    
    lunchRows = [[NSMutableArray alloc] init];
    
    int __block lunchProviderResults = 0;
    
    if([lunchProviders count] > 0) {
        for(id<SHXILunchProvider> lunchProvider in lunchProviders) {
            [lunchProvider getLunchesAt:[NSDate date] completionHandler:^(NSArray *lunchList, NSError *error) {
                
                [lunchRows addObjectsFromArray:lunchList];
                
                lunchProviderResults++;
                if(lunchProviderResults == [lunchProviders count]) {
                    
                    if([lunchRows count] > 0) {
                        
                        //Sort the lunches by restaurant name
                        [lunchRows sortUsingComparator: ^(id obj1, id obj2) {
                            return [[obj1 restaurant] compare:[obj2 restaurant]];
                        }];
                        
                        [[self noLunchLabel] setHidden: YES];
                        [[[self pageController] view] setHidden: NO];
                        
                        SHXLunchRowViewController *firstSpinnerViewController = [self lunchRowAtIndex:0];
                        NSArray *firstSpinnerViewControllerArray = [NSArray arrayWithObject:firstSpinnerViewController];
                        
                        [[self pageController] setViewControllers:firstSpinnerViewControllerArray direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                    } else {
                        //No lunches today
                        [[self noLunchLabel] setHidden:NO];
                        [[[self pageController] view] setHidden:YES];
                    }
                }
            }];
            
        }
    } else {
        //No lunch providers
        [[self noLunchLabel] setHidden:NO];
        [[[self pageController] view] setHidden:YES];
    }
    
    
    //Fetch balance
    
    balanceProvider = [[SHXChalmersBProvider alloc] initWithCardNumber:cardNumber];
    
    [balanceProvider getBalanceWithCompletionHandler:^(NSString *name, NSNumber *balance, NSError *error) {
        if(error)
        {
            //[[self balanceLabel] setText:[NSString stringWithFormat:@"ERROR: %i",[error code]]];
            NSLog(@"ERROR: %i",[error code]);
            [[self cardBalanceView] setHidden:YES];
            [[self cardErrorView] setHidden:NO];
        }
        else
        {
            [[self balanceLabel] setText:[NSString stringWithFormat:@"%i kr",[balance intValue]]];
            [[self cardBalanceView] setHidden:NO];
            [[self cardErrorView] setHidden:YES];
            
            [_cardNumberLabel setText:[cardNumber stringByFormattingAsCreditCardNumber]];
            [_cardOwnerLabel setText:name];
        }
        
        //TODO: Seperate spinners for balance and lunch
        [[self refreshStatusView] setHidden:YES];
        [[self contentView] setHidden:NO];
    }];

    
}

- (SHXLunchRowViewController *)lunchRowAtIndex:(NSUInteger)index {
    
    SHXLunchRowViewController *lunchRowView = [[SHXLunchRowViewController alloc] initWithNibName:@"SHXLunchRowViewController" bundle:nil];
    lunchRowView.pageIndex = index;
    
    if([lunchRows count] > index)
    {
        [lunchRowView setLunchRow:[lunchRows objectAtIndex:index]];
    }
    else
    {
        SHXLunchRow *lunchRow = [[SHXLunchRow alloc] init];
        [lunchRow setMeal:[NSString stringWithFormat:@"ERROR, index: %i",index]];
        [lunchRowView setLunchRow:lunchRow];
    }
    
    return lunchRowView;
}

#pragma mark UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SHXLunchRowViewController *)viewController pageIndex];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self lunchRowAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SHXLunchRowViewController *)viewController pageIndex];
    
    index++;
    
    if (index == [lunchRows count] || [lunchRows count] == 0) {
        return nil;
    }
    
    return [self lunchRowAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    if([lunchRows count] > 0)
    {
        return [lunchRows count];
    }
    else
    {
        return 1;
    }
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
