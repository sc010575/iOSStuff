//
//  PictureDownloader.m
//  Monitise
//
//  Created by Chatterjee,Suman on 18/12/2012.
//  Copyright (c) 2012 Chatterjee,Suman. All rights reserved.
//

#import "PictureDownloader.h"
#import "DataRecord.h"

//private extension
@interface PictureDownloader()
{
    DataRecord *appRecord;
    NSIndexPath *indexPathInTableView;
    id <PictureDownloaderDelegate> __weak delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
    CGFloat ImageSize;
}
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@end

@implementation PictureDownloader

@synthesize appRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark


//Static helper function for image resizing 
+(UIImage*) imageResize:(UIImage*)image withSize:(CGFloat)size
{
    UIImage* newImage;
    CGSize itemSize = CGSizeMake(size, size);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    newImage = image;
    return newImage;
}

- (void)dealloc
{
    [imageConnection cancel];
}

- (void)startDownload:(CGFloat) imageSige
{
    ImageSize = imageSige;
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:appRecord.imageURLString]] delegate:self];
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set picture and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != ImageSize || image.size.height != ImageSize)
	{
        CGSize itemSize = CGSizeMake(ImageSize, ImageSize);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.appRecord.picture = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.appRecord.picture = image;
    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our picture is ready for display
    [delegate appImageDidLoad:self.indexPathInTableView];
}
@end

