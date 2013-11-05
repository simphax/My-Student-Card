//
//  SHXILunchProvider.h
//  My Student Card
//
//  Created by Simon on 2013-11-05.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SHXILunchProvider <NSObject>

-(void)getLunchListWithCompletionHandler:(void(^)(NSArray *lunchList, NSError *error))handler;

@end
