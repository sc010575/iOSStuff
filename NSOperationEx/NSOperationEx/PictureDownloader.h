//
//  IconDownloader.h
//  Monitise
//
//  Created by Chatterjee,Suman on 18/12/2012.
//  Copyright (c) 2012 Chatterjee,Suman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataRecord;
@class RootViewController;

@protocol PictureDownloaderDelegate;

@interface PictureDownloader : NSObject

@property (strong,nonatomic) DataRecord *appRecord;
@property (strong,nonatomic) NSIndexPath *indexPathInTableView;
@property (weak, nonatomic) id <PictureDownloaderDelegate> delegate;


+ (UIImage*)imageResize:(UIImage*)image withSize:(CGFloat)size;
- (void)startDownload:(CGFloat) imageSige;
- (void)cancelDownload;

@end

@protocol PictureDownloaderDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end