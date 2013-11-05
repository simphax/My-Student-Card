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
#import "SHXLunchRow.h"
#import "SHXLunchRowViewController.h"

@interface SHXMainViewController ()
{
@private
    id<SHXIBalanceProvider> balanceProvider;
    id<SHXILunchProvider> lunchProvider;
    NSArray *lunchRows;
}

@end

@implementation SHXMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    balanceProvider = [[SHXChalmersBProvider alloc] initWithCardNumber:@"3819276125717221"];
    lunchProvider = [[SHXChalmersLProvider alloc] init];
    
    [self initPageController];
    
    [self refreshData:self];
    
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
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) refreshData:(id)sender
{
    [[self contentView] setHidden:YES];
    [[self refreshStatusView] setHidden:NO];
    
    [balanceProvider getBalanceWithCompletionHandler:^(int result, NSError *error) {
        if(error)
        {
            [[self balanceLabel] setText:[NSString stringWithFormat:@"ERROR: %i",[error code]]];
        }
        else
        {
            [[self balanceLabel] setText:[NSString stringWithFormat:@"%i kr",result]];
            
            [[self refreshStatusView] setHidden:YES];
            [[self contentView] setHidden:NO];
        }
    }];
    
    [lunchProvider getLunchListWithCompletionHandler:^(NSArray *lunchList, NSError *error) {
        
        lunchRows = lunchList;
        
        for(SHXLunchRow *row in lunchList)
        {
            NSLog(@"%@",[row meal]);
        }
        
        SHXLunchRowViewController *initialViewController = [self lunchRowAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [[self pageController] setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
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
    
    if (index == [lunchRows count]) {
        return nil;
    }
    
    return [self lunchRowAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return [lunchRows count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
