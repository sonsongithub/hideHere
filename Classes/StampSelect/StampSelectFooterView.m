//
//  StampSelectFooterView.m
//  hideHere
//
//  Created by sonson on 09/06/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StampSelectFooterView.h"


@implementation StampSelectFooterView

+ (StampSelectFooterView*)view {
	StampSelectFooterView *view = [[StampSelectFooterView alloc] initWithFrame:CGRectZero];
	return [view autorelease];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.text = NSLocalizedString(@"You can add stamp via bookmarklet", nil);
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		self.backgroundColor = [UIColor clearColor];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);
		label.font = [UIFont boldSystemFontOfSize:14];
		
		label.numberOfLines = 10;
		CGRect labelFrame = [label textRectForBounds:CGRectMake(0, 0, 280, 200) limitedToNumberOfLines:10];
		CGRect footerFrame = CGRectMake(20, 0, 280, labelFrame.size.height + 20+20);
		labelFrame.origin.x = 0;
		labelFrame.origin.y = 20;
		
		label.frame = labelFrame;
		self.frame = footerFrame;
		
		[label release];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	DNSLogMethod
	UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil 
												   message:NSLocalizedString(@"Are you sure to open a bookmarklet instruction page?", nil) 
												  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
										 otherButtonTitles:NSLocalizedString(@"Open Safari", nil), nil];
	[view show];
	[view release];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
	}
	else if (buttonIndex == 1) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString( @"BookmarkletURL", @"")]];
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
