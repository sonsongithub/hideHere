//
//  NSString+digest.m
//  RSS
//
//  Created by sonson on 09/01/27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+digest.h"

@implementation NSString (Digest)

- (NSString *)MD5DigestString {
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	char md5cstring[CC_MD5_DIGEST_LENGTH*2];
	
	CC_MD5( [self UTF8String], [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest );
	
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
		sprintf( md5cstring+i*2, "%02x", digest[i] );
	
	return [[[NSString alloc] initWithBytes:md5cstring length:CC_MD5_DIGEST_LENGTH*2 encoding:NSUTF8StringEncoding] autorelease];
}

- (void)getMD5:(unsigned char*)buffer {
	CC_MD5( [self UTF8String], [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], buffer );
}

@end