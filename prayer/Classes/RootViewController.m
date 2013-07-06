//
//  RootViewController.m
//  prayer
//
//  Created by Suman Chatterjee on 23/01/2011.
//  Copyright 2011 DreamApps Infotech. All rights reserved.
//

#import "RootViewController.h"
#import "musicViewController.h"
#import "mapViewDetails.h"
#import "songInfolist.h"

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
	self.tableView.opaque = NO;
	self.tableView.rowHeight =80;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
	[self createMainTableData];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	self.title =@"Daily Prayers ";
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor blueColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:20];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
	
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
	
	headerLabel.text =  @"test" ; // i.e. array element
	[customView addSubview:headerLabel];
	
	return customView;
}*/


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [mainTableSection count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[mainTableData objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	NSDictionary *item = (NSDictionary *)[[mainTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"name"];
    cell.detailTextLabel.text = [item objectForKey:@"smallname"];
	
	
	[[cell imageView] setImage:[UIImage imageNamed:[[[mainTableData objectAtIndex:indexPath.section] objectAtIndex: indexPath.row] objectForKey:@"picture"]]];
	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	
//	cell.textLabel.backgroundColor = [UIColor clearColor];
//	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	
	cell.backgroundColor = [UIColor blackColor];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [mainTableSection objectAtIndex:section];
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch(indexPath.section){
		case 0:
	   {
		
		musicViewController *musicviewcontroller = [[musicViewController alloc] initWithNibName:@"musicViewController" bundle:nil];
		musicviewcontroller.rowNumber = indexPath.row;
		
		[self.navigationController pushViewController:musicviewcontroller animated:YES];
		[musicviewcontroller release];
	   }
			break;
		case 1:
		{
			songInfolist *songInfolistcontroller =[[songInfolist alloc] initWithNibName:@"songInfolist" bundle:nil];
			[self.navigationController pushViewController:songInfolistcontroller animated:YES];
			[songInfolistcontroller release];

		}
			break;
		case 2:
		{
			mapViewDetails *mapviewcontroller = [[mapViewDetails alloc] initWithNibName:@"mapViewDetails" bundle:nil];
			[self.navigationController pushViewController:mapviewcontroller animated:YES];
			[mapviewcontroller release];
		}
			break;
		default:
			break;
	}

		
	}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[mainTableData release];
	[mainTableSection release];
    [super dealloc];
}

-(void)createMainTableData {
	
	NSMutableArray *dataForFirstSec;
	NSMutableArray *dataForSeconSec;
	NSMutableArray *dataForThirdSec;
	
	mainTableSection = [[NSMutableArray alloc] initWithObjects:
						@"Aarti",@"Songs",@"Nearest Tample",nil];

// 1st Sec
	dataForFirstSec = [[NSMutableArray alloc] init];
	
	[dataForFirstSec addObject:[[NSMutableDictionary alloc]
								initWithObjectsAndKeys:@"Shree Ganesh Aarti",@"name",
								@"Jai Ganesha Jai Ganesha Jai Ganesha Deva",@"smallname",
								@"Image_1.png",@"picture",nil]];
	
	[dataForFirstSec addObject:[[NSMutableDictionary alloc]
								initWithObjectsAndKeys:@"The Universal Aarti",@"name",
								@"Om Jaya Jagadheesha Hare",@"smallname",
								@"Image_3.png",@"picture",nil]];
//2nd sec
	dataForSeconSec = [[NSMutableArray alloc] init];
	
	[dataForSeconSec addObject:[[NSMutableDictionary alloc]
								initWithObjectsAndKeys:@"Various Songs",@"name",
								@"Devotional songs in youtube ..",@"smallname",
								@"youtube.png",@"picture",nil]];

//3rd Sec
	dataForThirdSec = [[NSMutableArray alloc] init];
	
	[dataForThirdSec addObject:[[NSMutableDictionary alloc]
								initWithObjectsAndKeys:@"Tample",@"name",
								@"Find your nearest tample..",@"smallname",
								@"temple.png",@"picture",nil]];
	
	mainTableData = [[NSMutableArray alloc] initWithObjects:dataForFirstSec,dataForSeconSec,dataForThirdSec,nil];
	
	[dataForFirstSec release];
	[dataForSeconSec release];
	[dataForThirdSec release];
	
}




@end

