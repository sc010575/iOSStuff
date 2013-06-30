//
//  VimeoReaderAppDelegate.m
//  VimeoReader
//
//  Created by Suman Chatterjee on 27/06/2012.
//  Copyright 2012 DreamApps Infotech. All rights reserved.
//

#import "VimeoReaderAppDelegate.h"
#import "VimeoReaderViewController.h"

@implementation VimeoReaderAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	navigationController = [[UINavigationController alloc] init];
    [self.window addSubview:[self.navigationController view]];

	if(self.viewController == nil)
	{
		VimeoReaderViewController *mainview = [[VimeoReaderViewController alloc] initWithNibName:@"VimeoReaderViewController" bundle:[NSBundle mainBundle]];
		self.viewController = mainview;
		[mainview release];
	}
	
	[self.navigationController pushViewController:self.viewController animated:YES];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
	[navigationController release];
    [window release];
    [super dealloc];
}


@end
