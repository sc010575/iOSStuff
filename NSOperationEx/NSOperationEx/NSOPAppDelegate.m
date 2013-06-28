//
//  NSOPAppDelegate.m
//  NSOperationEx
//
//  Created by Suman Chatterjee on 27/06/2013.
//  Copyright (c) 2013 DreamApps. All rights reserved.
//

#import "NSOPAppDelegate.h"
#import "DetailViewController.h"
#import <CFNetwork/CFNetwork.h>
#import "ParseOperation.h"
#import "RootViewController.h"

static NSString *const monitiseServerUrl =
@"https://dl.dropboxusercontent.com/u/91400106/Data.xml";

@interface NSOPAppDelegate()
{
    // the list of server data shared with "RootViewController"
    NSMutableArray          *serverRecords;
    
    // the queue to run our "ParseOperation"
    NSOperationQueue		*queue;
    
    // xml file network connection to the server
    NSURLConnection         *serverListFeedConnection;
    NSMutableData           *serverListData;
    RootViewController *rootViewController;

}

@end

@implementation NSOPAppDelegate
@synthesize serverRecords, queue, serverListFeedConnection, serverListData;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    // Set root view controller and make windows visible
    NSString *storyboardName = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?@"MainStoryboard_iPad":@"MainStoryboard_iPhone";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    // Initialize the array of server records and pass a reference to that list to the root view controller
    self.serverRecords = [NSMutableArray array];
    rootViewController.entries = self.serverRecords;

    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    
    //request server connection
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:monitiseServerUrl]];
    self.serverListFeedConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    // Test the validity of the connection object.
    NSAssert(self.serverListFeedConnection != nil, @"Failure to create URL connection.");
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// -------------------------------------------------------------------------------
//	handleLoadedDataFromServer:notif
// -------------------------------------------------------------------------------
- (void)handleLoadedDataFromServer:(NSArray *)loadedRecords
{
    [self.serverRecords addObjectsFromArray:loadedRecords];
    
    // tell our table view to reload its data, now that parsing has completed
    [rootViewController.tableView reloadData];
}


#pragma mark -
#pragma mark NSURLConnection delegate methods

// -------------------------------------------------------------------------------
//	handleError:error
// -------------------------------------------------------------------------------
- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Show Data.."
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
}

// The following are delegate methods for NSURLConnection.

// -------------------------------------------------------------------------------
//	connection:didReceiveResponse:response
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.serverListData = [NSMutableData data];    // start off with new data
}

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [serverListData appendData:data];  // append incoming data
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([error code] == kCFURLErrorNotConnectedToInternet)
	{
        // Identify the error, present a more precise message to the user.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection.."
															 forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
        [self handleError:noConnectionError];
    }
	else
	{
        // otherwise handle the error generically
        [self handleError:error];
    }
    
    self.serverListFeedConnection = nil;   // release our connection
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.serverListFeedConnection = nil;   // release our connection
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // create the queue to run our ParseOperation
    self.queue = [[NSOperationQueue alloc] init];
    
    // create an ParseOperation (NSOperation subclass) to parse the XML data so that the UI is not blocked.
    // "ownership of serverListData has been transferred to the parse operation and should no longer be
    // referenced in this thread.
    //
    ParseOperation *parser = [[ParseOperation alloc] initWithData:serverListData
                                                completionHandler:^(NSArray *appList) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        [self handleLoadedDataFromServer:appList];
                                                        
                                                    });
                                                    
                                                    self.queue = nil;   // finished with the queue and ParseOperation
                                                }];
    
    parser.errorHandler = ^(NSError *parseError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self handleError:parseError];
            
        });
    };
    //Start the "ParseOperation"
    [queue addOperation:parser];
    
    
    // ownership of serverListData has been transferred to the parse operation
    // and should no longer be referenced in this thread
    self.serverListData = nil;
}

@end
