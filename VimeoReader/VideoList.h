//
//  VideoList.h
//  VimeoReader
//
//  Created by Suman Chatterjee on 27/06/2012.
//  Copyright 2012 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoList : UITableViewController {
	
	NSMutableArray *mainTableData;
}

@property (nonatomic,retain)NSMutableArray *mainTableData;

@end
