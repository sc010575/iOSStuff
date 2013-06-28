//
//  MasterViewController.m
//  Monitise
//
//  Created by Chatterjee,Suman on 16/12/2012.
//  Copyright (c) 2012 Chatterjee,Suman. All rights reserved.
//


#import "RootViewController.h"
#import "DataRecord.h"
#import "CustomContent.h"
#import "DetailViewController.h"
#import "PictureDownloader.h"


#define kCustomRowHeight    120.0
#define kCustomRowCount     7
#define kImageIconSize 48

#pragma mark -
//Private extention
@interface RootViewController ()<UIScrollViewDelegate, PictureDownloaderDelegate>
{
	NSArray *entries;   // the main data model for our UITableView
    NSMutableDictionary *imageDownloadsInProgress;  // the set of PictureDownloader objects for each app
}

@property (strong, nonatomic) DetailViewController *detailViewController;


- (void)appImageDidLoad:(NSIndexPath *)indexPath;

- (void)startIconDownload:(DataRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation RootViewController

@synthesize entries;
@synthesize imageDownloadsInProgress;


#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.tableView.rowHeight = kCustomRowHeight;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

#pragma mark -
#pragma mark Table view creation (UITableViewDataSource)

// customize the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int count = [entries count];
	
	// ff there's no data yet, return enough rows to fill the screen
    if (count == 0)
	{
        return kCustomRowCount;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// customize the appearance of table view cells
	//
	static NSString *CellIdentifier = @"TableViewCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.entries count];
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:PlaceholderCellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
		cell.detailTextLabel.text = @"Loading…";
		
		return cell;
    }
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
        // Set up the cell...
        DataRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
         // Only load cached images; defer new downloads until scrolling ends
        if (!appRecord.picture)
        {
           [self startIconDownload:appRecord forIndexPath:indexPath];
           cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
        }
        else
        {
            cell.imageView.image = [PictureDownloader imageResize:appRecord.picture withSize:kImageIconSize ];
        }
        
        //create content view and setup
        CustomContent *contentView = [[[NSBundle mainBundle] loadNibNamed:@"CustomContent" owner:self options:nil] objectAtIndex:0];
        [contentView createView:appRecord];
        [cell.contentView addSubview:contentView];

    }
    
    return cell;
}

//call the configure function of the detail view 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        DataRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
        appRecord.picture = cell.imageView.image;

        [[segue destinationViewController] configureView:appRecord];
    }   
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(DataRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    PictureDownloader *pictureDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (pictureDownloader == nil)
    {
        pictureDownloader = [[PictureDownloader alloc] init];
        pictureDownloader.appRecord = appRecord;
        pictureDownloader.indexPathInTableView = indexPath;
        pictureDownloader.delegate = self;
        [imageDownloadsInProgress setObject:pictureDownloader forKey:indexPath];
        [pictureDownloader startDownload:kImageIconSize];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their picture yet
- (void)loadImagesForOnscreenRows
{
    if ([self.entries count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            DataRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
            
            if (!appRecord.picture)             {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    PictureDownloader *pictureDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (pictureDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:pictureDownloader.indexPathInTableView];
        // Display the newly loaded image
        cell.imageView.image = pictureDownloader.appRecord.picture;;
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end