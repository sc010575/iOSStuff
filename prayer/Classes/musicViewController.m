//
//  musicViewController.m
//  prayer
//
//  Created by Suman Chatterjee on 24/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import "musicViewController.h"


@implementation musicViewController


@synthesize imageView;
@synthesize player;
@synthesize isPlaying;
@synthesize bellisPlaying;
@synthesize pujaButtonSelected;
@synthesize bellPlayer;
@synthesize rowNumber;
@synthesize resourceData;
@synthesize view2;
@synthesize hopAnimation;
@synthesize lightImage;
@synthesize stickImageView;
@synthesize garlandImageView;
@synthesize foodImageView;
@synthesize animateImageView;
@synthesize lightImageSelected;
@synthesize stickImageSelected;
@synthesize garlandImageSelected;
@synthesize foodImageSelected;
@synthesize updateTimer;

@synthesize pujaButton;


#define ImageHeight  50
#define ImageWidth   50
#define kCustomButtonHeight		30.0


void RouteChangeListener(	void *            inClientData,
						 AudioSessionPropertyID	inID,
						 UInt32                  inDataSize,
						 const void *            inData);

-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
}


- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
	[self updateCurrentTimeForPlayer:p];
	
	if (updateTimer) 
		[updateTimer invalidate];
	
	if (p.playing)
	{
		if (!pujaButtonSelected)
			updateTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateCurrentTime) userInfo:p repeats:YES];
		
		
	}
	else
	{
		updateTimer = nil;
		
	}

}




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
	
	// load our data from a plist file inside our app bundle
	NSString *path = [[NSBundle mainBundle] pathForResource:@"musicsetting" ofType:@"plist"];
	self.resourceData = [NSMutableArray arrayWithContentsOfFile:path];
	
    [self initMusicView];
	
	
	switch (rowNumber) {
		case 0:
			hopAnimation =[[NSArray alloc] initWithObjects:
						   [UIImage imageNamed:@"ganesh01.png"],
						   [UIImage imageNamed:@"ganesh02.png"],
						   [UIImage imageNamed:@"ganesh03.png"],
						   [UIImage imageNamed:@"ganesh04.png"],
						   [UIImage imageNamed:@"ganesh05.png"],
						   nil
						   ];
			break;
		case 1:
			hopAnimation =[[NSArray alloc] initWithObjects:
						   [UIImage imageNamed:@"diwali01.png"],
						   [UIImage imageNamed:@"diwali02.png"],
						   [UIImage imageNamed:@"diwali03.png"],
						   [UIImage imageNamed:@"diwali04.png"],
						   [UIImage imageNamed:@"diwali05.png"],
						   nil
						   ];
			break;
		default:
			break;
	}
	
	// Create the two views to transition between, and add them to our containerView. We'll hide the second one
	// until we are ready to transition to it.
	
	//imageview loading
	UIImage *image1 = [hopAnimation objectAtIndex:0]; 
	imageView = [[UIImageView alloc] initWithImage:image1];
	nextImageNumber = 1;
	
	//view2 loading
	UIImage *image2 = [hopAnimation objectAtIndex:nextImageNumber];
	view2 = [[UIImageView alloc] initWithImage:image2];
	view2.hidden = YES;
    
	//lightImage loading
	UIImage *Image = [UIImage imageNamed:@"Diwali01.gif"];
	lightImage = [[UIImageView alloc] initWithImage:Image];
	CGRect lightFrame = CGRectMake(24, 350, ImageWidth, ImageHeight);
	lightImage.frame = lightFrame;
	lightImage.userInteractionEnabled = YES;
	lightImage.hidden = YES;
	
	//stickImageView loading
	UIImage *stickImage = [UIImage imageNamed:@"sticks.gif"];
	stickImageView = [[UIImageView alloc] initWithImage:stickImage];
	CGRect stickFrame = CGRectMake(98, 350, ImageWidth, ImageHeight);
	stickImageView.frame = stickFrame;
	stickImageView.userInteractionEnabled = YES;
	stickImageView.hidden = YES;
	
	//garlandImageView loading
	UIImage *garlandImage = [UIImage imageNamed:@"flower.gif"];
	garlandImageView = [[UIImageView alloc] initWithImage:garlandImage];
	CGRect garlandFrame = CGRectMake(172, 350, ImageWidth, ImageHeight);
	garlandImageView.frame = garlandFrame;
	garlandImageView.userInteractionEnabled = YES;
	garlandImageView.hidden = YES;
	
	//foodImageView loading
	UIImage *foodImage = [UIImage imageNamed:@"sweets.gif"];
	foodImageView = [[UIImageView alloc] initWithImage:foodImage];
	CGRect foodFrame = CGRectMake(246, 350, ImageWidth, ImageHeight);
	foodImageView.frame = foodFrame;
	foodImageView.userInteractionEnabled = YES;
	foodImageView.hidden = YES;
	
	
	//animateImageView
	animateImageView = nil;
	animateImageView.userInteractionEnabled = YES;
	
	[self.view addSubview:imageView];
	[self.view addSubview:view2];
	[self.view addSubview:lightImage];
	[self.view addSubview:stickImageView];
	[self.view addSubview:garlandImageView];
	[self.view addSubview:foodImageView];
	[self.view addSubview:animateImageView];
	
	
	[self.view sendSubviewToBack:imageView];
	[self.view sendSubviewToBack:view2];
	
	bellisPlaying = NO;
	pujaButtonSelected = NO;
	
	lightImageSelected = NO;
	stickImageSelected = NO;
	garlandImageSelected = NO;
	foodImageSelected = NO;
	
	//set contentMode to scale aspect to fit
	imageView.contentMode =			UIViewContentModeScaleAspectFit;
	view2.contentMode =				UIViewContentModeScaleAspectFit;
	lightImage.contentMode =		UIViewContentModeScaleAspectFit;
	stickImageView.contentMode =	UIViewContentModeScaleAspectFit;
	garlandImageView.contentMode =	UIViewContentModeScaleAspectFit;
	foodImageView.contentMode=		UIViewContentModeScaleAspectFit;
	
	//change width of frame
	CGRect frame = imageView.frame;
	frame.size.width =	320;
	frame.size.height = 480;
	imageView.frame =	frame;
	view2.frame =		frame;
	transitioning =		NO;
	
	
	// "Segmented" control to the right
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:
											 [UIImage imageNamed:@"bell.png"],
											 [UIImage imageNamed:@"noBell.png"],
											 nil]];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, kCustomButtonHeight);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	
	//defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
	
	
    
	self.navigationItem.rightBarButtonItem = segmentBarItem;
    [segmentBarItem release];
	
    [super viewDidLoad];
}



-(void)performTransition:(AVAudioPlayer *)p

{
	
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 1.50;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	transition.type = kCATransitionFade;
	transition.subtype = kCATransitionFromLeft;
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	transitioning = YES;
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[self.view.layer addAnimation:transition forKey:nil];
	
	// Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
	imageView.hidden = YES;
	view2.hidden = NO;
	
	// And so that we will continue to swap between our two images, we swap the instance variables referencing them.
	UIImage *tempimage;  
	
	if (nextImageNumber < 5) 
	{
		tempimage = [hopAnimation objectAtIndex:nextImageNumber];
		nextImageNumber++;
		
		
		
		
	}
	else 
	{
		tempimage = [hopAnimation objectAtIndex:0];
		nextImageNumber = 1;
		
	}
	
	imageView = view2;
	
	view2.image = tempimage;
	
	
}

- (void)updateCurrentTime
{
	
	if ((!pujaButtonSelected) && (isPlaying)) {
		[self performTransition:self.player];
	}
}
	

- (IBAction)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here 
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
	
	if (self.isPlaying) {
		
		if (segmentedControl.selectedSegmentIndex == 0) {
			[bellPlayer play];
			bellisPlaying = YES;
		}
		else {
			[bellPlayer stop];
			bellisPlaying = NO;
		}
	}
	
}


//Touch effects

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == self.lightImage)
	{
		lightImageSelected = YES;
		animateImageView = lightImage;
		garlandImageView.hidden = YES;
		stickImageView.hidden = YES;
		foodImageView.hidden = YES;
	}
	
	if ([touch view] == self.stickImageView)
	{
		stickImageSelected = YES;
		animateImageView = stickImageView;
		lightImage.hidden = YES;
		garlandImageView.hidden = YES;
		foodImageView.hidden = YES;
		
	}
	
	if ([touch view] == self.garlandImageView)
	{
		garlandImageSelected = YES;
		animateImageView = garlandImageView;
		lightImage.hidden = YES;
		stickImageView.hidden = YES;
		foodImageView.hidden = YES;
		
	}
	
	if ([touch view] == self.foodImageView) {
		foodImageSelected = YES;
		animateImageView = foodImageView;
		lightImage.hidden = YES;
		stickImageView.hidden = YES;
		garlandImageView.hidden = YES;
	}
	
	// Only move the view if the touch was in the following subview
	if ([touch view] != animateImageView) 
	{
		return;
	}
	
	
	// Animate the first touch
//	CGPoint touchPoint = [touch locationInView:self.view];
//	[self animateFirstTouchAtPoint:touchPoint];
	
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// If the touch was in the placardView, move the placardView to its location
	if ([touch view] == animateImageView) {
		CGPoint location = [touch locationInView:self.view];
		animateImageView.center = location;		
		return;
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// If the touch was in the placardView, bounce it back to the center
	if ([touch view] == animateImageView) {
		// Disable user interaction so subsequent touches don't interfere with animation
		self.view.userInteractionEnabled = NO;
		[self animatePlacardViewToCenter];
		return;
	}		
}


//Animation control

- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint {
	/*
	 "Pulse" the placard view by scaling up then down, then move the placard to under the finger.
	 
	 This illustrates using UIView's built-in animation.  We want, though, to animate the same property (transform) twice -- first to scale up, then to shrink.  You can't animate the same property more than once using the built-in animation -- the last one wins.  So we'll set a delegate action to be invoked after the first animation has finished.  It will complete the sequence.
	 Note that we can pass information -- in this case, the using the context.  The context needs to be a pointer. A convenient way to pass a CGPoint here is to wrap it in an NSValue object.  However, the value returned from valueWithCGPoint is autoreleased.  Normally this wouldn't be an issue because typically if you need to use the value later you store it as an instance variable using an accessor method that retains it, or pass it to another object which retains it.  In this case, though, it's being passed as a void * parameter, and it's not retained by the UIView class.  By the time the delegate method is called, therefore, the autorelease pool will have been popped and the value would no longer be valid.  To address this problem, retain the value here, and release it in the delegate method.
	 */
	
	
#define GROW_ANIMATION_DURATION_SECONDS 0.50
	
	NSValue *touchPointValue = [[NSValue valueWithCGPoint:touchPoint] retain];
	[UIView beginAnimations:nil context:touchPointValue];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.5, 1.5);
	animateImageView.transform = transform;
	[UIView commitAnimations];
}


- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	
#define MOVE_ANIMATION_DURATION_SECONDS 0.50
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS];
	animateImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);	
	/*
	 Move the animateImageView to under the touch.
	 We passed the location wrapped in an NSValue as the context.
	 Get the point from the value, then release the value because we retained it in touchesBegan:withEvent:.
	 */
	NSValue *touchPointValue = (NSValue *)context;
	animateImageView.center = [touchPointValue CGPointValue];
	[touchPointValue release];
	[UIView commitAnimations];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	/*
     To impose as little impact on the device as possible, simply set the placard view's center and transformation to the original values.
     */
	animateImageView.center = self.view.center;
	animateImageView.transform = CGAffineTransformIdentity;
}


- (void)animatePlacardViewToCenter {
	
	// Bounces the placard back to the center
	
	CALayer *welcomeLayer = animateImageView.layer;
	
	// Create a keyframe animation to follow a path back to the center
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	bounceAnimation.removedOnCompletion = NO;
	
	CGFloat animationDuration = 1.5;
	
	
	// Create the path for the bounces
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGFloat midX,midY;
	
	if (lightImageSelected)
	{
		
		midX = 24; //self.view.center.x;
		midY = 350; // self.view.center.y;
	}
	if(stickImageSelected)
	{
		midX = 98; //self.view.center.x;
		midY = 350; // self.view.center.y;
		
	}
	if (garlandImageSelected)
	{
		midX = 172; //self.view.center.x;
		midY = 350; // self.view.center.y;
	}
	if (foodImageSelected) {
		midX = 246; //self.view.center.x;
		midY = 350; // self.view.center.y;
	}
	
	
	CGFloat originalOffsetX = animateImageView.center.x - midX;
	CGFloat originalOffsetY = animateImageView.center.y - midY;
	CGFloat offsetDivider = 4.0;
	
	BOOL stopBouncing = NO;
	
	// Start the path at the placard's current location
	CGPathMoveToPoint(thePath, NULL,animateImageView.center.x, animateImageView.center.y);
	CGPathAddLineToPoint(thePath, NULL, midX, midY);
	
	// Add to the bounce path in decreasing excursions from the center
	while (stopBouncing != YES) {
		CGPathAddLineToPoint(thePath, NULL, midX + originalOffsetX/offsetDivider, midY + originalOffsetY/offsetDivider);
		CGPathAddLineToPoint(thePath, NULL, midX, midY);
		
		offsetDivider += 4;
		animationDuration += 1/offsetDivider;
		if ((abs(originalOffsetX/offsetDivider) < 6) && (abs(originalOffsetY/offsetDivider) < 6)) {
			stopBouncing = YES;
		}
	}
	
	bounceAnimation.path = thePath;
	bounceAnimation.duration = animationDuration;
	CGPathRelease(thePath);
	
	// Create a basic animation to restore the size of the placard
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	transformAnimation.removedOnCompletion = YES;
	transformAnimation.duration = animationDuration;
	transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
	
	
	// Create an animation group to combine the keyframe and basic animations
	CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	
	// Set self as the delegate to allow for a callback to reenable user interaction
	theGroup.delegate = self;
	theGroup.duration = animationDuration;
	theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	
	theGroup.animations = [NSArray arrayWithObjects:bounceAnimation, transformAnimation, nil];
	
	
	// Add the animation group to the layer
	[welcomeLayer addAnimation:theGroup forKey:@"animatePlacardViewToCenter"];
	
	// Set the placard view's center and transformation to the original values in preparation for the end of the animation
	//	lightImage.center = self.view.center;
	CGRect animationFrame = CGRectMake(midX, midY, ImageWidth, ImageHeight);
	animateImageView.frame = animationFrame;
	animateImageView.transform = CGAffineTransformIdentity;
	
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	//Animation delegate method called when the animation's finished:
	// restore the transform and reenable user interaction
	animateImageView.transform = CGAffineTransformIdentity;
	self.view.userInteractionEnabled = YES;
	
	
	if (pujaButtonSelected)
	{
		lightImage.hidden = NO;
		stickImageView.hidden=NO;
		garlandImageView.hidden=NO;
		foodImageView.hidden=NO;
		lightImageSelected = NO;
		stickImageSelected = NO;
		garlandImageSelected = NO;
		foodImageSelected = NO;
	}
	
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


-(void)viewDidDisappear:(BOOL)animated { 
	if (self.parentViewController == nil) 
	{ 
		self.lightImage = nil;
		self.stickImageView = nil;
		self.garlandImageView = nil;
		self.foodImageView = nil;
		if (animateImageView)
			self.animateImageView = nil;
		
		
		
		[player stop];
		[player release];
		
		[bellPlayer stop];
		[bellPlayer release];
		
		self.imageView = nil;
		self.view2 = nil;
		
		
	} 
	
}

- (void)dealloc {
	
	[pujaButton release];
	
	[lightImage release];
	[stickImageView release];
	[garlandImageView release];
	[foodImageView release];
	if (animateImageView)
		[animateImageView release];
	
	[imageView release];
	[view2 release];
	[hopAnimation release];
	[updateTimer release];
	
	
	

    [super	 dealloc];
}

- (IBAction)play{
	
	if (player.playing == NO) 
	{

		[self startPlaybackForPlayer: player];
		
		
	}
	
}


-(IBAction)pause{
	
	if (player.playing == YES) 
	{
	
		[self pausePlaybackForPlayer: player];

	}
	

}

-(IBAction)stop{
	
	
	if (self.isPlaying = YES)
	{
		[self stopPlaybackForPlayer:player];
	}
}

- (IBAction)pujaButtonPressed:(id)sender{
	
	
	if(!pujaButtonSelected)
	{
		
		transitioning =		NO;
		
		nextImageNumber = 1 ;
		view2.image = [hopAnimation objectAtIndex:0];
		lightImage.hidden = NO;
		stickImageView.hidden=NO;
		garlandImageView.hidden=NO;
		foodImageView.hidden=NO;
		pujaButtonSelected = YES;
		
	}
	else
	{
		lightImage.hidden = YES;
		stickImageView.hidden=YES;
		garlandImageView.hidden=YES;
		foodImageView.hidden=YES;
		pujaButtonSelected = NO;
		
	}
	
}

- (void)initMusicView
{
	NSDictionary *item = [resourceData objectAtIndex:rowNumber];
	NSString* type = [item objectForKey:@"songType"];
	NSString* songName =  [item objectForKey:@"songName"];
	
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:songName ofType:type]];
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];	
	
	if (self.player)
	{	
		[self.player prepareToPlay];
  		self.player.numberOfLoops = 0;
		player.delegate = self;
	}
	
	OSStatus result = AudioSessionInitialize(NULL, NULL, NULL, NULL);
	if (result)
		NSLog(@"Error initializing audio session! %d", result);
	
	[[AVAudioSession sharedInstance] setDelegate: self];
	NSError *setCategoryError = nil;
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
	if (setCategoryError)
		NSLog(@"Error setting category! %d", setCategoryError);
	
	result = AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange, RouteChangeListener, self);
	if (result) 
		NSLog(@"Could not add property listener! %d", result);
	
	
	[fileURL release];
	
	self.isPlaying = NO;
	// Load the array with the sample file
	NSURL *bellfileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"caf"]];
	self.bellPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bellfileURL error:nil];
	if(self.bellPlayer)
	{
		bellPlayer.numberOfLoops = -1;
		bellPlayer.delegate=self;
	}
	[bellfileURL release];
	
}
#pragma mark AudioSession handlers

-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p
{
	[p pause];
	 self.isPlaying = NO;
	[self updateViewForPlayerState:p];
	if (self.bellisPlaying)
	{
		[bellPlayer stop];
		bellisPlaying = NO;
	}
}

-(void)startPlaybackForPlayer:(AVAudioPlayer*)p
{
	[p play];
	self.isPlaying = YES;
	[self updateViewForPlayerState:p];
}


-(void)stopPlaybackForPlayer:(AVAudioPlayer*)p
{
	[p stop];
	[p setCurrentTime:0.];
	self.isPlaying = NO;
	
	
	//imageview loading
	imageView.image = [hopAnimation objectAtIndex:0];
	nextImageNumber = 1;
	
	//view2 loading
	view2.image = [hopAnimation objectAtIndex:nextImageNumber];
	view2.hidden = YES;
	imageView.hidden = NO;
	
	if (pujaButtonSelected)
	{
		lightImage.hidden = YES;
		stickImageView.hidden=YES;
		garlandImageView.hidden=YES;
		foodImageView.hidden=YES;
		pujaButtonSelected = NO;
		lightImageSelected = NO;
		stickImageSelected = NO;
		garlandImageSelected = NO;
		foodImageSelected = NO;
		
	}
	
	
	pujaButtonSelected = NO;
	transitioning = NO;
	
	if (self.bellisPlaying)
	{
		[bellPlayer stop];
		bellisPlaying = NO;
	}
	

}


#pragma mark AVAudioPlayer delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
	if (flag == NO)
		NSLog(@"Playback finished unsuccessfully");
	
	[self stopPlaybackForPlayer:player];
	[bellPlayer stop];
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)p error:(NSError *)error
{
	NSLog(@"ERROR IN DECODE: %@\n", error); 
	[self stopPlaybackForPlayer:player];
	[bellPlayer stop];
}

// we will only get these notifications if playback was interrupted
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p
{
	NSLog(@"Interruption begin. Updating UI for new state");
	
	[self updateViewForPlayerState:p];
	
	
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)p
{
	NSLog(@"Interruption ended. Resuming playback");
	[self startPlaybackForPlayer:p];
}

#pragma mark background notifications
- (void)registerForBackgroundNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setInBackgroundFlag)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(clearInBackgroundFlag)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}


void RouteChangeListener(	void *                  inClientData,
						 AudioSessionPropertyID	inID,
						 UInt32                  inDataSize,
						 const void *            inData)
{
	musicViewController* This = (musicViewController*)inClientData;
	
	if (inID == kAudioSessionProperty_AudioRouteChange) {
		
		CFDictionaryRef routeDict = (CFDictionaryRef)inData;
		NSNumber* reasonValue = (NSNumber*)CFDictionaryGetValue(routeDict, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		
		int reason = [reasonValue intValue];
		
		if (reason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
			
			[This pausePlaybackForPlayer:This.player];
		}
	}
}



@end
