//
//  SAPInFixVideo.h
//  SAPInFixTutorial
//
//  Created by Suman Chatterjee on 03/11/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SAPInFixVideo : UIViewController {
	
	NSString * videoUrl;

	
}

- (void)embedVideo:(CGRect)frame;

@property (nonatomic,assign) NSString * videoUrl;

@end