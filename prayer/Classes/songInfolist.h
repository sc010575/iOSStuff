//
//  songInfolist.h
//  prayer
//
//  Created by Suman Chatterjee on 29/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface songInfolist : UITableViewController {
	NSMutableArray *resourceData;

}

-(void) createSongTableData;

@property (nonatomic,retain) NSMutableArray *resourceData;
@end
