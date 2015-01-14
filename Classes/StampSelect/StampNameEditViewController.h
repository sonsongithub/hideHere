//
//  StampNameEditViewController.h
//  hideHere
//
//  Created by sonson on 09/06/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Stamp;
@class StampNameEditViewImageCell;
@class StampNameEditViewCell;

@interface StampNameEditViewController : UITableViewController {
	Stamp						*stamp;
	StampNameEditViewImageCell	*stampNameEditViewImageCell;
	StampNameEditViewCell		*stampNameEditViewCell;
	NSFetchedResultsController	*fetchedResultsController;
	
	UITextField					*textField;
}
@property (nonatomic, retain) Stamp *stamp;
@property (nonatomic, assign) IBOutlet StampNameEditViewCell *stampNameEditViewCell;
@property (nonatomic, assign) IBOutlet StampNameEditViewImageCell *stampNameEditViewImageCell;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
