//
//  EditViewController.m
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"
#import "MosaicView.h"
#import "StampSelectNavigationController.h"
#import "AppSettingsNavigationController.h"

#import "Stamp.h"
#import "MosaicScaleSliderView.h"

// Image data
#import "SNImageData.h"

// Tool
#import "UIImage+Resize.h"

// for TwitPic
#import "TwitPicPostController.h"

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

typedef enum {
	ActionSheetConfirmCloseWithoutSave,
	ActionSheetConfirmSave,
	ActionSheetSelectAction,
}ActionSheetType;

CGRect makeCircumscribedQuad( CGPoint p1, CGPoint p2 ) {
	CGRect result = CGRectMake( 0, 0, 0, 0 );
	
	result.origin.x = p1.x < p2.x ? p1.x : p2.x;
	result.origin.y = p1.y < p2.y ? p1.y : p2.y;
	result.size.width = abs( p1.x - p2.x );
	result.size.height = abs( p1.y - p2.y );
	return result;
}

@interface EditViewController (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation EditViewController

#pragma mark -
#pragma mark Update UI

- (void)updateSegmentControllerToSelectStamp {
	//
	// Update segment controller according to current selected stamp
	//
	DNSLogMethod
	if (UIAppDelegate.stamp == nil) {
		[segmentedController setTitle:NSLocalizedString(@"stamp", nil) forSegmentAtIndex:1];
		[segmentedController setSelectedSegmentIndex:0];
		mode = EditingWithMosaic;
	}
	else {
		[segmentedController setImage:[UIImage reduceUIImage:UIAppDelegate.stamp.image maximumSize:20] forSegmentAtIndex:1];
	}
}

- (void)updateTitle {
	//
	// Update title accroding to whether stamp or mosaic and whether edit or scroll
	//
	if (regionSelectDelegateView.hidden == NO) {
		//
		// Now edit mode
		//
		if (mode == EditingWithStamp) {
			self.title = NSLocalizedString(@"Edit:Stamp", nil);
		}
		else if (mode == EditingWithStamp) {
			self.title = NSLocalizedString(@"Edit:Mosaic", nil);
		}
		else {
			self.title = NSLocalizedString(@"Edit", nil);
		}
		
		//
		// Set tint colors of navigationbar and toolbar and segment controller
		//
		self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2];
		self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
		segmentedController.tintColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2];
		[self setToolbarItems:scrollingUIToolbarItems animated:YES];
	}
	else {
		//
		// Now scroll mode
		//
		self.title = NSLocalizedString(@"Scroll", nil);
		//
		// Set tint colors of navigationbar and toolbar and segment controller
		//
		self.navigationController.navigationBar.tintColor = nil;
		self.navigationController.toolbar.barStyle = UIBarStyleDefault;
		segmentedController.tintColor = nil;
		[self setToolbarItems:pointingUIToolbarItems animated:YES];
	}
}

#pragma mark -
#pragma mark UIBarButtonItem Delegate

- (void)undo:(id)sender {
	//
	// Management undo buffer
	//
	UIView *view = [undoBuffer lastObject];
	[view removeFromSuperview];
	[redoBuffer addObject:view];
	[undoBuffer removeLastObject];
	[self updateUndoAndRedoButton];
}

- (void)redo:(id)sender {
	//
	// Management redo buffer
	//
	UIView *view = [redoBuffer lastObject];
	[imageView addSubview:view];
	[redoBuffer removeLastObject];
	[undoBuffer addObject:view];
	[self updateUndoAndRedoButton];
}

- (void)edit:(id)sender {
	//
	// When starting edit mode, show the view to select region
	//
	regionSelectDelegateView.hidden = NO;
	[self updateTitle];
}

- (void)cancelEdit:(id)sender {
	//
	// When cancelled, hide the view to select region
	//
	regionSelectDelegateView.hidden = YES;
	[self updateTitle];
}

- (void) close:(id)sender {
	if( [redoBuffer count] != redoBuffCountLastSaving || [undoBuffer count] != undoBuffCountLastSaving ) {
		//
		// open
		//
		UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString( @"AreYouSureExitWithoutSave", nil ) delegate:self
												  cancelButtonTitle:NSLocalizedString( @"Cancel", nil )
											 destructiveButtonTitle:NSLocalizedString( @"Destruct", nil )
												  otherButtonTitles:nil];
		[sheet showInView:UIAppDelegate.window];
		sheet.tag = ActionSheetConfirmCloseWithoutSave;
		[sheet release];
	}
	else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)save:(id)sender {
	//
	// open
	//
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
										 destructiveButtonTitle:nil
											  otherButtonTitles:NSLocalizedString(@"Save", nil), nil];
	[sheet showInView:UIAppDelegate.window];
	sheet.tag = ActionSheetConfirmSave;
	[sheet release];
}

- (void)action:(id)sender {
	
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
										 destructiveButtonTitle:nil
											  otherButtonTitles:NSLocalizedString(@"Email Photo", nil), NSLocalizedString(@"Twitter", nil), nil];
	[sheet showInView:UIAppDelegate.window];
	sheet.tag = ActionSheetSelectAction;
}

- (void)scale:(id)sender {
	MosaicScaleSliderView *view = [[MosaicScaleSliderView alloc] init];
	[view show];
	[view release];
}

#pragma mark -
#pragma mark Save and Sending Action

- (void)saveImage {
	[UIAppDelegate openHUDOfString:NSLocalizedString(@"Saving...", nil)];
	[NSThread sleepForTimeInterval:0.2];
	
	UIGraphicsBeginImageContext( [imageData sizeAccodingToOrientation] );
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    [imageView.layer renderInContext:ctx];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	
	undoBuffCountLastSaving = [undoBuffer count];
	redoBuffCountLastSaving = [redoBuffer count];
}

- (void)emailPhoto {
	DNSLog(@"Start to compose e-mail");
	//
	// Mail composer
	//
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	//
	// Make image binary
	//
	UIGraphicsBeginImageContext( [imageData sizeAccodingToOrientation] );
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[imageView.layer renderInContext:ctx];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	NSData *imageBinary = UIImageJPEGRepresentation(newImage, 0.5);
	
	//
	// Attach an image to the email
	//
	[picker addAttachmentData:imageBinary mimeType:@"image/jpg" fileName:@"picture"];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

- (void)twitPicture {
	DNSLogMethod
	if ([TwitPicPostController enabledTwitterAccount]) {
		
		//
		// Make image binary
		//
		UIGraphicsBeginImageContext( [imageData sizeAccodingToOrientation] );
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		[imageView.layer renderInContext:ctx];
		UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		NSData *imageBinary = UIImageJPEGRepresentation(newImage, 0.5);
		
		[[TwitPicPostController sharedInstance] tweet:[NSDictionary dictionaryWithObject:imageBinary forKey:@"imageBinary"]];
	}
	else {
		UIAlertView *view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"hideHere", nil)
													   message:NSLocalizedString(@"Please fill out twitter acount info on Setting view.", nil) 
													  delegate:self
											 cancelButtonTitle:nil
											 otherButtonTitles:NSLocalizedString(@"OK", nil), NSLocalizedString(@"Open Setting", nil), nil];
		view.tag = EditViewAlertTwitterFillout;
		[view show];
		[view release];
	}
}

#pragma mark -
#pragma mark UIToolbar Management

- (void)segmentChanged:(id)sender {
	DNSLogMethod
	UISegmentedControl *con = (UISegmentedControl*)sender;
	if (con.selectedSegmentIndex == 0) {
		//
		// Mosaic
		//
		mode = EditingWithMosaic;
		[scale_button setEnabled:YES];
	}
	else if (con.selectedSegmentIndex == 1) {
		//
		// Stamp
		//
		StampSelectNavigationController *con = [StampSelectNavigationController defaultController];
		[self presentModalViewController:con animated:YES];
		mode = EditingWithStamp;
		[scale_button setEnabled:NO];
	}
	[self updateTitle];
}

- (void) allocButtonItemsOfUIToolbar {
	//
	// Setup UIToolbar
	//
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem* undo_button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"undo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(undo:)];
	UIBarButtonItem* redo_button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"redo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(redo:)];
	UIBarButtonItem* pointing_button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pointing.png"] style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
	UIBarButtonItem* scroll_button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scroll.png"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelEdit:)];
	UIBarButtonItem* action_button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
	scale_button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scale.png"] style:UIBarButtonItemStylePlain target:self action:@selector(scale:)];
	
	NSArray *segments = [[NSArray alloc] initWithObjects:NSLocalizedString( @"mosaic", nil), NSLocalizedString( @"stamp", nil), nil];
	segmentedController = [[UISegmentedControl alloc] initWithItems:segments];
	segmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentedController addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
	
	[segmentedController setSelectedSegmentIndex:0];
	UIBarButtonItem *segment_button = [[UIBarButtonItem alloc] initWithCustomView:segmentedController];
	[segments release];
	
	scrollingUIToolbarItems = [[NSArray arrayWithObjects:action_button, flexibleSpace, undo_button, flexibleSpace, redo_button, flexibleSpace, scale_button, flexibleSpace, scroll_button, flexibleSpace, segment_button, nil] retain];
	pointingUIToolbarItems = [[NSArray arrayWithObjects:action_button, flexibleSpace, undo_button, flexibleSpace, redo_button, flexibleSpace, scale_button, flexibleSpace, pointing_button, flexibleSpace, segment_button, nil] retain];
	
	undoButton = undo_button;
	redoButton = redo_button;
	
	[segmentedController release];
	[segment_button release];
	[undo_button release];
	[redo_button release];
	[pointing_button release];
	[scroll_button release];
	[action_button release];
	[flexibleSpace release];
}

- (void)updateUndoAndRedoButton {
	//
	// Set enabled according to undo and redo buffer remained
	//
	redoButton.enabled = [redoBuffer count] > 0 ? YES : NO;
	undoButton.enabled = [undoBuffer count] > 0 ? YES : NO;
}

#pragma mark -
#pragma mark Override

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage*)image {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		//
		// Setup UI
		//
		[self allocButtonItemsOfUIToolbar];
		self.navigationController.navigationBar.translucent = NO;
		self.view.backgroundColor = [UIColor clearColor];
		
		//
		// set up main scroll view
		//
		CGRect viewRect = [[self view] bounds];
		// set offset for UIToolbar and navigationbar
		viewRect.size.height -= 88;
		
		//
		// background view which has a check pattern.
		//
		backCheckerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkers.png"]];
		backCheckerImageView.frame = viewRect;
		[[self view] addSubview:backCheckerImageView];
		
		//
		// Scroll view
		//
		imageScrollView = [[UIScrollView alloc] initWithFrame:viewRect];
		[imageScrollView setBackgroundColor:[UIColor blackColor]];
		[imageScrollView setDelegate:self];
		[imageScrollView setBouncesZoom:YES];
		[[self view] addSubview:imageScrollView];
		imageScrollView.backgroundColor = [UIColor clearColor];
		
		//
		// View contains image to edit
		// Add touch-sensitive image view to the scroll view
		//
		imageView = [[TapDetectingImageView alloc] initWithImage:image];
		[imageView setDelegate:self];
		[imageView setTag:ZOOM_VIEW_TAG];
		[imageScrollView setContentSize:[imageView frame].size];
		[imageScrollView addSubview:imageView];
		[imageView release];
		
		//
		// Calculate minimum scale to perfectly fit image width, and begin at that scale
		// Set scale
		//
		float minimumScale = [imageScrollView frame].size.width  / [imageView frame].size.width;
		[imageScrollView setMinimumZoomScale:minimumScale];
		[imageScrollView setMaximumZoomScale:minimumScale * 10];
		[imageScrollView setZoomScale:minimumScale];
		
		regionSelectDelegateView = [[RegionSelectDelegateView alloc] initWithFrame:viewRect];
		[self.view addSubview:regionSelectDelegateView];
		//regionSelectDelegateView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
		regionSelectDelegateView.backgroundColor = [UIColor clearColor];
		regionSelectDelegateView.hidden = YES;
		regionSelectDelegateView.delegate = self;
		
		//
		// Prepare undo & redo buffer, UIToolbar
		//
		redoBuffer = [[NSMutableArray array] retain];
		undoBuffer = [[NSMutableArray array] retain];
		undoBuffCountLastSaving = 0;
		redoBuffCountLastSaving = 0;
		[self updateUndoAndRedoButton];
		
		//
		// Alloc image data
		//
		imageData = [[SNImageData imageDataWithImage:image] retain];
		
		//
		// Edit mode
		//
		mode = EditingWithMosaic;
	}
	return self;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.tintColor = nil;
	self.navigationController.toolbar.barStyle = UIBarStyleDefault;
	segmentedController.tintColor = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[self updateTitle];
	[self.navigationController setToolbarHidden:NO animated:YES];
	[self updateSegmentControllerToSelectStamp];
	
	UIBarButtonItem*	saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString( @"Save", nil) 
																	style:UIBarButtonItemStylePlain 
																   target:self 
																   action:@selector(save:)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem*	closeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString( @"Close", nil) 
																	style:UIBarButtonItemStylePlain 
																   target:self 
																   action:@selector(close:)];
	self.navigationItem.leftBarButtonItem = closeButton;
	[closeButton release];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	DNSLogMethod
	[imageData release];
	[undoBuffer release];
	[redoBuffer release];
	[scrollingUIToolbarItems release];
	[pointingUIToolbarItems release];
	[regionSelectDelegateView release];
	[backCheckerImageView release];
    [imageScrollView release];
    [super dealloc];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error  {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (alertView.tag == EditViewAlertTwitterFillout) {
		if (buttonIndex == 0) {
		}
		else if (buttonIndex == 1) {
			DNSLogMethod
			AppSettingsNavigationController *nav = [AppSettingsNavigationController defaultController];
			[self presentModalViewController:nav animated:YES];
		}
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == ActionSheetConfirmCloseWithoutSave) {
		if (buttonIndex == 0) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	else if (actionSheet.tag == ActionSheetConfirmSave) {
		if (buttonIndex == 0) {
			[self saveImage];
		}
	}
	else if (actionSheet.tag == ActionSheetSelectAction) {
		if (buttonIndex == 0) {
			[self emailPhoto];
		}
		if (buttonIndex == 1) {
			[self twitPicture];
		}
	}
}

#pragma mark -
#pragma mark Selector for UIImage saving

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	DNSLogMethod
	
	[UIAppDelegate closeHUD];
	
	NSString *title = nil;
	NSString *message = nil;
	if (error != nil) {
		title = NSLocalizedString(@"Error", nil);
		message = [error localizedDescription];
		UIAlertView *view = [[UIAlertView alloc] initWithTitle:title
													   message:message 
													  delegate:nil
											 cancelButtonTitle:nil
											 otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
		[view show];
		[view release];
	}
	else {
		title = NSLocalizedString(@"Image has been saved.", nil);
		UIAlertView *view = [[UIAlertView alloc] initWithTitle:title
													   message:message 
													  delegate:self
											 cancelButtonTitle:nil
											 otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
		[view show];
		[view release];
	}
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [imageScrollView viewWithTag:ZOOM_VIEW_TAG];
}

/************************************** NOTE **************************************/
/* The following delegate method works around a known bug in zoomToRect:animated: */
/* In the next release after 3.0 this workaround will no longer be necessary      */
/**********************************************************************************/
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark -
#pragma mark TapDetectingImageViewDelegate methods

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
    // single tap does nothing for now
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
    // double tap zooms in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark -
#pragma mark RegionSelectDelegate

- (CGRect)adjustRectInsideSafeRegion:(CGRect)rect {
	if( rect.origin.x < 1 ) {
		rect.origin.x = 0;
	}
	if( rect.origin.y < 1 ) {
		rect.origin.y = 0;
	}
	if( rect.origin.x + rect.size.width > imageView.image.size.width - 1) {
		rect.size.width = (int)imageView.image.size.width - (int)rect.origin.x - 1;
	}
	if( rect.origin.y + rect.size.height > imageView.image.size.height - 1 ) {
		rect.size.height = (int)imageView.image.size.height - (int)rect.origin.y - 1;
	}
	return rect;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView*)view {
	DNSLogMethod
	
	if (mode == EditingWithMosaic) {
		stamp = [[MosaicView alloc] initWithFrame:CGRectZero];
		[imageView addSubview:stamp];
		[stamp release];
	}
	else if (mode == EditingWithStamp) {
		stamp = [[UIImageView alloc] initWithImage:UIAppDelegate.stamp.image];
		stamp.frame = CGRectZero;
		[imageView addSubview:stamp];
		[stamp release];
	}

	UITouch *touch = [touches anyObject];
	selectBeganPoint = [touch locationInView:imageView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView*)view {
	DNSLogMethod
	UITouch *touch = [touches anyObject];
	CGPoint new_point = [touch locationInView:imageView];
	
	CGRect rect = makeCircumscribedQuad( new_point, selectBeganPoint );
	stamp.frame = rect;
	
	rect = [self adjustRectInsideSafeRegion:rect];
	[stamp setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView*)view {
	DNSLogMethod
	UITouch *touch = [touches anyObject];
	CGPoint new_point = [touch locationInView:imageView];
	
	CGRect rect = makeCircumscribedQuad( new_point, selectBeganPoint );
	rect = [self adjustRectInsideSafeRegion:rect];
	stamp.frame = rect;
	
	
	if ([stamp isKindOfClass:[MosaicView class]]) {
		if ([(MosaicView*)stamp setMosaicWithImage:imageData rect:rect]) {
			[undoBuffer addObject:stamp];
			[redoBuffer removeAllObjects];
			[self updateUndoAndRedoButton];
			[stamp setNeedsDisplay];
		}
		else {
			[stamp removeFromSuperview];
			stamp = nil;
		}
	}
	else if ([stamp isKindOfClass:[UIImageView class]]) {
		[undoBuffer addObject:stamp];
		[redoBuffer removeAllObjects];
		[self updateUndoAndRedoButton];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView*)view {
	DNSLogMethod
}

#pragma mark -
#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

@end
