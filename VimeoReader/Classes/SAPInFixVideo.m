//
//  SAPInFixVideo.m
//  SAPInFixTutorial
//
//  Created by Suman Chatterjee on 03/11/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import "SAPInFixVideo.h"


@implementation SAPInFixVideo

@synthesize videoUrl;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self embedVideo:CGRectMake(0, 44, 320, 416)];
	
		
}

- (void)embedVideo:(CGRect)frame {
	
	NSString *htmlString = [NSString stringWithFormat:@"<html>"
							@"<head>"
							@"<meta name = \"viewport\" content =\"initial-scale = 1.0, user-scalable = no, width = 320\"/></head>"
							@"<frameset border=\"0\">"
							@"<frame src=\"http://player.vimeo.com/video/%@?title=0&amp;byline=0&amp;portrait=1&amp;autoplay=1\" width=\"320\" height=\"140\" frameborder=\"0\"></frame>"
							@"</frameset>"
							@"</html>", 
							videoUrl];	
	UIWebView *videoView = [[UIWebView alloc] initWithFrame:frame];
	[videoView loadHTMLString:htmlString baseURL:nil];
	[self.view addSubview:videoView];
	[videoView release];
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
//	[videoUrl release];
    [super dealloc];
}


@end
