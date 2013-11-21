//
//  SHXChalmersLProvider.h
//  My Student Card
//
//  Created by Simon on 2013-11-05.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXILunchProvider.h"
#import "SHXChalmersRestaurant.h"

@interface SHXChalmersLProvider : NSObject <SHXILunchProvider>

-(id) initWithRestaurant:(SHXChalmersRestaurant*)restaurant;

@end
