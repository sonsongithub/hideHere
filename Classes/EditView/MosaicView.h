//
//  CoveringView.h
//  hideHere
//
//  Created by sonson on 08/11/01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_MOSAIC_RATIO_PARAM 25

@class SNImageData;

@interface MosaicView : UIView {
	int				mosaic_size;
	float			mosaic_setting_value;
	CGImageRef		image;
	
	BOOL			isSetMosaic;
}
- (unsigned char*) extractImageOfkSNImage16bitDRGB:(SNImageData*)imageData rect:(CGRect)rect;
- (unsigned char*) extractImageOfkSNImage32bitRGBA:(SNImageData*)imageData rect:(CGRect)rect;
- (unsigned char*) extractImageOfkSNImage32bitARGB:(SNImageData*)imageData rect:(CGRect)rect;
- (BOOL) setMosaicWithImage:(SNImageData*)imageData rect:(CGRect)rect;
@end