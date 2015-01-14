//
//  Stamp.m
//  hideHere
//
//  Created by sonson on 09/06/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Stamp.h"

// Tool
#import "UIImage+Resize.h"
#import "UIImage+OptimizedPNG.h"
#import "NSString+digest.h"

@implementation Stamp

@dynamic name, stampHash, thumbnailData, displayOrder;

#pragma mark -
#pragma mark Class method

+ (NSString*)hashFromURLString:(NSString*)URLString {
	//
	// Make hash which is made from URL + date string
	//
	NSDate *date = [NSDate date];
	NSString *url_date = [URLString stringByAppendingString:[date description]];
	return [url_date MD5DigestString];
}

+ (BOOL)downloadFromURLString:(NSString*)URLString originalImageData:(NSData**)originalImageData thumbnailData:(NSData**)thumbnailData {
	//
	// Return no if downloaded data is invalidate or downloaded image can't be resized
	// Download original image and make resized image
	//
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
	NSData* dataFromRemote = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	//
	// Check whether downloaded data is validate
	//
	if (dataFromRemote == nil) {
		//
		// Show error message
		//
		UIAlertView *view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error - stamp", nil) 
													   message:[error localizedDescription] 
													  delegate:nil cancelButtonTitle:nil 
											 otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
		[view show];
		[view release];
		return NO;
	}
	
	//
	// Decode to image and resize image
	//
	UIImage *downloadedImage = [[[UIImage alloc] initWithData:dataFromRemote] autorelease];
	UIImage *resizedDownloadedImage = [UIImage reduceUIImage:downloadedImage maximumSize:24];
	
	//
	// Check whether original image and resized image are validate
	//
	if (downloadedImage != nil && resizedDownloadedImage != nil) {
		*thumbnailData = [resizedDownloadedImage optimizedData];
		*originalImageData = dataFromRemote;
		return YES;
	}
	
	//
	// Show error message
	//
	UIAlertView *view = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error - stamp", nil) 
												   message:NSLocalizedString(@"Incorrect stamp image file", nil) 
												  delegate:nil cancelButtonTitle:nil 
										 otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[view show];
	[view release];
	return NO;
}

#pragma mark -
#pragma mark Accessor

- (UIImage*)thumbnail {
	if (thumbnail == nil) {
		//
		// Make image from binary data from SQLite
		//
		thumbnail = [[UIImage imageWithData:thumbnailData] retain];
	}
	return thumbnail;
}

- (UIImage*)image {
	if (image == nil) {
		//
		// Read image file according to ~/Stamp/hash
		//
		NSString *stampSavedDirectoryPath = [self stampSavedDirectoryPath];
		NSString *stampPath = [stampSavedDirectoryPath stringByAppendingPathComponent:stampHash];
		NSData *data = [NSData dataWithContentsOfFile:stampPath];
		image = [[UIImage imageWithData:data] retain];
	}
	return image;
}

#pragma mark -
#pragma mark Get directory path to save stamp images

- (NSString*)stampSavedDirectoryPath {
	//
	// Get document directory
	//
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	
	//
	// Make directory ~/Document/stamp/
	//
	BOOL isDirectory = NO;
	NSString *stampPath = [basePath stringByAppendingPathComponent:@"stamp"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:stampPath isDirectory:&isDirectory]) {
		if (isDirectory) {
			return stampPath;
		}
		return nil;
	}
	
	if ([[NSFileManager defaultManager] createDirectoryAtPath:stampPath withIntermediateDirectories:YES attributes:nil error:nil]) {
		return stampPath;
	}

    return nil;
}

#pragma mark -
#pragma mark Stamp image file management

- (BOOL)deleteImageData {
	//
	// Delete stamp image file when data will be removed from data base
	//
	NSString *stampSavedDirectoryPath = [self stampSavedDirectoryPath];
	if (stampSavedDirectoryPath == nil) {
		return NO;
	}
	NSString *stampPath = [stampSavedDirectoryPath stringByAppendingPathComponent:stampHash];
	return [[NSFileManager defaultManager] removeItemAtPath:stampPath error:nil];
}

- (BOOL)writeImageData:(NSData*)data {
	//
	// Save stamp as image file when new data is coming
	//
	NSString *stampSavedDirectoryPath = [self stampSavedDirectoryPath];
	if (stampSavedDirectoryPath == nil) {
		return NO;
	}
	NSString *stampPath = [stampSavedDirectoryPath stringByAppendingPathComponent:stampHash];
	return [data writeToFile:stampPath atomically:NO];
}

#pragma mark -
#pragma mark NSManagedObject

- (void)didSave {
	DNSLogMethod
	if ([self isDeleted]) {
		DNSLog(@"Delete");
		[self deleteImageData];
	}
	[super didSave];
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	//
	// For CoreData
	//
	[name release];
	[stampHash release];
	[thumbnailData release];
	[displayOrder release];
	
	//
	// Image
	//
	[thumbnail release];
	[image release];
	
	[super dealloc];
}

@end
