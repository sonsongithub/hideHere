//
//  SNAlertViewAccountInput.m
//  alertView
//
//  Created by sonson on 09/04/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIAlertViewSingleField.h"


@implementation UIAlertViewSingleField

@synthesize urlField;

- (id)initWithTitle:(NSString*)title delegate:(id)aDelegate {
	if (self = [super initWithTitle:title message:@"\r" delegate:aDelegate cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil]) {
		[self setTransform:CGAffineTransformMakeTranslation(0, 100)];
		
		self.urlField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
		self.urlField.borderStyle = UITextBorderStyleRoundedRect;
		self.urlField.backgroundColor = [UIColor clearColor];
		self.urlField.autocapitalizationType = NO;
		[self addSubview:self.urlField];
		[self.urlField release];
		
		NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
		[nc addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
	}
	return self;
}

- (void)layoutSubviews {
	DNSLogMethod
	DNSLog(@"Origin %f,%f", self.frame.origin.x, self.frame.origin.y);
	DNSLog(@"Size %f,%f", self.frame.size.width, self.frame.size.height);
}

- (void)applicationDidBecomeActive:(NSNotification*)note {
	[self.urlField becomeFirstResponder];
}

- (void)applicationWillResignActive:(NSNotification*)note {
	[self.urlField resignFirstResponder];
}

- (void)show {
	[super show];
	[self.urlField becomeFirstResponder];
}

- (void)dealloc {
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[urlField release];
	[super dealloc];
}

@end
