//
//  NSMutableData+Multipart.h
//  iPhoneClient
//
//  Created by sonson on 10/05/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData(Multipart)
+ (NSString*)multipartBoundary;
+ (NSMutableData*)mutableDataForMultipart;
- (void)finalizeMultipart;
- (void)appendPartWithData:(NSData*)data name:(NSString*)name;
- (void)appendPartWithFileData:(NSData*)data name:(NSString*)name filename:(NSString*)filename contentType:(NSString*)contentType;
@end
