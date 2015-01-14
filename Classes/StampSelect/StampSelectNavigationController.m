//
//  StampSelectNavigationController.m
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StampSelectNavigationController.h"
#import "StampSelectViewController.h"

@implementation StampSelectNavigationController

+ (StampSelectNavigationController*)defaultController {
	StampSelectViewController* viewCon = [[StampSelectViewController alloc] initWithStyle:UITableViewStyleGrouped];
	StampSelectNavigationController* naviCon = [[StampSelectNavigationController alloc] initWithRootViewController:viewCon];
	[viewCon release];
	return [naviCon autorelease];
}

- (void)dealloc {
    [super dealloc];
}


@end
