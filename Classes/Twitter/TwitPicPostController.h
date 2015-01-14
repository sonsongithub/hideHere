//
//  TwitPicPostController.h
//  hideHere
//
//  Created by sonson on 10/10/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Replace these with your consumer key
#define kOAuthConsumerKey					@"tet4ZdrRLFOvomNVG9q1Qw"

// and consumer secret from http://twitter.com/oauth_clients/details/<your app id>
#define	kOAuthConsumerSecret				@"shoMB6M3syBT2Emju3Sho1UDIW8ywRmEVOkEg2Vgwj8"

#define kCachedXAuthAccessTokenStringKey	@"cachedXAuthAccessTokenKey"

#define kTwitPicAPIKey						@"d034ec21d3933f662f495ee1d362f605"

@class XAuthTwitterEngine;

typedef enum {
	AlertViewMessage = 0,
	AlertViewTweetInput = 1,
}AlertViewType;

@interface TwitPicPostController : NSObject <UITextFieldDelegate> {
	XAuthTwitterEngine	*twitterEngine;
	NSData				*imageBinary;
	UIActionSheet		*sheet;
	UIAlertView			*inputView;
	UITextField			*tweetField;
	
	//
	NSURLResponse		*responseForTwitPic;
	NSMutableData		*dataForTwitPic;
}
@property (nonatomic, retain) NSData *imageBinary;
+ (TwitPicPostController*)sharedInstance;
+ (BOOL)enabledTwitterAccount;
- (void)tweet:(NSDictionary*)userInfo;
@end
