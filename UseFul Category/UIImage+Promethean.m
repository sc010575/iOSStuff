//
//  UIImage+Promethean.m
//  ActivEngage2
//
//  Created by Suman Chatterjee on 06/12/2012.
//  Copyright (c) 2012 Promethean. All rights reserved.
//

#import "UIImage+Promethean.h"


@implementation UIImage (Promethean)

//Static helper function for image generation from base64 string
+(UIImage *) imageFrombase64String:(NSString*) base64String
{
    NSString *str = @"data:image/png;base64,";
    str = [str stringByAppendingString:base64String];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

//Static helper function for image resizing
+(UIImage*) imageResize:(UIImage*)image withSize:(CGSize)size
{
    UIImage* newImage;
    UIGraphicsBeginImageContext(size);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    newImage = image;
    return newImage;
}



+(UIImage*)imageFromURL:(NSString*) url
{
    NSURL *_url = [NSURL URLWithString:url];
    NSData *data = [NSData dataWithContentsOfURL:_url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}


- (UIImage *)padding:(CGRect)rect {
    
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}


-(UIImage*)maskWithImage:(UIImage*)maskImage
{
	/// Apply the mask
	UIImage* result;
    
    return result;
}
CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


@end
