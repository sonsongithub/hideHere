//
//  MosaicScaleSliderView.m
//  hideHere
//
//  Created by sonson on 10/07/02.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MosaicScaleSliderView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@implementation MosaicScaleSliderView

#pragma mark -
#pragma mark Instance method

- (void)updateLabel:(int)value {
	NSString *string = [NSString stringWithFormat:NSLocalizedString(@"Mosaic size %d", nil), (int)value];
	[mosaicValueLabel setText:string];
	CGRect textRect = [mosaicValueLabel textRectForBounds:CGRectMake(0, 0, 200, 44) limitedToNumberOfLines:1];
	CGRect labelRect = mosaicValueLabel.frame;
	labelRect.size = textRect.size;
	[mosaicValueLabel setFrame:labelRect];
}

- (void)sliderChanged:(id)sender {
	if (slider == sender) {
		[self updateLabel:(int)[slider value]];
	}
}

- (void)show {
	[self setAlpha:0];
	int mosaicSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"MosaicSize"];
	[self updateLabel:mosaicSize];
	[slider setValue:mosaicSize];
	
	[[[UIApplication sharedApplication] keyWindow] addSubview:self];
	
	[UIView beginAnimations:@"" context:nil];
	[self setAlpha:1];
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark override

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[[NSUserDefaults standardUserDefaults] setInteger:(int)[slider value] forKey:@"MosaicSize"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[UIView beginAnimations:@"" context:nil];
	[self setAlpha:0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView commitAnimations];
}

- (id)init {
    if ((self = [super initWithFrame:CGRectMake(0, 20, 320, 460)])) {
        // Initialization code
		
		UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sliderPopup.png"]];
		[back setFrame:CGRectMake(0, 0, 320, 460)];
		[back setUserInteractionEnabled:YES];
		[self addSubview:back];
		[back release];
		
		slider = [[UISlider alloc] initWithFrame:CGRectMake(30, 330, 260, 44)];
		[slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:slider];
		[slider release];
		[slider setMinimumValue:10];
		[slider setMaximumValue:50];
		
		mosaicValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 310, 0, 030)];
		[mosaicValueLabel setFont:[UIFont boldSystemFontOfSize:18]];
		[self addSubview:mosaicValueLabel];
		[mosaicValueLabel release];
    }
    return self;
}

#pragma mark -
#pragma mark UIView animationDidStop of delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self removeFromSuperview];
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
    [super dealloc];
}

@end
