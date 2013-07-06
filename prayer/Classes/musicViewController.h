//
//  musicViewController.h
//  prayer
//
//  Created by Suman Chatterjee on 24/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface musicViewController : UIViewController <AVAudioPlayerDelegate> 
{
	
	

	IBOutlet UIBarButtonItem			*pujaButton;
	UIImageView							*imageView;
	UIImageView							*view2;
	UIImageView							*lightImage;
	UIImageView							*stickImageView;
	UIImageView							*garlandImageView;
	UIImageView							*foodImageView;
	UIImageView							*animateImageView;
	
	BOOL								transitioning;
	int									rowNumber;
	
	NSArray								*hopAnimation;
	
	int									nextImageNumber;
	
	NSTimer								*updateTimer;
	
	AVAudioPlayer						*player;
	AVAudioPlayer						*bellPlayer;
	BOOL								inBackground;
	BOOL								bellisPlaying;
	BOOL								pujaButtonSelected;
	BOOL								lightImageSelected;
	BOOL								stickImageSelected;
	BOOL								garlandImageSelected;
	BOOL								foodImageSelected;
	
	
	NSMutableArray						*resourceData;
	
	BOOL								isPlaying;


}

@property (nonatomic,retain) IBOutlet UIBarButtonItem			*pujaButton;

@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL bellisPlaying;
@property (nonatomic,assign) BOOL pujaButtonSelected;
@property (nonatomic,assign) BOOL lightImageSelected;
@property (nonatomic,assign) BOOL stickImageSelected;
@property (nonatomic,assign) BOOL garlandImageSelected;
@property (nonatomic,assign) BOOL foodImageSelected;

@property (nonatomic,assign) int  rowNumber;

@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UIImageView *lightImage;
@property (nonatomic,retain) UIImageView *view2;
@property (nonatomic,retain) UIImageView *stickImageView;
@property (nonatomic,retain) UIImageView *garlandImageView;
@property (nonatomic,retain) UIImageView *foodImageView;
@property (nonatomic,retain) UIImageView *animateImageView;


@property (nonatomic, retain)AVAudioPlayer	*player;
@property (nonatomic,retain) AVAudioPlayer *bellPlayer;


@property (nonatomic,assign) NSMutableArray	*resourceData;

@property (nonatomic,retain)NSArray	*hopAnimation;
@property (nonatomic,assign)NSTimer * updateTimer;


-(void)stopPlaybackForPlayer:(AVAudioPlayer*)p;
-(void)startPlaybackForPlayer:(AVAudioPlayer*)p;
-(void)pausePlaybackForPlayer:(AVAudioPlayer*)p;
- (IBAction)pujaButtonPressed:(id)sender;
- (IBAction)segmentAction:(id)sender;
- (void)initMusicView;
- (IBAction)play;
- (IBAction)pause;
- (IBAction)stop;
- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint;
- (void)animatePlacardViewToCenter;





@end
