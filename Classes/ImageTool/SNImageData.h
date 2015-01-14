//
//  SNImageData.h
//  hideHere
//
//  Created by sonson on 08/11/01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum SNImageDataFormat {
	kSNImage32bitRGBA,
	kSNImage32bitBGRA,
	kSNImage32bitARGB,
	kSNImage32bitABGR,
	kSNImage32bitPreRGBA,
	kSNImage32bitPreBGRA,
	kSNImage32bitPreARGB,
	kSNImage32bitPreABGR,
	kSNImage32bitRGBD,
	kSNImage32bitBGRD,
	kSNImage32bitDRGB,
	kSNImage32bitDBGR,
	kSNImage16bitDRGB,
//	kSNImage32bitCYMK,
	kSNImageUnsupported
};
typedef enum SNImageDataFormat SNImageDataFormat;

@interface SNImageData : NSObject {
	size_t				width_;
	size_t				height_;
	size_t				bit_;
	size_t				bytesPerRow_;
	size_t				component_;
	SNImageDataFormat	format_;
	CGImageAlphaInfo	alphaInfo_;
	NSData*				pixelAsNSData_;
	UIImageOrientation	orientation_;
}
@property (nonatomic, readonly) NSData* pixelAsNSData;
@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) size_t bytesPerRow;
@property (nonatomic, assign) SNImageDataFormat format;
@property (nonatomic, assign) UIImageOrientation orientation;

#pragma mark -
#pragma mark Size accessor
- (CGSize) size;
- (CGSize) sizeAccodingToOrientation;
#pragma mark -
#pragma mark class method
+ (SNImageDataFormat) checkFormat:(CGImageRef)image;
+ (BOOL) isReableImage:(CGImageRef)image;
+ (SNImageData*) imageDataWithImage:(UIImage*)originalUIImage;
+ (CGPoint)	adjustPoint:(CGPoint)point accordingAsImageData:(SNImageData*)imageData;
#pragma mark -
#pragma mark original method
- (id) initDataWithImage:(UIImage*)originalUIImage;

@end
