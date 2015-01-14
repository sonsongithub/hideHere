//
//  NSString+digest.h
//  RSS
//
//  Created by sonson on 09/01/27.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (Digest)
- (NSString *)MD5DigestString;
- (void)getMD5:(unsigned char*)buffer;
@end
