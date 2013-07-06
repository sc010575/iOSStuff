//
//  pinDetailView.h
//  prayer
//
//  Created by Suman Chatterjee on 30/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface pinDetailView : UIViewController {
	
	IBOutlet UIWebView* webView;
	IBOutlet UILabel *addressLable;
	IBOutlet UILabel *phoneLable;
	IBOutlet UIButton *BtPhoneCall;
	IBOutlet UIButton *BtDirection;
	
	CLLocationCoordinate2D destcoordinate;
	CLLocationCoordinate2D sourcecoordinate;

	NSURL *detailURL;
 	
	NSString *address;
	NSString *phone;

}

@property (nonatomic,assign) CLLocationCoordinate2D destcoordinate;
@property (nonatomic,assign) CLLocationCoordinate2D sourcecoordinate;

@property(nonatomic,assign) NSString *address;
@property(nonatomic,assign) NSString *phone;
@property(nonatomic,retain) NSURL *detailURL;
@property(nonatomic,retain) IBOutlet UIButton *BtPhoneCall;
@property(nonatomic,retain) IBOutlet UIButton *BtDirection;
@property(nonatomic,retain) IBOutlet UILabel *addressLable;
@property(nonatomic,retain) IBOutlet UILabel *phoneLable;
@property(nonatomic,retain) IBOutlet UIWebView * webView;

-(IBAction)doPhoneCall:(id)sender;
-(IBAction)doMapDirection:(id)sender;

@end
