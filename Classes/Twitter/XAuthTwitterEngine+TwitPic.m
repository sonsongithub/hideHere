//
//  XAuthTwitterEngine+TwitPic.m
//  hideHere
//
//  Created by sonson on 10/10/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XAuthTwitterEngine+TwitPic.h"
#import "OAMutableURLRequest.h"

@interface OAMutableURLRequest(TwitPic)

- (NSString*)authorizationString;

@end

@implementation OAMutableURLRequest (TwitPic)

- (NSString*)authorizationString {
	NSString *string = [self valueForHTTPHeaderField:@"Authorization"];
	if (!string) {
		[self prepare];
		string = [self valueForHTTPHeaderField:@"Authorization"];
	}
	return string;
}

@end

@implementation XAuthTwitterEngine(TwitPic)

- (NSString*)authorizationString {
	
	NSString *authorizeUrl = [NSString stringWithFormat:@"https://api.twitter.com/1/account/verify_credentials.json"];
	OAMutableURLRequest *oauthRequest = [[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:authorizeUrl]
																		 consumer:self.consumer
																			token:self.accessToken   
																			realm:@"http://api.twitter.com/"
																signatureProvider:nil] autorelease];
	
	
	return [oauthRequest authorizationString];
}

@end
