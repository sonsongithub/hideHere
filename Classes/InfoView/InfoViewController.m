//
//  InfoViewController.m
//  2tch
//
//  Created by sonson on 09/07/21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "NSBundle+2tch.h"
#import "LicenseViewController.h"

NSString *kInfoViewTableUpdate = @"kInfoViewTableUpdate";

@implementation InfoViewController

#pragma mark -
#pragma mark Class method

+ (UINavigationController*)controllerWithNavigationController {
	InfoViewController* con = [[InfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
	[con release];
	return [nav autorelease];
}

#pragma mark -
#pragma mark Instance method

- (UITableViewCell *)tableView:(UITableView *)tableView obtainCellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = nil;
	UITableViewCellStyle style = UITableViewCellStyleDefault;
	UITextAlignment alignment = UITextAlignmentLeft;
	
	if (indexPath.section == 0) {
		if (indexPath.row < 3) {
			CellIdentifier = @"Attribute";
			style = UITableViewCellStyleValue1;
			alignment = UITextAlignmentLeft;
		}
		else {
			CellIdentifier = @"Centered";
			style = UITableViewCellStyleDefault;
			alignment = UITextAlignmentCenter;
		}
	}
	else if (indexPath.section == 1) {
		CellIdentifier = @"Centered";
		style = UITableViewCellStyleDefault;
		alignment = UITextAlignmentCenter;
	}
	else if (indexPath.section == 2) {
		CellIdentifier = @"Attribute";
		style = UITableViewCellStyleValue1;
		alignment = UITextAlignmentLeft;
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.textAlignment = alignment;
    }
	return cell;
}

#pragma mark -
#pragma mark Button callback

- (void)doneButton:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Override

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	
	self.title = NSLocalizedString(@"Info", nil);
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneButton:)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"BookmarkletURL", nil)]];
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	DNSLogMethod
	
	if (actionSheet.tag == 0) {
		if (buttonIndex == 0) {
			// Push mail button
			DNSLog(@"Compose new mail");
			//
			// Mail composer
			//
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
			picker.mailComposeDelegate = self;
			
			//
			// Attach an image to the email
			//
			[picker setSubject:NSLocalizedString(@"[hideHere contact] ", nil)];
			[picker setToRecipients:[NSArray arrayWithObject:NSLocalizedString(@"SupportMailAddress", nil)]];
			
			/*
			NSMutableString *body = [NSMutableString string];
			[body appendFormat:@"This is your iPhone's conditon and a private information. If you'd like to send your message without this information, remove the following system information."];
			[body appendFormat:@"\n\n%@ %@(r%@)\n", [NSBundle infoValueFromMainBundleForKey:@"CFBundleDisplayName"], [NSBundle infoValueFromMainBundleForKey:@"CFBundleVersion"], [NSBundle infoValueFromMainBundleForKey:@"CFBundleRevision"]];
			[body appendFormat:@"%@\n%@ %@", [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
			[picker setMessageBody:body isHTML:NO];
			*/
			[self presentModalViewController:picker animated:YES];
			[picker release];
		}
		else if (buttonIndex == 1) {
			// Push "open safari" button
			DNSLog(@"Open support site");
			NSURL *URL = [NSURL URLWithString:NSLocalizedString(@"WebSiteURL", nil)];
			[[UIApplication sharedApplication] openURL:URL];
		}
	}
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error  {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return NSLocalizedString(@"Application", nil);
	}
	if (section == 1) {
		return NSLocalizedString(@"Web", @"");
	}
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 5;
	}
	if (section == 1) {
		return 1;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView obtainCellForRowAtIndexPath:indexPath];
    
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"Name", nil);
			cell.detailTextLabel.text = [NSBundle infoValueFromMainBundleForKey:@"CFBundleDisplayName"];
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString(@"Version", nil);
#ifdef _DEBUG
			NSString *str = [NSString stringWithFormat:@"%@(r%@) Debug", [NSBundle infoValueFromMainBundleForKey:@"CFBundleVersion"], [NSBundle infoValueFromMainBundleForKey:@"CFBundleRevision"]];
#else
			NSString *str = [NSString stringWithFormat:@"%@(r%@)", [NSBundle infoValueFromMainBundleForKey:@"CFBundleVersion"], [NSBundle infoValueFromMainBundleForKey:@"CFBundleRevision"]];
#endif
			cell.detailTextLabel.text = str;
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		if (indexPath.row == 2) {
			cell.textLabel.text = NSLocalizedString(@"Copyright", nil);
			cell.detailTextLabel.text = NSLocalizedString(@"sonson", nil);
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		if (indexPath.row == 3) {
			cell.textLabel.text = NSLocalizedString(@"License", nil);
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		if (indexPath.row == 4) {
			cell.textLabel.text = NSLocalizedString(@"Contact", nil);
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString( @"GoToBookmarklet", nil );
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if (indexPath.section == 0) {
		if (indexPath.row == 3) {
			// Clicked "License"
			LicenseViewController *controller = [LicenseViewController defaultController];
			[self.navigationController pushViewController:controller animated:YES];
		}
		if (indexPath.row == 4) {
			// Clicked "Contact"
			UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Contact, please send unknown bugs or your feedback.", nil) 
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
												 destructiveButtonTitle:nil
													  otherButtonTitles:NSLocalizedString(@"Mail with Mail.app", nil), NSLocalizedString(@"Open Site with Safari", nil), nil];
			[sheet showFromToolbar:self.navigationController.toolbar];
			[sheet release];
			sheet.tag = 0;
		}
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			UIAlertView *view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bookmarklet", nil)
														   message:NSLocalizedString(@"Are you sure to setup Safari's bookmarklet?", nil)
														  delegate:self 
												 cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
												 otherButtonTitles:NSLocalizedString(@"Open Safari", nil), nil];
			[view show];
			[view release];
		}
	}
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	DNSLogMethod
    [super dealloc];
}

@end

