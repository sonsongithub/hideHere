//
//  SNAlertViewAccountInput.h
//  alertView
//
//  Created by sonson on 09/04/06.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIAlertViewSingleField : UIAlertView {
	UITextField	*urlField;
}
@property (nonatomic, retain) UITextField *urlField;
- (id)initWithTitle:(NSString*)title delegate:(id)aDelegate;
@end
