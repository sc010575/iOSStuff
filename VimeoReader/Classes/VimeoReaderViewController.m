//
//  VimeoReaderViewController.m
//  VimeoReader
//
//  Created by Suman Chatterjee on 27/06/2012.
//  Copyright 2012 DreamApps Infotech. All rights reserved.
//

#import "VimeoReaderViewController.h"
#import "VimeoHelper.h"
#import "VideoList.h"
#import "GTMOAuthViewControllerTouch.h"

//static NSString *const kTwitterKeychainItemName = @"OAuth Sample: Twitter";
static NSString *const kViemoServiceName = @"Vimeo";

@implementation VimeoReaderViewController
@synthesize videoButton;
@synthesize signInButton;
@synthesize vmHelper;
@synthesize videoList;
@synthesize vdList;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
	//alloc and initalize our FbGraph instance
	self.vmHelper = [[VimeoHelper alloc] initWithHelper];	
	[videoButton setEnabled:NO];	
    [super viewDidLoad];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


-(IBAction) videoButtonPressed:(id)sender{
	
	
	if(self.vdList == nil)
	{
		VideoList *videoListController =[[VideoList alloc] initWithNibName:@"VideoList" bundle:[NSBundle mainBundle]];
		self.vdList = videoListController;
		self.vdList.mainTableData = self.videoList;
		[videoListController release];
	}
	
//	[vdList setDelegate:self];
	
	[self.navigationController pushViewController:self.vdList animated:YES];
	
}


- (void)dealloc {
	[videoButton release];
	[signInButton release];
	[vmHelper release];
	[videoList release];
	[vdList release];
    [super dealloc];
}


- (void)vmHelperCallback:(id)sender {
	
	self.videoList = self.vmHelper.videoList;
	[videoButton setEnabled:YES];

	}


-(IBAction) signInButtonPressed:(id)sender
{
	if (![self isSignedIn]) {
			[self signInToVimeo];
	}
	else {
		// sign out
		[self signOut];
	}
	[self updateUI];
}

- (GTMOAuthAuthentication *)authForVimeo {
	NSString *myConsumerKey = @"61eb2f0370d0820973d4809e258e62b97dcd917c"; // @"d2d4fce7e51f572ef3dc1a8fd8d91656439c2bad";
	NSString *myConsumerSecret = @"e6242b58ffec994a9dcc6aa49b63227cf952be67";  //@"e2d1e3c67964b5d918883fb87572578d81f775ad";
	
	if ([myConsumerKey length] == 0 || [myConsumerSecret length] == 0) {
		return nil;
	}
	
	GTMOAuthAuthentication *auth;
	auth = [[[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                        consumerKey:myConsumerKey
                                                         privateKey:myConsumerSecret] autorelease];
	
	// setting the service name lets us inspect the auth object later to know
	// what service it is for
	[auth setServiceProvider:kViemoServiceName];
	
	return auth;
}


- (void)signInToVimeo{
	
	[self signOut];
	
	NSURL *requestURL = [NSURL URLWithString:@"https://vimeo.com/oauth/request_token"];
	NSURL *accessURL = [NSURL URLWithString:@"https://vimeo.com/oauth/access_token"];
	NSURL *authorizeURL = [NSURL URLWithString:@"https://vimeo.com/oauth/authorize"];
	NSString *scope = @"https://developer.vimeo.com/apis/";
	
	GTMOAuthAuthentication *auth = [self authForVimeo];
	if (auth == nil) {
		// perhaps display something friendlier in the UI?
		NSAssert(NO, @"A valid consumer key and consumer secret are required for signing in to Viemo");
	}
	
	// set the callback URL to which the site should redirect, and for which
	// the OAuth controller should look to determine when sign-in has
	// finished or been canceled
	//
	// This URL does not need to be for an actual web page; it will not be
	// loaded
	[auth setCallback:@"http://www.example.com/OAuthCallback"];
	
	NSString *keychainItemName = nil;
	
	// Display the autentication view.
	GTMOAuthViewControllerTouch *viewController;
	viewController = [[[GTMOAuthViewControllerTouch alloc] initWithScope:scope
																language:nil
														 requestTokenURL:requestURL
													   authorizeTokenURL:authorizeURL
														  accessTokenURL:accessURL
														  authentication:auth
														  appServiceName:keychainItemName
																delegate:self
														finishedSelector:@selector(viewController:finishedWithAuth:error:)] autorelease];
	
	// We can set a URL for deleting the cookies after sign-in so the next time
	// the user signs in, the browser does not assume the user is already signed
	// in
	[viewController setBrowserCookiesURL:[NSURL URLWithString:@"https://developer.vimeo.com/"]];
	
	// You can set the title of the navigationItem of the controller here, if you want.
	
	[[self navigationController] pushViewController:viewController animated:YES];
}

- (void)signOut {
	if ([[mAuth serviceProvider] isEqual:kGTMOAuthServiceProviderGoogle]) {
		// remove the token from Google's servers
		[GTMOAuthViewControllerTouch revokeTokenForGoogleAuthentication:mAuth];
	}
	// Discard our retained authentication object.
	[self setAuthentication:nil];
	[self updateUI];
}

- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error {
	if (error != nil) {
		// Authentication failed (perhaps the user denied access, or closed the
		// window before granting access)
		NSLog(@"Authentication error: %@", error);
		NSData *responseData = [[error userInfo] objectForKey:@"data"]; // kGTMHTTPFetcherStatusDataKey
		if ([responseData length] > 0) {
			// show the body of the server's authentication failure response
			NSString *str = [[[NSString alloc] initWithData:responseData
												   encoding:NSUTF8StringEncoding] autorelease];
			NSLog(@"%@", str);
		}
		
		[self setAuthentication:nil];
	} else {
		// Authentication succeeded
		//
		// At this point, we either use the authentication object to explicitly
		// authorize requests, like
		//
		//   [auth authorizeRequest:myNSURLMutableRequest]
		//
		// or store the authentication object into a GTM service object like
		//
		//   [[self contactService] setAuthorizer:auth];
		
		// save the authentication object
		[self setAuthentication:auth];
		
		if(self.vmHelper)
			self.vmHelper.mAuth = [self getAuthentication];
		
		//begin the authentication process.....
		[vmHelper authenticateUserWithCallbackObject:self andSelector:@selector(vmHelperCallback:)];

	}
	
	[self updateUI];
}

- (BOOL)isSignedIn {
	BOOL isSignedIn = [mAuth canAuthorize];
	return isSignedIn;
}



- (void)updateUI {
	// update the text showing the signed-in state and the button title
	// A real program would use NSLocalizedString() for strings shown to the user.
	if ([self isSignedIn]) {
		// signed in
		[signInButton setTitle:@"Sign Out" forState: UIControlStateNormal];
		[signInButton setTitle:@"Sign Out" forState: UIControlStateApplication];
		[signInButton setTitle:@"Sign Out" forState: UIControlStateHighlighted];
		[signInButton setTitle:@"Sign Out" forState: UIControlStateReserved];
		[signInButton setTitle:@"Sign Out" forState: UIControlStateSelected];
		[signInButton setTitle:@"Sign Out" forState: UIControlStateDisabled];
	} else {
		// signed out
		[signInButton setTitle:@"Sign In" forState: UIControlStateNormal];
		[signInButton setTitle:@"Sign In"forState: UIControlStateApplication];
		[signInButton setTitle:@"Sign In" forState: UIControlStateHighlighted];
		[signInButton setTitle:@"Sign In" forState: UIControlStateReserved];
		[signInButton setTitle:@"Sign In" forState: UIControlStateSelected];
		[signInButton setTitle:@"Sign In" forState: UIControlStateDisabled];
	}
//	BOOL isRemembering = [self shouldSaveInKeychain];
//	[mShouldSaveInKeychainSwitch setOn:isRemembering];
}


- (void)setAuthentication:(GTMOAuthAuthentication *)auth {
	[mAuth autorelease];
	mAuth = [auth retain];
}

-(GTMOAuthAuthentication*)getAuthentication{
	return mAuth;
}

@end
