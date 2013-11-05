//
//  SHXChalmersLProvider.m
//  My Student Card
//
//  Created by Simon on 2013-11-05.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXChalmersLProvider.h"
#import "SHXLunchRow.h"

@implementation SHXChalmersLProvider

-(void)getLunchListWithCompletionHandler:(void(^)(NSArray *lunchlist, NSError *error))handler
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    SHXLunchRow *row = [[SHXLunchRow alloc] init];
    [row setType:@"Xpress"];
    [row setMeal:@"Kyckling, \"grön curry\", jasminris"];
    [array addObject:row];
    
    row = [[SHXLunchRow alloc] init];
    [row setType:@"Classic Kött"];
    [row setMeal:@"Stekt fläsk, raggmunk, lingon"];
    [array addObject:row];
    
    handler(array,nil);
}

@end
