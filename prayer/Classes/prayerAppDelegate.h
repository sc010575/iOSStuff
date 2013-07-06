//
//  prayerAppDelegate.h
//  prayer
//
//  Created by Suman Chatterjee on 23/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface prayerAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

