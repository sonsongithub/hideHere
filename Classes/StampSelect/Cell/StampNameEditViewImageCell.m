//
//  StampNameEditViewImageCell.m
//  hideHere
//
//  Created by sonson on 09/06/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StampNameEditViewImageCell.h"


@implementation StampNameEditViewImageCell

@synthesize stampImage;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[stampImage release];
    [super dealloc];
}


@end
