//
//  NSString+URLEncode.m
//  My Student Card
//
//  Created by Simon Nilsson on 2015-09-05.
//  Copyright © 2015 Simphax. All rights reserved.
//

#import "NSString+URLEncode.h"
//http://stackoverflow.com/questions/8088473/how-do-i-url-encode-a-string
@implementation NSString (URLEncode)

- (NSString *)urlEncodedString {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
@end
