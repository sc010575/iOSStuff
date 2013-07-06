//
//  mapViewDetails.h
//  prayer
//
//  Created by Suman Chatterjee on 28/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "MapPin.h"


@interface mapViewDetails : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate> {
	
	IBOutlet MKMapView *homeMap;
	CLLocationManager  *locationManager;
	NSMutableArray	   *resourceData;
	CLLocationCoordinate2D sourceCoordinate;
	
}


@property (nonatomic,retain) MKMapView *homeMap;
@property (assign, nonatomic) CLLocationManager *locationManager;
@property (nonatomic,retain) NSMutableArray *resourceData;
@property (nonatomic,assign) CLLocationCoordinate2D sourceCoordinate;
@end
