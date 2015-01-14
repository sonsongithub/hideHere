//
//  StampSelectViewCell.h
//  hideHere
//
//  Created by sonson on 09/06/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StampSelectViewCell : UITableViewCell {
    IBOutlet UILabel *stampName;
    IBOutlet UIImageView *thumbnailView;
}
@property (nonatomic, retain) IBOutlet UILabel *stampName;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailView;
@end
