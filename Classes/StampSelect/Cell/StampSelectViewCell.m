//
//  StampSelectViewCell.m
//  hideHere
//
//  Created by sonson on 09/06/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StampSelectViewCell.h"


@implementation StampSelectViewCell

@synthesize stampName, thumbnailView;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	stampName.highlighted = selected;
}


- (void)dealloc {
	[stampName release];
	[thumbnailView release];
    [super dealloc];
}


@end
