    //
//  AppSettingsNavigationController.m
//  2tch
//
//  Created by sonson on 10/07/20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppSettingsNavigationController.h"

@implementation AppSettingsNavigationController

@synthesize appSettingsViewController;

+ (AppSettingsNavigationController*)defaultController {
	IASKAppSettingsViewController *con = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
	AppSettingsNavigationController *nav = [[AppSettingsNavigationController alloc] initWithRootViewController:con];
	[nav setAppSettingsViewController:con];
	[con setDelegate:nav];
	[con release];
	return [nav autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark -
#pragma mark IASKSettingsDelegate

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[appSettingsViewController release];
    [super dealloc];
}

@end
