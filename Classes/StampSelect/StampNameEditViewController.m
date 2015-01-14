//
//  StampNameEditViewController.m
//  hideHere
//
//  Created by sonson on 09/06/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StampNameEditViewController.h"
#import "StampNameEditViewImageCell.h"
#import "StampNameEditViewCell.h"
#import "Stamp.h"

@implementation StampNameEditViewController

@synthesize stamp;
@synthesize stampNameEditViewImageCell;
@synthesize stampNameEditViewCell;
@synthesize fetchedResultsController;

#pragma mark -
#pragma mark Push button method

- (void)save:(id)sender {
	if ([textField.text length] > 0) {
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		stamp.name = textField.text;
		//
		// Save the context.
		//
		NSError *error;
		if (![context save:&error]) {
			// Handle the error...
		}
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.title = NSLocalizedString(@"Rename Stamp", nil);
	
	self.tableView.allowsSelection = NO;
	
	UIBarButtonItem*	saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString( @"Save", nil) 
																   style:UIBarButtonItemStylePlain 
																  target:self 
																  action:@selector(save:)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem*	cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString( @"Cancel", nil) 
																	style:UIBarButtonItemStylePlain 
																   target:self 
																   action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
}

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return 120;
	}
	return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
		static NSString *CellIdentifier2 = @"Cell0";
		StampNameEditViewImageCell *cell = (StampNameEditViewImageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"StampNameEditViewImageCell" owner:self options:nil];
			cell = stampNameEditViewImageCell;
			self.stampNameEditViewImageCell = nil;
		}
		cell.stampImage.image = stamp.image;
		return cell;
	}
	else  if (indexPath.row == 1) {
		static NSString *CellIdentifier2 = @"Cell1";
		StampNameEditViewCell *cell = (StampNameEditViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"StampNameEditViewCell" owner:self options:nil];
			cell = stampNameEditViewCell;
			self.stampNameEditViewCell = nil;
			cell.textField.text = stamp.name;
			textField = cell.textField;
			[cell.textField becomeFirstResponder];
		}
		return cell;
	}
	else {
		return nil;
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


- (void)dealloc {
	[fetchedResultsController release];
	[stamp release];
    [super dealloc];
}


@end

