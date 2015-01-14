//
//  RegionSelectDelegateView.h
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegionSelectDelegate <NSObject>
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView*)view;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView*)view;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView*)view;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event inView:(UIView*)view;
@end

@interface RegionSelectDelegateView : UIView {
	id		delegate;
	BOOL	dragging;
}
@property (nonatomic, assign) id <RegionSelectDelegate> delegate;
@end
