//
//  UITextView+Promethean.m
//  ActivEngage2
//
//  Created by Chatterjee,Suman on 28/03/2013.
//  Copyright (c) 2013 Promethean. All rights reserved.
//

#import "UITextView+Promethean.h"

@implementation UITextView (Promethean)

- (void)deleteBackward{
    @try{
        //check current selected range
        NSRange selectedRange = [[self valueForKey:@"selectionRange"] rangeValue];
        if (selectedRange.location == NSNotFound) selectedRange = NSMakeRange([[self text] length], 0);
        if (selectedRange.location < 1) return;
        
        //delete one char
        NSRange deleteRange = (selectedRange.length>0)?selectedRange:NSMakeRange(selectedRange.location-1,1);
        self.text = [self.text stringByReplacingCharactersInRange:deleteRange withString:@""];
        
        //adjust the selected range to reflect the changes
        selectedRange.location = deleteRange.location;
        selectedRange.length = 0;
        [self setValue:[NSValue valueWithRange:selectedRange] forKey:@"selectionRange"];
    }@catch (NSException *exception) {
        NSLog(@"failed but catched. %@", exception);
    }@finally {}
}

@end
