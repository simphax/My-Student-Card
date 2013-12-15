

#import "SHXAutoFormatTextFieldDelegate.h"

@implementation SHXAutoFormatTextFieldDelegate

// Source and explanation: http://stackoverflow.com/a/19161529/1709587
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *textAfterReplacing = [textField.text stringByReplacingCharactersInRange:range withString:replacementString];
    
    // In order to make the cursor end up positioned correctly, we need to explicitly reposition it after we inject spaces into the text.
    // No matter how the user changes the content - whether by deletion, insertion, or replacement of existing content by selecting and typing or pasting - we always want the cursor to end up at the end of the replacement string.
    // targetCursorPosition keeps track of where the cursor needs to end up as we modify the string, and at the end we set the cursor position to it.
    NSUInteger targetCursorPosition = range.location + [replacementString length];
    
    NSString *cardNumberWithoutSpaces = [self removeNonDigits:textAfterReplacing andPreserveCursorPosition:&targetCursorPosition];
    
    if ([cardNumberWithoutSpaces length] > 16) {
        // If the user is trying to enter more than 16 digits, we cancel the entire operation and leave the text field as it was.
        return NO;
    }
    
    NSString *cardNumberWithSpaces = [self insertSpacesEveryFourDigitsIntoString:(NSString *)cardNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPosition];
    
    textField.text = cardNumberWithSpaces;
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument]
                                                              offset:targetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition:targetPosition]];
    
    return NO;
}

/*
 Removes non-digits from the string, decrementing `cursorPosition` as
 appropriate so that, for instance, if we pass in `@"1111 1123 1111"`
 and a cursor position of `8`, the cursor position will be changed to
 `7` (keeping it between the '2' and the '3' after the spaces are removed).
 */
- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSUInteger targetCursorPositionInOriginalReplacementString = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < targetCursorPositionInOriginalReplacementString) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

/*
 Inserts spaces into the string to format it as a credit card number,
 incrementing `cursorPosition` as appropriate so that, for instance, if we
 pass in `@"111111231111"` and a cursor position of `7`, the cursor position
 will be changed to `8` (keeping it between the '2' and the '3' after the
 spaces are added).
 */
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<[string length]; i++) {
        if ((i>0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}
@end
