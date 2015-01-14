//
//  StampNameEditViewCell.m
//  hideHere
//
//  Created by sonson on 09/06/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StampNameEditViewCell.h"


@implementation StampNameEditViewCell

@synthesize textField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    //if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[textField release];
    [super dealloc];
}


@end
