//
//  CustomLabel.m
//  ActivEngage2
//
//  Created by Chatterjee,Suman on 13/03/2013.
//  Copyright (c) 2013 DreamApps. All rights reserved.
//

#import "CustomLabel.h"
#import <QuartzCore/QuartzCore.h>


@implementation CustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Get bounds
    CGRect f = self.bounds;
    CGFloat yOff = f.origin.y + f.size.height - 3.0;
    
    // Calculate text width
    CGSize tWidth = [self.text sizeWithFont:self.font];
    
    // Draw underline
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(con, self.textColor.CGColor);
    CGContextSetLineWidth(con, 1.0);
    CGContextMoveToPoint(con, f.origin.x, yOff);
    CGContextAddLineToPoint(con, f.origin.x + tWidth.width, yOff);
    CGContextStrokePath(con);
}

@end
