//
//  SHXChalmersRestaurantDB.m
//  My Student Card
//
//  Created by Simon Nilsson on 2013-11-21.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXChalmersRestaurantDB.h"

#import "SHXChalmersLocation.h"
#import "SHXChalmersRestaurant.h"

@interface SHXChalmersRestaurantDB ()
{
@private
    NSDictionary *restaurantsDictionary;
}
@end

@implementation SHXChalmersRestaurantDB

-(id)init
{
    self = [super init];
    restaurantsDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ChalmersRestaurants" ofType:@"plist"]];
    return self;
}

- (NSArray*)getLocations
{
    NSMutableArray *allLocations = [[NSMutableArray alloc] init];
    
    NSArray *locations = [restaurantsDictionary objectForKey:@"Locations"];
    for(NSDictionary *locationD in locations)
    {
        SHXChalmersLocation *location = [[SHXChalmersLocation alloc] init];
        NSString *locationName = [locationD objectForKey:@"Title"];
        [location setName:locationName];
        
        NSMutableArray *allRestaurants = [[NSMutableArray alloc] init];
        
        NSArray *restaurants = [locationD objectForKey:@"Restaurants"];
        for(NSDictionary *restaurantD in restaurants)
        {
            SHXChalmersRestaurant *restaurant = [[SHXChalmersRestaurant alloc] init];
            
            NSString *restaurantName = [restaurantD objectForKey:@"Name"];
            [restaurant setName:restaurantName];
            
            NSString *restaurantFeed = [restaurantD objectForKey:@"Feed"];
            [restaurant setFeedUrl:restaurantFeed];
            
            [allRestaurants addObject:restaurant];
        }
        
        [location setRestaurants:allRestaurants];
        
        [allLocations addObject:location];
    }
    
    return allLocations;
}

@end
