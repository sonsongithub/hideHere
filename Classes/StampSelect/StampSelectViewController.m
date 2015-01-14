//
//  StampSelectViewController.m
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StampSelectViewController.h"
#import "UIAlertViewSingleField.h"
#import "Stamp.h"
#import "StampSelectFooterView.h"
#import "StampSelectViewCell.h"
#import "StampNameEditViewController.h"

// Tool
#import "UIImage+OptimizedPNG.h"

@implementation StampSelectViewController

@synthesize fetchedResultsController, managedObjectContext;
@synthesize stamps;
@synthesize stampSelectViewCell;

#pragma mark -
#pragma mark Original

- (void)pushCancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)addStampOfURLAfterDelay:(NSString*)URLString {
	[self addStampOfURL:URLString];
	[URLString release];
}

- (void)addStampOfURL:(NSString*)URLString {
	
	NSData *originalImageData = nil;
	NSData *thumbnailData = nil;
	
	[UIAppDelegate openHUDOfString:NSLocalizedString(@"Loading...", nil)];
	
	[NSThread sleepForTimeInterval:0.5];
	BOOL result = [Stamp downloadFromURLString:URLString originalImageData:&originalImageData thumbnailData:&thumbnailData];
	
	if (result) {
		//
		// Create a new instance of the entity managed by the fetched results controller.
		//
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
		NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
		
		//
		// New stamp data
		//
		Stamp* newStamp = (Stamp*)newManagedObject;
		newStamp.name = URLString;
		// Make hash string which is used as image file name
		newStamp.stampHash = [Stamp hashFromURLString:URLString];
		newStamp.thumbnailData = thumbnailData;
		[newStamp writeImageData:originalImageData];
		newStamp.displayOrder = [NSNumber numberWithInteger:[self.stamps count]];
		[self.stamps addObject:newStamp];
		
		//
		// Save the context
		//
		NSError *error;
		if (![context save:&error]) {
			// Handle the error...
		}
	}
	[UIAppDelegate closeHUD];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Override

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	
	//
	// Default delegate method to edit mode, UITableViewController
	//	
	[self.tableView beginUpdates];
	
	int rows = [self.stamps count];
	
	NSArray *ingredientsInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:rows inSection:0]];
    if (editing) {
		self.title = NSLocalizedString(@"Edit Stamp", nil);
        [self.tableView insertRowsAtIndexPaths:ingredientsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
	}
	else {
		self.title = NSLocalizedString(@"Select Stamp", nil);
        [self.tableView deleteRowsAtIndexPaths:ingredientsInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.tableView endUpdates];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//
	// Update title
	//
	self.title = NSLocalizedString(@"Select Stamp", nil);
	
	//
	// Obtain object from CoreData
	//
	NSArray *objects = [fetchedResultsController fetchedObjects];
	self.stamps = [NSMutableArray arrayWithArray:objects];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[self.stamps sortUsingDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
	//
	// Update
	//
    [self.tableView reloadData];
	
	//
	//
	//
	StampSelectFooterView *footer = [StampSelectFooterView view];
	self.tableView.tableFooterView = footer;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	//
	// Add stamp if UIAppDelegate has a new stamp URL
	//
	if ([UIAppDelegate.imageURL length] > 0) {
		[self addStampOfURL:UIAppDelegate.imageURL];
		
		// release a new stamp URL
		UIAppDelegate.imageURL = nil;
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	managedObjectContext = UIAppDelegate.managedObjectContext;
	
	// Set up the edit and add buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
	UIBarButtonItem *cancelButtom = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(pushCancel:)];
	self.navigationItem.rightBarButtonItem = cancelButtom;
	[cancelButtom release];
	
	self.tableView.allowsSelectionDuringEditing = YES;
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Handle the error...
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([alertView isKindOfClass:[UIAlertViewSingleField class]]) {
		if (buttonIndex == 1) {
			UIAlertViewSingleField *view = (UIAlertViewSingleField*)alertView;
			NSString *url = [NSString stringWithString:view.urlField.text];
			[self performSelector:@selector(addStampOfURLAfterDelay:) withObject:[url retain] afterDelay:0.0];
		}
	}
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.editing) {
		return [self.stamps count] + 1;
	}
	return [self.stamps count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
	if (indexPath.row == [self.stamps count]) {
		static NSString *CellIdentifier = @"Cell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.textLabel.text = NSLocalizedString(@"Add new stamp", nil);
		cell.imageView.image = nil;
		return cell;
	}
	else {
		static NSString *CellIdentifier2 = @"Cell2";
		StampSelectViewCell *cell = (StampSelectViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"StampSelectViewCell" owner:self options:nil];
			cell = stampSelectViewCell;
			self.stampSelectViewCell = nil;
		}
		Stamp *stamp = [self.stamps objectAtIndex:indexPath.row];
		cell.stampName.text = stamp.name;
		cell.thumbnailView.image = stamp.thumbnail;
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DNSLogMethod
	
	int rows = [self.stamps count];
	
	if (indexPath.row < rows) {
		if (!self.editing) {
			Stamp *stamp = [self.stamps objectAtIndex:indexPath.row];
			UIAppDelegate.stamp = stamp;
			[self dismissModalViewControllerAnimated:YES];
		}
		else {
			StampNameEditViewController* con = [[StampNameEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
			con.stamp = [self.stamps objectAtIndex:indexPath.row];
			con.fetchedResultsController = fetchedResultsController;
			[self.navigationController pushViewController:con animated:YES];
			[con release];
		}
	}
	else {
		UIAlertViewSingleField *alert = [[UIAlertViewSingleField alloc] initWithTitle:NSLocalizedString(@"Input stamp URL", nil) delegate:self];
		alert.urlField.text = @"http://son-son.sakura.ne.jp/stamp/";
		alert.delegate = self;
		[alert show];
		[alert release];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -
#pragma mark Edit - UITableViewDelegate, UITableViewDataSource

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {	
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
	
	if (indexPath.row == [self.stamps count]) {
		style = UITableViewCellEditingStyleInsert;
	}
	else {
		style = UITableViewCellEditingStyleDelete;
	}
    return style;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		//
		// Delete the managed object for the given index path
		//
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		Stamp *stampToDelete = [self.stamps objectAtIndex:indexPath.row];
		[context deleteObject:stampToDelete];
		[self.stamps removeObject:stampToDelete];
        
		//
		// Save the context.
		//
		NSError *error;
		if (![context save:&error]) {
			// Handle the error...
		}
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

#pragma mark -
#pragma mark Move - UITableViewDelegate, UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.stamps count]) {
		return NO;
	}
	else {
		return YES;
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	if (proposedDestinationIndexPath.row == [self.stamps count]) {
		return [NSIndexPath indexPathForRow:[self.stamps count]-1 inSection:0];
	}
	return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	//
	// Order objects in array
	//
	Stamp *stamp = [self.stamps objectAtIndex:fromIndexPath.row];
	[stamp retain];
    [self.stamps removeObjectAtIndex:fromIndexPath.row];
    [self.stamps insertObject:stamp atIndex:toIndexPath.row];
	[stamp release];
	
	NSInteger start = fromIndexPath.row;
	if (toIndexPath.row < start) {
		start = toIndexPath.row;
	}
	NSInteger end = toIndexPath.row;
	if (fromIndexPath.row > end) {
		end = fromIndexPath.row;
	}
	for (NSInteger i = start; i <= end; i++) {
		Stamp *stamp = [self.stamps objectAtIndex:i];
		stamp.displayOrder = [NSNumber numberWithInteger:i];
	}
	NSError *error;
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	if (![context save:&error]) {
		// Handle the error...
	}
}

#pragma mark -
#pragma mark Original method

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    /*
	 Set up the fetched results controller.
	 */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Stamp" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];

	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	fetchedResultsController = aFetchedResultsController;
	
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[stamps release];
    [super dealloc];
}

@end

