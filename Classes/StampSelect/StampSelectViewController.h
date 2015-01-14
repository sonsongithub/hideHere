//
//  StampSelectViewController.h
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StampSelectViewCell;

@interface StampSelectViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController	*fetchedResultsController;
	NSManagedObjectContext		*managedObjectContext;
	
	NSMutableArray				*stamps;
	StampSelectViewCell			*stampSelectViewCell;

}
@property (nonatomic, assign) NSFetchedResultsController	*fetchedResultsController;
@property (nonatomic, assign) NSManagedObjectContext		*managedObjectContext;
@property (nonatomic, retain) NSMutableArray				*stamps;

@property (nonatomic, assign) IBOutlet StampSelectViewCell	*stampSelectViewCell;

- (void)pushCancel:(id)sender;
- (void)addStampOfURLAfterDelay:(NSString*)URLString;
- (void)addStampOfURL:(NSString*)URLString;

@end
