//
//  pinDetailView.m
//  prayer
//
//  Created by Suman Chatterjee on 30/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import "pinDetailView.h"


@implementation pinDetailView

@synthesize address,addressLable,phoneLable,phone,detailURL,webView,BtPhoneCall,BtDirection,destcoordinate,sourcecoordinate;

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
	
	addressLable.text = address;
	phoneLable.text = phone;
	if (detailURL != nil){
		
		[webView loadRequest:[NSURLRequest requestWithURL:detailURL]];
	}
	else 
		webView.hidden = YES;
	
    [super viewDidLoad];
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


- (IBAction)doPhoneCall:(id)sender{
	
	//make a phone call
	NSString *details = [NSString stringWithFormat:@"tel://%@ ", phone]  ;

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:details]];
}


-(IBAction)doMapDirection:(id)sender{
	
//	NSString* addr = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=Current Location&saddr=%@",startAddr];

	NSString *urlString = [ NSString stringWithFormat: @"http://maps.google.com/maps?daddr=%f,%f&saddr=%f,%f",destcoordinate.latitude,destcoordinate.longitude,sourcecoordinate.latitude,sourcecoordinate.longitude];
	//[[UIApplication sharedApplication] openURL: [NSURL URLWithString: urlString]];
	
	NSURL* url = [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[[UIApplication sharedApplication] openURL:url];
	[url release];
}
- (void)dealloc {
    [addressLable release];
	[phoneLable release];
	[webView release];
	[detailURL release];
	[BtPhoneCall release];
	[BtDirection release];
	[super dealloc];
	
}


@end
