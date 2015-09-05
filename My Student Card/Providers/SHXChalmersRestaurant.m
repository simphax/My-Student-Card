//
//  SHXChalmersRestaurant.m
//  My Student Card
//
//  Created by Simon Nilsson on 2013-11-21.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXChalmersRestaurant.h"

@implementation SHXChalmersRestaurant

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:_name forKey:@"_name"];
    [coder encodeObject:_feedUrl forKey:@"_feedUrl"];
}

- (id)initWithCoder:(NSCoder *)coder {
    
    _name = [coder decodeObjectForKey:@"_name"];
    _feedUrl = [coder decodeObjectForKey:@"_feedUrl"];
    
    return self;
}

@end
