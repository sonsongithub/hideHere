//
//  EditViewController.h
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "TapDetectingImageView.h"
#import "RegionSelectDelegateView.h"

@class SNImageData;

typedef enum {
	EditingWithUnknown,
	EditingWithMosaic,
	EditingWithStamp
}EditingMode;

typedef enum {
	EditViewAlertDefault		= 0,
	EditViewAlertTwitterFillout = 1,
}EditViewAlertType;

@interface EditViewController : UIViewController <UIScrollViewDelegate, TapDetectingImageViewDelegate, RegionSelectDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	//
	// Subview
	//
	UIImageView			*backCheckerImageView;
    UIScrollView		*imageScrollView;
	RegionSelectDelegateView *regionSelectDelegateView;
	TapDetectingImageView *imageView;
	
	//
	// Buttons for UIToolbar
	//
	NSArray				*scrollingUIToolbarItems;
	NSArray				*pointingUIToolbarItems;
	UIBarButtonItem		*undoButton;
	UIBarButtonItem		*redoButton;
	UIBarButtonItem		*scale_button;
	UISegmentedControl	*segmentedController;
	
	//
	// View for a stamp
	//
	CGPoint				selectBeganPoint;
	UIView				*stamp;
	
	//
	// Undo & redo buffer
	//
	NSMutableArray		*redoBuffer;
	NSMutableArray		*undoBuffer;
	int					undoBuffCountLastSaving;
	int					redoBuffCountLastSaving;
	
	//
	// Inputed image data
	//
	SNImageData			*imageData;
	
	//
	// Status
	//
	EditingMode			mode;
}

#pragma mark -
#pragma mark UIBarButtonItem Delegate
- (void)undo:(id)sender;
- (void)redo:(id)sender;
- (void)edit:(id)sender;
- (void)cancelEdit:(id)sender;
#pragma mark -
#pragma mark UIToolbar Management
- (void)segmentChanged:(id)sender;
- (void) allocButtonItemsOfUIToolbar;
- (void)updateUndoAndRedoButton;
#pragma mark -
#pragma mark Override
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage*)image;

@end
