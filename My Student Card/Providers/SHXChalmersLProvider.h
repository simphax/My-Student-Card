//
//  SHXChalmersLProvider.h
//  My Student Card
//
//  Created by Simon on 2013-11-05.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXILunchProvider.h"

typedef NS_ENUM(NSInteger, SHXChLLocation) {
    SHXChLLocationLindholmenKokboken,
    SHXChLLocationJohannebergKarrestaurangen
};

@interface SHXChalmersLProvider : NSObject <SHXILunchProvider>

-(id) initWithLocation:(SHXChLLocation)location;

@end
