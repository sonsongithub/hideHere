//
//  AppSettingsNavigationController.h
//  2tch
//
//  Created by sonson on 10/07/20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IASKAppSettingsViewController.h"

@interface AppSettingsNavigationController : UINavigationController <IASKSettingsDelegate> {
    IASKAppSettingsViewController *appSettingsViewController;
}
@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;
+ (AppSettingsNavigationController*)defaultController;
@end
