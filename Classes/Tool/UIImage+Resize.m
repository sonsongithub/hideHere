//
//  UIImage+Resize.m
//  hideHere
//
//  Created by sonson on 09/06/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

+ (UIImage*) reduceUIImage:(UIImage*)inputImage maximumSize:(int)max_size{
	CGSize origial_size = inputImage.size;
	
	if( origial_size.width < max_size && origial_size.height < max_size ) {
		return inputImage;
	}
	
	float ratio = 1.0f;
	
	ratio = origial_size.width > origial_size.height ? (float)max_size / origial_size.width :  (float)max_size / origial_size.height;
	
	CGRect new_image_rect = CGRectMake(0, 0, (int)(origial_size.width * ratio)+1, (int)(origial_size.height * ratio)+1 );
	
	UIGraphicsBeginImageContext(new_image_rect.size);

	CGContextRef ctx = UIGraphicsGetCurrentContext();
	//
	// Set background color. Background is noisy if image is transparent.
	//
	CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
	CGContextFillRect(ctx, new_image_rect);
	[inputImage drawInRect:new_image_rect];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end