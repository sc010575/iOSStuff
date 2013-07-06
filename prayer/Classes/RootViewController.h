//
//  RootViewController.h
//  prayer
//
//  Created by Suman Chatterjee on 23/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	NSMutableArray *mainTableData;
	NSMutableArray *mainTableSection;
}

-(void) createMainTableData;

@end
