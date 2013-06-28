//
//  DetailViewController.m
//  Monitise
//
//  Created by Chatterjee,Suman on 16/12/2012.
//  Copyright (c) 2012 Chatterjee,Suman. All rights reserved.
//

#import "DetailViewController.h"
#import "PictureDownloader.h"

//private extension
@interface DetailViewController ()
{
    PictureDownloader * pictureDownloader;
}

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *notes;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}



-(void) configureView:(DataRecord*)appRecord
{
    self.title = [NSString stringWithFormat:@"%@ %@",appRecord.firstName,appRecord.lastName];
    self.notes.text = appRecord.notes;
    pictureDownloader = [[PictureDownloader alloc] init];
    pictureDownloader.appRecord = appRecord;
    pictureDownloader.delegate = self;
    [pictureDownloader startDownload:200];
    [self.view setNeedsDisplay];
}


// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    if (pictureDownloader != nil)
    {
        // Display the newly loaded image
        self.picture.image = pictureDownloader.appRecord.picture;
    }
 
}

@end
