//
//  Stamp.h
//  hideHere
//
//  Created by sonson on 09/06/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Stamp : NSManagedObject {
	//
	// CoreData
	//
	NSString	*name;
	NSString	*stampHash;
	NSData		*thumbnailData;
	NSNumber	*displayOrder;
	
	//
	// Image data
	//
	UIImage		*thumbnail;
	UIImage		*image;
}
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* stampHash;
@property (nonatomic, retain) NSData* thumbnailData;
@property (nonatomic, retain) NSNumber* displayOrder;

@property (nonatomic, readonly) UIImage* thumbnail;
@property (nonatomic, readonly) UIImage* image;

#pragma mark -
#pragma mark Class method
+ (NSString*)hashFromURLString:(NSString*)URLString;
+ (BOOL)downloadFromURLString:(NSString*)URLString originalImageData:(NSData**)originalImageData thumbnailData:(NSData**)thumbnailData;
#pragma mark -
#pragma mark Accessor
- (UIImage*)thumbnail;
- (UIImage*)image;
#pragma mark -
#pragma mark Get directory path to save stamp images
- (NSString*)stampSavedDirectoryPath;
#pragma mark -
#pragma mark Stamp image file management
- (BOOL)deleteImageData;
- (BOOL)writeImageData:(NSData*)data;

@end
