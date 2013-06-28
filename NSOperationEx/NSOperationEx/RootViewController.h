//
//  RootViewController.h
//  Monitise
//
//  Created by Chatterjee,Suman on 16/12/2012.
//  Copyright (c) 2012 Chatterjee,Suman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController 
@property (strong, nonatomic) NSArray *entries;
@property (strong, nonatomic) NSMutableDictionary *imageDownloadsInProgress;


@end