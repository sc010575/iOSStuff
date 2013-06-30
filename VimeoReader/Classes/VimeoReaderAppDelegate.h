//
//  VimeoReaderAppDelegate.h
//  VimeoReader
//
//  Created by Suman Chatterjee on 27/06/2012.
//  Copyright 2012 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VimeoReaderViewController;

@interface VimeoReaderAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController  *navigationController;
    VimeoReaderViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController    *navigationController;
@property (nonatomic, retain) IBOutlet VimeoReaderViewController *viewController;

@end

