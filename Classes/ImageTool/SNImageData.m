//
//  SNImageData.m
//  hideHere
//
//  Created by sonson on 08/11/01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SNImageData.h"

void displayAlphaInfo(CGImageAlphaInfo info) {
	DNSLog(@"displayAlphaInfo, %X", info);
	if (info == kCGImageAlphaNone) {
		DNSLog(@"kCGImageAlphaNone");
	}
	if (info == kCGImageAlphaPremultipliedLast) {
		DNSLog(@"kCGImageAlphaPremultipliedLast");
	}
	if (info == kCGImageAlphaPremultipliedFirst) {
		DNSLog(@"kCGImageAlphaPremultipliedFirst");
	}
	if (info == kCGImageAlphaLast) {
		DNSLog(@"kCGImageAlphaLast");
	}
	if (info == kCGImageAlphaFirst) {
		DNSLog(@"kCGImageAlphaFirst");
	}
	if (info == kCGImageAlphaNoneSkipLast) {
		DNSLog(@"kCGImageAlphaNoneSkipLast");
	}
	if (info == kCGImageAlphaNoneSkipFirst) {
		DNSLog(@"kCGImageAlphaNoneSkipFirst");
	}
}

void displayBitmapInfo(CGBitmapInfo info) {
	CGBitmapInfo alpha = info & kCGBitmapAlphaInfoMask;
	CGBitmapInfo byteOrder = info & kCGBitmapByteOrderMask;
	DNSLog(@"displayBitmapInfo, %X", info);
	if (alpha == kCGBitmapFloatComponents) {
		DNSLog(@"kCGBitmapAlphaInfoMask");
	}
	
	if (byteOrder == kCGBitmapByteOrderDefault) {
		DNSLog(@"kCGBitmapByteOrderDefault");
	}
	else if (byteOrder == kCGBitmapByteOrder16Little) {
		DNSLog(@"kCGBitmapByteOrder16Little");
	}
	else if (byteOrder == kCGBitmapByteOrder32Little) {
		DNSLog(@"kCGBitmapByteOrder32Little");
	}
	else if (byteOrder == kCGBitmapByteOrder16Big) {
		DNSLog(@"kCGBitmapByteOrder16Big");
	}
	else if (byteOrder == kCGBitmapByteOrder32Big) {
		DNSLog(@"kCGBitmapByteOrder32Big");
	}
}

SNImageDataFormat checkFormat( size_t bit, CGImageAlphaInfo alphaInfo, CGBitmapInfo info) {
	displayBitmapInfo(info);
	
//	CGBitmapInfo alpha = info & kCGBitmapAlphaInfoMask;
	CGBitmapInfo byteOrder = info & kCGBitmapByteOrderMask;
	
	// info -> 1 big endian
	// info -> 5 little endian
	if (bit != 32) {
		DNSLog(@"kSNImageUnsupported");
		return kSNImageUnsupported;
	}
	
	if (byteOrder == kCGBitmapByteOrderDefault | byteOrder == kCGBitmapByteOrder32Big) {
		if(alphaInfo == kCGImageAlphaFirst | alphaInfo == kCGImageAlphaPremultipliedFirst | alphaInfo == kCGImageAlphaNoneSkipFirst) {
			return kSNImage32bitARGB;
		}
		else if(alphaInfo == kCGImageAlphaLast | alphaInfo == kCGImageAlphaPremultipliedLast | alphaInfo == kCGImageAlphaNoneSkipLast) {
			return kSNImage32bitRGBA;
		}
		else if(alphaInfo == kCGImageAlphaNone) {
		}
	}
	else if (byteOrder == kCGBitmapByteOrder32Little) {
		if(alphaInfo == kCGImageAlphaFirst | alphaInfo == kCGImageAlphaPremultipliedFirst | alphaInfo == kCGImageAlphaNoneSkipFirst) {
			return kSNImage32bitBGRA;
		}
		else if(alphaInfo == kCGImageAlphaLast | alphaInfo == kCGImageAlphaPremultipliedLast | alphaInfo == kCGImageAlphaNoneSkipLast) {
			return kSNImage32bitABGR;
		}
		else if(alphaInfo == kCGImageAlphaNone) {
		}
	}
/*	
	else if (byteOrder == kCGBitmapByteOrder16Big) {
		if( alphaInfo == kCGImageAlphaNoneSkipFirst ) {
			// return kSNImage16bitDBGR;
		}
	}
	else if (byteOrder == kCGBitmapByteOrder16Little) {
		if( alphaInfo == kCGImageAlphaNoneSkipFirst ) {
			return kSNImage16bitDRGB;
		}
	}
*/
	DNSLog(@"kSNImageUnsupported");
	return kSNImageUnsupported;
}

@implementation SNImageData

@synthesize format = format_;
@synthesize pixelAsNSData = pixelAsNSData_;
@synthesize bytesPerRow = bytesPerRow_;
@synthesize orientation = orientation_;

#pragma mark -
#pragma mark Size accessor

- (CGSize) size {
	return CGSizeMake( width_, height_ );
}

- (CGSize) sizeAccodingToOrientation {
	if( self.orientation == UIImageOrientationUp || self.orientation == UIImageOrientationDown ) {
		return CGSizeMake( width_, height_ );
	}
	else if( self.orientation == UIImageOrientationLeft || self.orientation == UIImageOrientationRight ) {
		return CGSizeMake( height_, width_ );
	}
	else
		return CGSizeMake( width_, height_ );
}

#pragma mark -
#pragma mark class method

+ (SNImageDataFormat) checkFormat:(CGImageRef)image {
	size_t bit = CGImageGetBitsPerPixel( image );
	CGBitmapInfo info = CGImageGetBitmapInfo(image);
	displayBitmapInfo(info);
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo( image );
	
	return checkFormat( bit, alphaInfo, info );
}

+ (BOOL) isReableImage:(CGImageRef)image {
	size_t bit = CGImageGetBitsPerPixel( image );
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo( image );
	CGBitmapInfo info = CGImageGetBitmapInfo(image);
	
	SNImageDataFormat imageFormat = checkFormat( bit, alphaInfo, info);
	if( imageFormat == kSNImageUnsupported )
		return NO;
	return YES;
}

+ (SNImageData*) imageDataWithImage:(UIImage*)originalUIImage {
	CGImageRef originalImage = [originalUIImage CGImage];
	size_t bit = CGImageGetBitsPerPixel(originalImage);
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(originalImage);
	CGBitmapInfo info = CGImageGetBitmapInfo(originalImage);
	
	SNImageDataFormat imageFormat = checkFormat(bit, alphaInfo, info);
	if(imageFormat == kSNImageUnsupported) {
		return nil;
	}
	id obj = [[SNImageData alloc] initDataWithImage:originalUIImage];
	return [obj autorelease];;
}

+ (CGPoint)	adjustPoint:(CGPoint)point accordingAsImageData:(SNImageData*)imageData {
	CGPoint adjustedPoint = point;
	
	if( imageData.orientation == UIImageOrientationUp ) {
		adjustedPoint = point;
	}
	else if( imageData.orientation == UIImageOrientationDown ) {
		adjustedPoint.x = point.x;
		adjustedPoint.y = imageData.size.height - point.y;
	}
	else if( imageData.orientation == UIImageOrientationLeft ) {
		adjustedPoint.x = imageData.size.width - point.y;
		adjustedPoint.y = imageData.size.height - ( imageData.size.height - point.x );
	}
	else if( imageData.orientation == UIImageOrientationRight ) {
		adjustedPoint.x = imageData.size.width - ( imageData.size.width - point.y );
		adjustedPoint.y = imageData.size.height - point.x;
	}
	return adjustedPoint;
}

#pragma mark -
#pragma mark original method

- (id) initDataWithImage:(UIImage*)originalUIImage {
	if( self = [super init] ) {
		DNSLog( @"initDataWithImage" );
		orientation_ = originalUIImage.imageOrientation;
		CGImageRef originalImage = [originalUIImage CGImage];
		bit_ = CGImageGetBitsPerPixel( originalImage );
		alphaInfo_ = CGImageGetAlphaInfo( originalImage );
		CGBitmapInfo info = CGImageGetBitmapInfo(originalImage);
		
		format_ = checkFormat( bit_, alphaInfo_, info );
		width_ = CGImageGetWidth(originalImage);
		height_ = CGImageGetHeight(originalImage);
		bytesPerRow_ = CGImageGetBytesPerRow( originalImage );
		component_ = CGImageGetBitsPerComponent( originalImage );

		CGDataProviderRef provider = CGImageGetDataProvider(originalImage);
		pixelAsNSData_ = (NSData*) CGDataProviderCopyData(provider);
		
#ifdef _DEBUG
		NSMutableArray* alphaMessages = [[NSMutableArray alloc] init];
		[alphaMessages addObject:@"kCGImageAlphaLast"];
		[alphaMessages addObject:@"kCGImageAlphaFirst"];
		[alphaMessages addObject:@"kCGImageAlphaPremultipliedLast"];
		[alphaMessages addObject:@"kCGImageAlphaPremultipliedFirst"];
		[alphaMessages addObject:@"kCGImageAlphaNoneSkipLast"];
		[alphaMessages addObject:@"kCGImageAlphaNoneSkipFirst"];
		[alphaMessages addObject:@"kCGImageAlphaNone"];
		
		NSMutableArray* orientationMessages = [[NSMutableArray alloc] init];
		[orientationMessages addObject:@"UIImageOrientationUp"];
		[orientationMessages addObject:@"UIImageOrientationDown"];
		[orientationMessages addObject:@"UIImageOrientationLeft"];
		[orientationMessages addObject:@"UIImageOrientationRight"];
		[orientationMessages addObject:@"UIImageOrientationUpMirrored"];
		[orientationMessages addObject:@"UIImageOrientationDownMirrored"];
		[orientationMessages addObject:@"UIImageOrientationLeftMirrored"];
		[orientationMessages addObject:@"UIImageOrientationRightMirrored"];
		
		DNSLog( @"--------------------------------------------------" );
		DNSLog( @"Image Info" );
		DNSLog( @"Width             %d", width_ );
		DNSLog( @"Height            %d", height_ );
		DNSLog( @"Bytes per row     %d", bytesPerRow_ );
		DNSLog( @"Bits per Compnent %d", component_ );
		DNSLog( @"Bits per Pixel    %d", bit_ );
//		DNSLog( @"Alpha Info        %@", [alphaMessages objectAtIndex:alphaInfo_] );
		displayAlphaInfo(alphaInfo_);
		DNSLog( @"Orientation       %@", [orientationMessages objectAtIndex:orientation_] );
		DNSLog( @"--------------------------------------------------" );
		
		[orientationMessages release];
		[alphaMessages release];
#endif
	}
	return self;
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	[pixelAsNSData_ release];
	[super dealloc];
}

@end
