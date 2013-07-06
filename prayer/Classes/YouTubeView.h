//
//  YouTubeView.h
//  prayer
//
//  Created by Suman Chatterjee on 29/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YouTubeView : UIViewController {

	NSMutableArray * resourceData;
	IBOutlet UILabel * songTitle;
	
	int rownum;

}


@property (nonatomic,retain) NSMutableArray *resourceData;
@property (nonatomic,assign) int  rownum;
@property (nonatomic,retain) IBOutlet UILabel * songTitle;


//- (void)setRownum:(int)rownumber;

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame;

@end
