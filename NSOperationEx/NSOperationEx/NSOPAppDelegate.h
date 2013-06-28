//
//  NSOPAppDelegate.h
//  NSOperationEx
//
//  Created by Suman Chatterjee on 27/06/2013.
//  Copyright (c) 2013 DreamApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSOPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *serverRecords;

@property (strong, nonatomic) NSOperationQueue *queue;

@property (strong, nonatomic) NSURLConnection *serverListFeedConnection;
@property (strong, nonatomic) NSMutableData *serverListData;


@end
