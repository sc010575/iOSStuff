//
//  VimeoHelper.m
//  VimeoReader
//
//  Created by Suman Chatterjee on 27/06/2012.
//  Copyright 2012 DreamApps Infotech. All rights reserved.
//

#import "VimeoHelper.h"
#import "JSON/JSON.h"
#import "GTMOAuthViewControllerTouch.h"

static  NSString * const URLString = @"http://vimeo.com/api/v2/user12265366/videos.json";

//static NSString *const KViemoURL = @"http://vimeo.com/api/rest/v2?format=json&method=vimeo.videos.getAll&user_id=user12265366";

static NSString *const KViemoURL = @"http://vimeo.com/api/rest/v2?format=json&method=vimeo.videos.getAll&user_id=sapinfix";

@implementation VimeoHelper

@synthesize callbackObject;
@synthesize callbackSelector;
@synthesize videoList;
@synthesize mAuth;

- (id)initWithHelper{
	if (self = [super init]) {
	}
	return self;
}



- (void)authenticateUserWithCallbackObject:(id)anObject andSelector:(SEL)selector{
	self.callbackObject = anObject;
	self.callbackSelector = selector;
	
	responseData = [[NSMutableData data] retain];		
	NSURL *url = [NSURL URLWithString:KViemoURL];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[mAuth authorizeRequest:request];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//	label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
	errorString = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {		
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	
	NSError *error;
	
	SBJSON *parser = [[SBJSON alloc] init];
	NSDictionary *parsed_json = [parser objectWithString:responseString error:&error];	
	[parser release];
	
	//get the keys for videos 
	NSDictionary *VideoData = (NSDictionary*)[parsed_json objectForKey:@"videos"];
	
	//get the video array
	NSArray *dataArray = (NSArray *)[VideoData objectForKey:@"video"];
	
	if (dataArray == nil)
		errorString = [NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]];
	else {		
		
		videoList = [[NSMutableArray alloc] initWithCapacity:[dataArray count]];
		
		for (int i = 0; i < [dataArray count]; i++) 
		{
			//get latest 
			NSDictionary* videoId = [dataArray objectAtIndex:i];
			
			//fetch the data
			NSString* video_id = [videoId objectForKey:@"id"];
			NSString* video_Description = [videoId objectForKey:@"title"];	
			[videoList addObject:[[NSMutableDictionary alloc]
								  initWithObjectsAndKeys:video_Description,@"name",
								  video_id,@"id",nil]];
			
		}
	}
	
		
		//tell our callback function that we're done logging in :)
		if ( (callbackObject != nil) && (callbackSelector != nil) ) {
			[callbackObject performSelector:callbackSelector];
	} 
}




-(void) dealloc {
	
    [videoList release];
	[mAuth release];
	[super dealloc];
}




@end
