//
//  mapPin.m
//  prayer
//
//  Created by Suman Chatterjee on 28/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import "mapPin.h"


@implementation mapPin
@synthesize coordinate;
@synthesize userData       = _userData;
@synthesize title;
@synthesize url            = _url;
@synthesize phone = _phone ;


-(id)initWithCoordinates:(CLLocationCoordinate2D)location
			   placeName:placeName
			 description:description{
	
	self = [super init];
	if (self != nil) {
		coordinate = location;
		title = placeName;
		[title retain];
		_userData = description;
		[_userData retain];
	}
	
	return self;
}

- (NSString *)subtitle
{
	NSString* subtitle = nil;
	
		subtitle = _userData;

	
	return subtitle;
}



-(void)dealloc{
	
	[title release];
	[_userData release];
	[_url      release];
	[_phone release]; 
	[super dealloc];
}

@end
