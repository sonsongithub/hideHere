//
//  RegionSelectDelegateView.m
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RegionSelectDelegateView.h"

@implementation RegionSelectDelegateView

@synthesize delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    DNSLogMethod
	[delegate touchesBegan:touches withEvent:event inView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    DNSLogMethod
	[delegate touchesMoved:touches withEvent:event inView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    DNSLogMethod
	[delegate touchesEnded:touches withEvent:event inView:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    DNSLogMethod
	[delegate touchesCancelled:touches withEvent:event inView:self];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
