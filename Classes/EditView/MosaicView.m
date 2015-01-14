//
//  CoveringView.m
//  hideHere
//
//  Created by sonson on 08/11/01.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MosaicView.h"
#import "SNImageData.h"

void FLProviderReleaseData ( void *info, const void *data, size_t size ) {
	DNSLog( @"FLProviderReleaseData" );
	free( (void*)data );
}

@implementation MosaicView

#pragma mark Original method

- (unsigned char*) extractImageOfkSNImage16bitDRGB:(SNImageData*)imageData rect:(CGRect)rect {
	unsigned char* target_pixel = (unsigned char*) malloc( sizeof(unsigned char) * rect.size.width * rect.size.height * 4 );
	unsigned char* source_pixel = (unsigned char*)[[imageData pixelAsNSData] bytes];
	int x,y;
	int width = rect.size.width;
	int height = rect.size.height;
	
	for( x = 0; x < width; x++ ) {
		for( y = 0; y < height; y++ ) {
			int tempx = rect.origin.x + x;
			int tempy = rect.origin.y + height - y;
			
			CGPoint adjusted = [SNImageData adjustPoint:CGPointMake( tempx, tempy ) accordingAsImageData:imageData];
			tempx = (int)adjusted.x - (int)adjusted.x % mosaic_size;
			tempy = (int)adjusted.y - (int)adjusted.y % mosaic_size;
			
			unsigned int *pp = (unsigned int *)(source_pixel + tempy * (int)imageData.bytesPerRow + 2 * tempx);
			
			unsigned int p = *pp;			
			unsigned char red = p & 0x1f;
			unsigned char blue = ( p >> 5 ) & 0x1f;
			unsigned char green = ( p >> 10 ) & 0x1f;
			unsigned char alpha = ( p >> 15 ) & 0x1f;
			
			red = 255 * ( (float)red / 31.0f) ;
			green = 255 * ( (float)green / 31.0f) ;
			blue = 255 * ( (float)blue / 31.0f) ;
			alpha = 255;
			
			*( target_pixel + y * width * 4 + 4 * x + 2 ) = red;
			*( target_pixel + y * width * 4 + 4 * x + 1 ) = blue;
			*( target_pixel + y * width * 4 + 4 * x + 0 ) = green;
			*( target_pixel + y * width * 4 + 4 * x + 3 ) = 255;
		}
	}
	return target_pixel;
}

- (unsigned char*) extractImageOfkSNImage32bitRGBA:(SNImageData*)imageData rect:(CGRect)rect {
	unsigned char* target_pixel = (unsigned char*) malloc( sizeof(unsigned char) * rect.size.width * rect.size.height * 4 );
	unsigned char* source_pixel = (unsigned char*)[[imageData pixelAsNSData] bytes];
	int x,y;
	int width = rect.size.width;
	int height = rect.size.height;
	int tempx, tempy;
	for( x = 0; x < width; x++ ) {
		for( y = 0; y < height; y++ ) {
			tempx = rect.origin.x + x;
			tempy = rect.origin.y + height - y;
			
			CGPoint adjusted = [SNImageData adjustPoint:CGPointMake( tempx, tempy ) accordingAsImageData:imageData];
			tempx = (int)adjusted.x - (int)adjusted.x % mosaic_size;
			tempy = (int)adjusted.y - (int)adjusted.y % mosaic_size;

			unsigned char red =   *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 0 );
			unsigned char green = *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 1 );
			unsigned char blue =  *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 2 );
			// unsigned char alpha = *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 3 );
			
			*( target_pixel + y * width * 4 + 4 * x + 0 ) = red;
			*( target_pixel + y * width * 4 + 4 * x + 1 ) = green;
			*( target_pixel + y * width * 4 + 4 * x + 2 ) = blue;
			*( target_pixel + y * width * 4 + 4 * x + 3 ) = 255;
		}
	}
	return target_pixel;
}

- (unsigned char*) extractImageOfkSNImage32bitARGB:(SNImageData*)imageData rect:(CGRect)rect {
	unsigned char* target_pixel = (unsigned char*) malloc( sizeof(unsigned char) * rect.size.width * rect.size.height * 4 );
	unsigned char* source_pixel = (unsigned char*)[[imageData pixelAsNSData] bytes];
	int x,y;
	int width = rect.size.width;
	int height = rect.size.height;
	int tempx, tempy;
	for( x = 0; x < width; x++ ) {
		for( y = 0; y < height; y++ ) {
			tempx = rect.origin.x + x;
			tempy = rect.origin.y + height - y;
			
			CGPoint adjusted = [SNImageData adjustPoint:CGPointMake( tempx, tempy ) accordingAsImageData:imageData];
			tempx = (int)adjusted.x - (int)adjusted.x % mosaic_size;
			tempy = (int)adjusted.y - (int)adjusted.y % mosaic_size;

			unsigned char red =   *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 1 );
			unsigned char green = *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 2 );
			unsigned char blue =  *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 3 );
			// unsigned char alpha = *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 0 );
			
			*( target_pixel + y * width * 4 + 4 * x + 0 ) = red;
			*( target_pixel + y * width * 4 + 4 * x + 1 ) = green;
			*( target_pixel + y * width * 4 + 4 * x + 2 ) = blue;
			*( target_pixel + y * width * 4 + 4 * x + 3 ) = 255;
		}
	}
	return target_pixel;
}

- (unsigned char*) extractImageOfkSNImage32bitBGRA:(SNImageData*)imageData rect:(CGRect)rect {
	unsigned char* target_pixel = (unsigned char*) malloc( sizeof(unsigned char) * rect.size.width * rect.size.height * 4 );
	unsigned char* source_pixel = (unsigned char*)[[imageData pixelAsNSData] bytes];
	int x,y;
	int width = rect.size.width;
	int height = rect.size.height;
	int tempx, tempy;
	for( x = 0; x < width; x++ ) {
		for( y = 0; y < height; y++ ) {
			tempx = rect.origin.x + x;
			tempy = rect.origin.y + height - y;
			
			CGPoint adjusted = [SNImageData adjustPoint:CGPointMake( tempx, tempy ) accordingAsImageData:imageData];
			tempx = (int)adjusted.x - (int)adjusted.x % mosaic_size;
			tempy = (int)adjusted.y - (int)adjusted.y % mosaic_size;
			
			unsigned char red =   *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 2 );
			unsigned char green = *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 1 );
			unsigned char blue =  *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 0 );
			// unsigned char alpha = *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 3 );
			
			*( target_pixel + y * width * 4 + 4 * x + 0 ) = red;
			*( target_pixel + y * width * 4 + 4 * x + 1 ) = green;
			*( target_pixel + y * width * 4 + 4 * x + 2 ) = blue;
			*( target_pixel + y * width * 4 + 4 * x + 3 ) = 255;
		}
	}
	return target_pixel;
}

- (unsigned char*) extractImageOfkSNImage32bitABGR:(SNImageData*)imageData rect:(CGRect)rect {
	unsigned char* target_pixel = (unsigned char*) malloc( sizeof(unsigned char) * rect.size.width * rect.size.height * 4 );
	unsigned char* source_pixel = (unsigned char*)[[imageData pixelAsNSData] bytes];
	int x,y;
	int width = rect.size.width;
	int height = rect.size.height;
	int tempx, tempy;
	for( x = 0; x < width; x++ ) {
		for( y = 0; y < height; y++ ) {
			tempx = rect.origin.x + x;
			tempy = rect.origin.y + height - y;
			
			CGPoint adjusted = [SNImageData adjustPoint:CGPointMake( tempx, tempy ) accordingAsImageData:imageData];
			tempx = (int)adjusted.x - (int)adjusted.x % mosaic_size;
			tempy = (int)adjusted.y - (int)adjusted.y % mosaic_size;
			
			unsigned char red =   *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 3 );
			unsigned char green = *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 2 );
			unsigned char blue =  *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 1 );
			// unsigned char alpha = *(source_pixel + tempy * imageData.bytesPerRow + 4 * tempx + 0 );
			
			*( target_pixel + y * width * 4 + 4 * x + 0 ) = red;
			*( target_pixel + y * width * 4 + 4 * x + 1 ) = green;
			*( target_pixel + y * width * 4 + 4 * x + 2 ) = blue;
			*( target_pixel + y * width * 4 + 4 * x + 3 ) = 255;
		}
	}
	return target_pixel;
}

#pragma mark -
#pragma mark Extract mosaic region of interest

- (BOOL) setMosaicWithImage:(SNImageData*)imageData rect:(CGRect)rect {
	unsigned char* target_pixel = NULL;
	
	if (rect.size.width <= 0 || rect.size.height <= 0) {
		return NO;
	}
	
	int large_size = imageData.size.width > imageData.size.height ?  imageData.size.width : imageData.size.height;
	int base_size = large_size / DEFAULT_MOSAIC_RATIO_PARAM;
	
	if( base_size < 5 )
		base_size = 5;
	
	mosaic_size = [[NSUserDefaults standardUserDefaults] integerForKey:@"MosaicSize"];
	
	switch( imageData.format ) {
		// RGBA
		case kSNImage32bitPreRGBA:
		case kSNImage32bitRGBA:
		case kSNImage32bitRGBD:
			target_pixel = [self extractImageOfkSNImage32bitRGBA:imageData rect:rect];
			break;
		
		// ARGB
		case kSNImage32bitPreARGB:
		case kSNImage32bitDRGB:
		case kSNImage32bitARGB:
			target_pixel = [self extractImageOfkSNImage32bitARGB:imageData rect:rect];
			break;
			
		// BGRA
		case kSNImage32bitPreBGRA:
		case kSNImage32bitBGRD:
		case kSNImage32bitBGRA:
			target_pixel = [self extractImageOfkSNImage32bitBGRA:imageData rect:rect];
			break;
		
		// ABGR
		case kSNImage32bitPreABGR:
		case kSNImage32bitABGR:
		case kSNImage32bitDBGR:
			target_pixel = [self extractImageOfkSNImage32bitABGR:imageData rect:rect];
			break;
		
		default:
			return NO;
	}
	if (target_pixel == NULL) {
		return NO;
	}
	
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, target_pixel, sizeof(unsigned char) * rect.size.width * rect.size.height * 4  , FLProviderReleaseData);
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
		
	image = CGImageCreate(
						   rect.size.width,					// width
						   rect.size.height,				// height
						   8,								// Bits per sample
						   32,								// Bits per pixel
						   rect.size.width * 4,				// bytes per row
						   colorspace,						// colorspace
							(0 << 12 | kCGImageAlphaLast),	// BitmapInfo
						   provider,						// Dataprovider
						   NULL,							// decode
						   NO,								// shouldInterpolate
						   kCGRenderingIntentDefault		// intent
						   );
	CGDataProviderRelease( provider );
	CGColorSpaceRelease(colorspace);
	
	isSetMosaic = YES;
	
	return YES;
}

#pragma mark Override

- (id) initWithFrame:(CGRect)frame {
	if( self = [super initWithFrame:frame] ) {
		self.userInteractionEnabled = NO;
		self.backgroundColor = [UIColor clearColor];
		isSetMosaic = NO;
		NSString* setting_value_string = [[NSUserDefaults standardUserDefaults] stringForKey:@"mosaicSize"];
		if( setting_value_string )
			mosaic_setting_value = [setting_value_string floatValue];
		else
			mosaic_setting_value = 1.0f;
	}
	return self;
}

- (void) dealloc {
	CGImageRelease(image);
	[super dealloc];
}

- (void) drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (isSetMosaic) {
		CGContextDrawImage(context, rect, image);
	}
	else {
		CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 0.5);
		CGContextFillRect(context, rect);
	}
}

@end
