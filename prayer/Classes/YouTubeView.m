//
//  YouTubeView.m
//  prayer
//
//  Created by Suman Chatterjee on 29/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import "YouTubeView.h"


@implementation YouTubeView

@synthesize resourceData,rownum,songTitle;

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
	
	// load our data from a plist file inside our app bundle
	NSString *path = [[NSBundle mainBundle] pathForResource:@"songinfo" ofType:@"plist"];
	self.resourceData = [NSMutableArray arrayWithContentsOfFile:path];
	
	
	NSDictionary *item = (NSDictionary *)[resourceData objectAtIndex:rownum];
    NSString *youtubeURL = [item objectForKey:@"url"];
	self.songTitle.text = [item objectForKey:@"name"];
	
	
	[self embedYouTube:youtubeURL frame:CGRectMake(55, 220, 200, 200)];
	
	[item release];


}

/*- (void)setRownum:(int)rownumber{
	self.rownum = rownumber;
}*/

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame {
	NSString *embedHTML = @"\
    <html><head>\
	<style type=\"text/css\">\
	body {\
	background-color: transparent;\
	color: white;\
	}\
	</style>\
	</head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
	width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
	NSString *html = [NSString stringWithFormat:embedHTML, urlString, frame.size.width, frame.size.height];
	UIWebView *videoView = [[UIWebView alloc] initWithFrame:frame];
	[videoView loadHTMLString:html baseURL:nil];
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
	[songTitle release];
    [super dealloc];
}


@end
