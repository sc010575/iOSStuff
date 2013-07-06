//
//  mapViewDetails.m
//  prayer
//
//  Created by Suman Chatterjee on 28/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import "mapViewDetails.h"
#import "mapPin.h"
#import "pinDetailView.h"

@implementation mapViewDetails

@synthesize homeMap,locationManager,resourceData,sourceCoordinate; 

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
	[locationManager startUpdatingLocation];
	
	// load our data from a plist file inside our app bundle
	NSString *path = [[NSBundle mainBundle] pathForResource:@"tampleList" ofType:@"plist"];
	self.resourceData = [NSMutableArray arrayWithContentsOfFile:path];
	
	[homeMap setDelegate:self];
	
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[homeMap release];
	[locationManager release];
    [super dealloc];
}

//delegate 

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	double mylatitute = newLocation.coordinate.latitude;
	double mylongitude = newLocation.coordinate.longitude;
	
	sourceCoordinate.latitude = mylatitute;
	sourceCoordinate.longitude = mylongitude;
	
	[manager stopUpdatingLocation];
	CLLocation *MyLocation = [[[CLLocation alloc] initWithLatitude:mylatitute longitude:mylongitude]autorelease];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(MyLocation.coordinate, 50000, 50000);
	[self.homeMap setRegion:region animated:YES];
	
	NSDictionary *item = nil;
	NSString *name = nil;
	NSString* latitude = nil;
	NSString* longitude = nil;
	NSString* address = nil;
	NSString *phone = nil;
	
	mapPin *pin = nil;
	
	for (int i=0;i< [resourceData count];++i)
	{
	item = [resourceData objectAtIndex:i];
	name = [item objectForKey:@"name"];
	latitude = [item objectForKey:@"latitude"];
	longitude = [item objectForKey:@"longitude"];
	address =  [item objectForKey:@"address"];
	phone = [item objectForKey:@"phone"];
	
	CLLocation *locFilter = [[[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[ longitude doubleValue]] autorelease]; 
	CLLocationDistance delta = [newLocation distanceFromLocation:locFilter ];
	long miles = (delta *0.000621371) + 0.5; //meters rounded miles
	
		if (miles < 50)			//Shows temple in 50 miles
		{
			CLLocationCoordinate2D coordinate = {[latitude doubleValue],[longitude doubleValue]};
			pin = [[mapPin alloc]initWithCoordinates:coordinate placeName:name description:address];
			[self.homeMap addAnnotation:pin];
			NSString *tmpUrl = [item objectForKey:@"url"];
			if (![tmpUrl isEqualToString: @"none"]) 
				[pin setUrl:[NSURL URLWithString:[item objectForKey:@"url"]]];

			[pin setPhone:phone];
			[pin release];
		}
		
	}
	
		
	
	[item release];

	
	
}

#pragma mark mapView delegate functions


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKAnnotationView* annotationView = nil;
	
	// determine the type of annotation, and produce the correct type of annotation view for it.
	mapPin *customPin = (mapPin*)annotation;
	NSString* identifier = @"Pin";
	MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.homeMap dequeueReusableAnnotationViewWithIdentifier:identifier];
		
	if(nil == pin)
	{
		pin = [[[MKPinAnnotationView alloc] initWithAnnotation:customPin reuseIdentifier:identifier] autorelease];
	}
		
	[pin setPinColor:MKPinAnnotationColorPurple];
	pin.animatesDrop = YES;
	pin.canShowCallout = YES;
		
	annotationView = pin;
	annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

	[annotationView setEnabled:YES];
	[annotationView setCanShowCallout:YES];
	
	return annotationView;
	
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	NSLog(@"calloutAccessoryControlTapped");
	
	
	mapPin* customPin = (mapPin*)[view annotation];
	
	pinDetailView *pinDetailViewController = [[pinDetailView alloc] initWithNibName:@"pinDetailView" bundle:nil];
	pinDetailViewController.address = customPin.userData;
	pinDetailViewController.phone = customPin.phone;
	pinDetailViewController.destcoordinate = customPin.coordinate;
	pinDetailViewController.sourcecoordinate = sourceCoordinate;
	 
	NSURL*   myURL = customPin.url;
	if (myURL!= nil) {
		pinDetailViewController.detailURL = myURL;
	}
	else {
		pinDetailViewController.detailURL = nil;
	}

	//[myURL release];
	[self.navigationController pushViewController:pinDetailViewController animated:YES];
	[pinDetailViewController release];

}


@end
