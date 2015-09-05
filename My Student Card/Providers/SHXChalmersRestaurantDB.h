//
//  SHXChalmersRestaurantDB.h
//  My Student Card
//
//  Created by Simon Nilsson on 2013-11-21.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHXChalmersRestaurantDB : NSObject

- (NSArray*)getLocations;
+ (NSData*)serializeRestaurants:(NSArray*)restaurantsArray;
+ (NSArray*)unserializeRestaurants:(NSData*)serializedRestaurants;

@end
