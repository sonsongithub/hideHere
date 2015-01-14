//
//  NSMutableData+Multipart.m
//  iPhoneClient
//
//  Created by sonson on 10/05/19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSMutableData+Multipart.h"

@implementation NSMutableData(Multipart)

+ (NSString*)multipartBoundary {
	return @"0xKhTmLbOuNdArY";
}

+ (NSMutableData*)mutableDataForMultipart {
	NSMutableData *data = [NSMutableData data];
	[data appendData:[[NSString stringWithFormat:@"--%@\r\n", [NSMutableData multipartBoundary]] dataUsingEncoding:NSUTF8StringEncoding]];
	return data;
}

- (void)appendPartWithData:(NSData*)data name:(NSString*)name {
	[self appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
	[self appendData:data];
	[self appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", [NSMutableData multipartBoundary]] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendPartWithFileData:(NSData*)data name:(NSString*)name filename:(NSString*)filename contentType:(NSString*)contentType {
	if (!contentType) {
		contentType = @"application/octet-stream";
	}
	
	[self appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename] dataUsingEncoding:NSUTF8StringEncoding]];
	[self appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", contentType] dataUsingEncoding:NSUTF8StringEncoding]];
	[self appendData:data];
	[self appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", [NSMutableData multipartBoundary]] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)finalizeMultipart {
	if ([self length] > 4) {
		char *p = (char*)([self bytes] + [self length] - 4);
		if (!strncmp(p, "--\r\n", 4)) {
			NSLog(@"out");
		}
		else {
			[self replaceBytesInRange:NSMakeRange([self length] - 2, 2) withBytes:"--"];
			[self appendBytes:"\r\n" length:3];
		}
	}
}

@end
