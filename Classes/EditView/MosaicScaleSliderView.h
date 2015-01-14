//
//  MosaicScaleSliderView.h
//  hideHere
//
//  Created by sonson on 10/07/02.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MosaicScaleSliderView : UIView {
	UISlider	*slider;
	UILabel		*mosaicValueLabel;
}
- (void)updateLabel:(int)value;
- (void)sliderChanged:(id)sender;
- (void)show;
@end
