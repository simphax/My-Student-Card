//
//  NSString+NRStringFormatting.m
//  My Student Card
//
//  Created by Simon on 2015-02-13.
//  Copyright (c) 2015 Simphax. All rights reserved.
//

#import "NSString+NRStringFormatting.h"
//http://stackoverflow.com/questions/26116232/nsstring-append-whitespace-for-every-4-character
@implementation NSString (NRStringFormatting)
-(NSString *) stringByFormattingAsCreditCardNumber
{
    NSMutableString *result = [NSMutableString string];
    __block NSInteger count = -1;
    [self enumerateSubstringsInRange:(NSRange){0, [self length]}
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              if ([substring rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location != NSNotFound)
                                  return;
                              count += 1;
                              if (count == 4) {
                                  [result appendString:@" "];
                                  count = 0;
                              }
                              [result appendString:substring];
                          }];
    return result;
}
@end