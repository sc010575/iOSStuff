//
//  mapPin.h
//  prayer
//
//  Created by Suman Chatterjee on 28/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>



@interface mapPin : NSObject <MKAnnotation> {
		
		CLLocationCoordinate2D coordinate;
		NSString *_userData;
		NSString *title;
		NSURL*                 _url;
		NSString		*_phone;

		
		
	}
	
	@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
	@property (nonatomic,retain) NSString *userData;
	@property (nonatomic,readonly) NSString *title;
	@property (nonatomic, retain) NSURL* url;
@property (nonatomic,retain) NSString *phone;

	
	-(id)initWithCoordinates:(CLLocationCoordinate2D)location
				   placeName: placeName
				 description: description;
	

@end
