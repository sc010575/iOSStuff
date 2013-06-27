//
//  UIColor+Promethean.h
//  ActivEngage2
//
//  Created by Mobile Dev on 11/19/12.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Promethean)

+ (UIColor*) fromHex:(int) hex;
+ (UIColor*) fromR:(int) r G:(int)g B:(int)b;
+ (NSString *) HexStringFromUIColor:(UIColor *)_color;

- (UIImage*)imageWithColor;

@end
