//
//  RootViewController.h
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@class TableViewCellSourceType;

@interface RootViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    IBOutlet TableViewCellSourceType	*cameraCell;
    IBOutlet TableViewCellSourceType	*photoAlbumsCell;
    IBOutlet TableViewCellSourceType	*savedPhotosCell;
    IBOutlet UITableView				*tableView;
	
	NSMutableArray					*cellContainer;
}
@property (nonatomic, retain) NSMutableArray *cellContainer;
@end
