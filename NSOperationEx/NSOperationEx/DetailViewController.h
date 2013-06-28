//
//  DetailViewController.h
//  Monitise
//
//  Created by Chatterjee,Suman on 16/12/2012.
//  Copyright (c) 2012 Chatterjee,Suman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataRecord.h"
#import "PictureDownloader.h"

@interface DetailViewController : UIViewController<PictureDownloaderDelegate>
-(void) configureView:(DataRecord*)appRecord;
@end
