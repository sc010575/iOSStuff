//
//  VimeoReaderViewController.h
//  VimeoReader
//
//  Created by Suman Chatterjee on 27/06/2012.
//  Copyright 2012 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VimeoHelper;
@class VideoList;
@class GTMOAuthAuthentication;
@class GTMOAuthViewControllerTouch;

@interface VimeoReaderViewController : UIViewController {
	
	IBOutlet UIButton *videoButton;
	IBOutlet UIButton *signInButton;
	VimeoHelper *vmHelper;
	NSMutableArray *videoList;
	VideoList *vdList;
	GTMOAuthAuthentication *mAuth;


}

-(IBAction) videoButtonPressed:(id)sender;
-(IBAction) signInButtonPressed:(id)sender;
-(void)signInToVimeo;
-(void)signOut;
- (BOOL)isSignedIn;
- (GTMOAuthAuthentication *)authForVimeo;
- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error;
- (void)setAuthentication:(GTMOAuthAuthentication *)auth;
- (void)updateUI;
-(GTMOAuthAuthentication*)getAuthentication;

@property (nonatomic,retain)UIButton *videoButton;
@property (nonatomic,retain)UIButton *signInButton;
@property (nonatomic,retain)VimeoHelper *vmHelper;
@property (nonatomic,retain)NSMutableArray *videoList;
@property (nonatomic,retain)VideoList *vdList;


@end

