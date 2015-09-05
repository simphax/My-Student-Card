//
//  SHXIBalanceProvider.h
//  My Student Card
//
//  Created by Simon on 2013-11-04.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SHXIBalanceProvider <NSObject>

-(void)getBalanceWithCompletionHandler:(void(^)(NSString *name, NSNumber *balance, NSError *error))handler;

@end
