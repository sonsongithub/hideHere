//
//  RootViewController.m
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"
#import "TableViewCellSourceType.h"
#import "EditViewController.h"
#import "SNImageData.h"
#import "InfoViewController.h"
#import "StampSelectNavigationController.h"
#import "AppSettingsNavigationController.h"

// Tool
#import "UIImage+Resize.h"

@implementation RootViewController

@synthesize cellContainer;

#pragma mark -
#pragma mark Original method

- (void)pushInfo:(id)sender {
	UINavigationController *naviCon = [InfoViewController controllerWithNavigationController];
	[self presentModalViewController:naviCon animated:YES];
}

- (void)pushSetting:(id)sender {
	DNSLogMethod
	AppSettingsNavigationController *nav = [AppSettingsNavigationController defaultController];
	[self presentModalViewController:nav animated:YES];
}

#pragma mark -
#pragma mark Override

- (void)viewWillAppear:(BOOL)animated {
	self.title = NSLocalizedString(@"Select Source", nil);
	[self.navigationController setToolbarHidden:YES animated:YES];
	
	//
	// Add new stamp use StampSelectViewController
	//
	if ([UIAppDelegate.imageURL length] > 0) {
		StampSelectNavigationController *con = [StampSelectNavigationController defaultController];
		[self presentModalViewController:con animated:YES];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//
	// Check which source type is supported
	//
	UIImagePickerControllerSourceType types[] = {
		UIImagePickerControllerSourceTypeCamera,
		UIImagePickerControllerSourceTypePhotoLibrary,
		UIImagePickerControllerSourceTypeSavedPhotosAlbum,
	};
	
	//
	// Saved cells which are supported to container
	//
	self.cellContainer = [NSMutableArray array];
	if ([UIImagePickerController isSourceTypeAvailable:types[0]]) {
		[self.cellContainer addObject:cameraCell];
		cameraCell.textLabel.text = NSLocalizedString(@"Camera", nil);
		cameraCell.textLabel.font = [UIFont boldSystemFontOfSize:18];
		cameraCell.type = types[0];
	}
	if ([UIImagePickerController isSourceTypeAvailable:types[1]]) {
		[self.cellContainer addObject:photoAlbumsCell];
		photoAlbumsCell.textLabel.text = NSLocalizedString(@"Photo Album", nil);
		photoAlbumsCell.textLabel.font = [UIFont boldSystemFontOfSize:18];
		photoAlbumsCell.type = types[1];
	}
	if ([UIImagePickerController isSourceTypeAvailable:types[2]]) {
		[self.cellContainer addObject:savedPhotosCell];
		savedPhotosCell.textLabel.text = NSLocalizedString(@"Saved Photos", nil);
		savedPhotosCell.textLabel.font = [UIFont boldSystemFontOfSize:18];
		savedPhotosCell.type = types[2];
	}
	
	//
	// Reload table
	//
	[self.tableView reloadData];
	
	//
	// Setup button to open information view
	//
	UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Info", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(pushInfo:)];
	self.navigationItem.leftBarButtonItem = infoButton;
	[infoButton release];
	
	UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(pushSetting:)];
	self.navigationItem.rightBarButtonItem = settingButton;
	[settingButton release];
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellContainer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.cellContainer objectAtIndex:indexPath.row];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 66;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[aTableView deselectRowAtIndexPath:indexPath animated:NO];
	
	//
	// Open UIImagePicker
	//
	UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.editing = NO;
	
	//
	// Cell
	//
	TableViewCellSourceType *cell = [self.cellContainer objectAtIndex:indexPath.row];
	imagePickerController.sourceType = cell.type;
	[self presentModalViewController:imagePickerController animated:YES];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	DNSLogMethod
	
	[image retain];
	UIImage* resizedImage = image;
	if( [SNImageData checkFormat:image.CGImage] != kSNImage16bitDRGB )
		resizedImage = [UIImage reduceUIImage:image maximumSize:1024];
	
	if( ![SNImageData isReableImage:[resizedImage CGImage]] )
		return;
	[resizedImage retain];
	
	EditViewController* viewCon = [[EditViewController alloc] initWithNibName:nil bundle:nil image:resizedImage];
	[self.navigationController pushViewController:viewCon animated:YES];
	[viewCon release];
	
	[resizedImage release];
	[image release];
	
	
	[picker dismissModalViewControllerAnimated:YES];
	[picker release];
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	DNSLogMethod
	[picker dismissModalViewControllerAnimated:YES];
	[picker release];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}


@end

