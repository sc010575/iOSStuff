//
//  VimeoHelper.h
//  VimeoReader
//
//  Created by Suman Chatterjee on 27/06/2012.
//  Copyright 2012 DreamApps Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTMOAuthAuthentication;
@interface VimeoHelper : NSObject {
	
	NSMutableData *responseData;
	NSMutableArray *videoList;
	id callbackObject;
	SEL callbackSelector;
	NSString *errorString;
	GTMOAuthAuthentication *mAuth;



}

@property (assign) id callbackObject;
@property (assign) SEL callbackSelector;
@property (nonatomic,retain) NSMutableArray *videoList;
@property (nonatomic,retain) GTMOAuthAuthentication *mAuth;


- (id)initWithHelper;
- (void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector;

@end
