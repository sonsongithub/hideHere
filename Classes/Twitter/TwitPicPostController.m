//
//  TwitPicPostController.m
//  hideHere
//
//  Created by sonson on 10/10/06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitPicPostController.h"
#import "XAuthTwitterEngine.h"
#import "XAuthTwitterEngine+TwitPic.h"
#import "NSMutableData+Multipart.h"
#import "JSON.h"

#define OFFSET_MESSAGE 100

static TwitPicPostController* sharedInstance = nil;

@implementation TwitPicPostController

@synthesize imageBinary;

+ (TwitPicPostController*)sharedInstance {
	if (sharedInstance == nil) {
		sharedInstance = [[TwitPicPostController alloc] init];
	}
	return sharedInstance;
}

+ (BOOL)enabledTwitterAccount {
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_password"];
	if ([username length] && [password length])
		return YES;
	return NO;
}

- (void)showTweetView {
	inputView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tweet", nil)
										   message:@"\r\r"
										  delegate:self
								 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
								 otherButtonTitles:NSLocalizedString(@"Tweet", nil), nil];
	[inputView setTag:AlertViewTweetInput];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 110.0);
	[inputView setTransform:myTransform];
	tweetField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 55, 260.0, 25.0)];
	[tweetField setBorderStyle:UITextBorderStyleRoundedRect];
	[tweetField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[tweetField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[tweetField setKeyboardType:UIKeyboardTypeASCIICapable];
	
	[tweetField setDelegate:self];
	
	[inputView show];
	[inputView addSubview:tweetField];
	[tweetField release];
	[inputView release];
	[tweetField becomeFirstResponder];
}

- (void)showAlertViewWithMessage:(NSString*)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Twitter", nil)
													message:message
												   delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[alert show];
	[alert release];
	[alert setTag:AlertViewMessage];
}

- (void)dismissActionSheet {
	[sheet dismissWithClickedButtonIndex:0 animated:YES];
	sheet = nil;
}

- (void)showActionSheet:(NSString*)message {
	if (sheet == nil) {
		sheet = [[UIActionSheet alloc] initWithTitle:message
											delegate:nil
								   cancelButtonTitle:nil
							  destructiveButtonTitle:nil
								   otherButtonTitles:nil];
		UIWindow *w = [[UIApplication sharedApplication] keyWindow];
		[sheet showInView:w];
		[sheet release];
	}
	else {
		[sheet setTitle:message];
	}
}

- (void)clearTwitterAuthentication {
	DNSLogMethod
	[twitterEngine clearAccessToken];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCachedXAuthAccessTokenStringKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearAuthenticationIfUsernameChanged {
	DNSLogMethod
	
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_username"];
	NSString *lastAuthenticatedUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"kLastAuthenticatedUsername"];
	
	if (![username isEqualToString:lastAuthenticatedUsername]) {
		[twitterEngine clearAccessToken];
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCachedXAuthAccessTokenStringKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

#pragma mark -
#pragma mark Instance method

- (void)tweet:(NSDictionary*)userInfo {
	[self clearAuthenticationIfUsernameChanged];
	
	self.imageBinary = [userInfo objectForKey:@"imageBinary"];
	
	if ([twitterEngine isAuthorized]) {
		[self showTweetView];
	}
	else {
		NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_username"];
		NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_password"];
		
		if ([username length] && [password length]) {
			[twitterEngine exchangeAccessTokenForUsername:username password:password];
			[self showActionSheet:NSLocalizedString(@"Authenticating...", nil)];
		}
	}
}

- (void)postToTwitpic:(NSString*)message {
	
	NSString *url = @"http://api.twitpic.com/2/upload.json";
	NSMutableURLRequest*request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
														 cachePolicy:NSURLRequestUseProtocolCachePolicy
													 timeoutInterval:30.0];
	[request setHTTPMethod:@"POST"];
	NSString *oauthHeader = [twitterEngine authorizationString];
	DNSLog(@"%@", oauthHeader);
	NSString *autorizeUrl = @"https://api.twitter.com/1/account/verify_credentials.json";
	
	[request addValue:autorizeUrl forHTTPHeaderField:@"X-Auth-Service-Provider"];
	[request addValue:oauthHeader forHTTPHeaderField:@"X-Verify-Credentials-Authorization"];
	
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [NSMutableData multipartBoundary]] forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postData = [NSMutableData mutableDataForMultipart];
	
	[postData appendPartWithFileData:imageBinary name:@"media" filename:@"file" contentType:nil];
	
	NSString *key = kTwitPicAPIKey;
	NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
	NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
	[postData appendPartWithData:messageData name:@"message"];
	[postData appendPartWithData:keyData name:@"key"];
	[postData finalizeMultipart];
	
	[request setHTTPBody:postData];

	dataForTwitPic = [[NSMutableData data] retain];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark -
#pragma mark NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	responseForTwitPic = [response copy];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[dataForTwitPic appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self dismissActionSheet];
	[self showAlertViewWithMessage:[error localizedDescription]];
	[dataForTwitPic release];
	dataForTwitPic = nil;
	
	[responseForTwitPic release];
	responseForTwitPic = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSString *a = [[NSString alloc] initWithData:dataForTwitPic encoding:NSUTF8StringEncoding];
	
	id json = [a JSONValue];
	
	DNSLog(@"%@", a);
	[a release];
	
	if ([(NSHTTPURLResponse*)responseForTwitPic statusCode] == 200) {
		
		NSString *text = [json objectForKey:@"text"];
		NSString *url = [json objectForKey:@"url"];
		NSString *message = [NSString stringWithFormat:@"%@ %@ #hideHere", text, url];
		
		[self showActionSheet:NSLocalizedString(@"Twiting...", nil)];
		[twitterEngine sendUpdate:message];
	}
	else {
		NSString *errorMessage = NSLocalizedString(@"TwitPic Error", nil);
		NSArray *errors = [json objectForKey:@"errors"];
		
		if ([errors count]) {
			NSDictionary *error = [errors objectAtIndex:0];
			errorMessage = [error objectForKey:@"message"];
		}		
		[self dismissActionSheet];
		[self showAlertViewWithMessage:errorMessage];
		[twitterEngine clearAccessToken];
		[self clearTwitterAuthentication];
	}
	
	[dataForTwitPic release];
	dataForTwitPic = nil;
	
	[responseForTwitPic release];
	responseForTwitPic = nil;
}

#pragma mark -
#pragma mark Override

- (id) init {
	self = [super init];
	if (self != nil) {
		twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
		twitterEngine.consumerKey = kOAuthConsumerKey;
		twitterEngine.consumerSecret = kOAuthConsumerSecret;
		
		if ([twitterEngine isAuthorized]) {
		}
		else {
		}
	}
	return self;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	DNSLogMethod
	// http://twitpic.com/2v4w7s
	[inputView setTitle:[NSString stringWithFormat:NSLocalizedString(@"Tweet(remained %d chars)", nil),  OFFSET_MESSAGE - [textField.text length]]];
	return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	[tweetField resignFirstResponder];
	[self dismissActionSheet];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([alertView tag] == AlertViewTweetInput) {
		if (buttonIndex == 1) {
			NSString *string = [NSString stringWithString:tweetField.text];
			
			// truncate long message
			if (OFFSET_MESSAGE - [string length] < 2) {
				int length = OFFSET_MESSAGE - [string length];
				string = [tweetField.text substringWithRange:NSMakeRange(0, length-1)];
				DNSLog(@"%@", string);
			}
			else {
				DNSLog(@"%@", string);
			}
			[self postToTwitpic:string];
			[self showActionSheet:NSLocalizedString(@"Uploading...", nil)];
		}
		else {
		}
	}
	else {
	}
	self.imageBinary = nil;
}

#pragma mark -
#pragma mark XAuthTwitterEngineDelegate methods

- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username {
	DNSLogMethod
	NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedXAuthAccessTokenStringKey];
	
	NSLog(@"About to return access token string: %@", accessTokenString);
	
	return accessTokenString;
}

- (void) storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username {
	DNSLogMethod
	DNSLog(@"Access token string returned: %@", tokenString);
	
	if (tokenString !=nil || [tokenString length]) {
		// authenticatioon is succeeded.
		// update twitter account info
		NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_username"];
		[[NSUserDefaults standardUserDefaults] setObject:username forKey:@"kLastAuthenticatedUsername"];
		[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:kCachedXAuthAccessTokenStringKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		// trying to tweet when data to be sent has been remained
		if ([twitterEngine isAuthorized] && self.imageBinary) {
			[self showTweetView];
		}
	}
	else {
		// it is failed
		// unknown error?
	}
	[self dismissActionSheet];
}

- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error {
	DNSLogMethod
	
	// authentication has been failed.
	NSLog(@"Error: %@", [error localizedDescription]);
	
	[self clearTwitterAuthentication];
	
	// close sheet
	[self dismissActionSheet];
	
	// show alert abount error	
	[self showAlertViewWithMessage:[error localizedDescription]];
}


#pragma mark -
#pragma mark MGTwitterEngineDelegate methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
	DNSLogMethod
	DNSLog(@"Twitter request succeeded: %@", connectionIdentifier);
	
	[self dismissActionSheet];
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	DNSLogMethod
	DNSLog(@"Twitter request failed: %@ with error:%@", connectionIdentifier, error);
	
	DNSLog(@"Error code:%d", [error code]);
	DNSLog(@"Error code:%@", [error localizedDescription]);
	
	if ([[error domain] isEqualToString: @"HTTP"]) {
		switch ([error code]) {
			case 401:
				break;
			case 502:
				break;
			case 503:
				break;
			default:
				break;				
		}
	}
	else  {
		switch ([error code]) {
			case -1009:
				break;
			case -1200:
				break;								
			default:
				break;
		}
	}
	[twitterEngine clearAccessToken];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCachedXAuthAccessTokenStringKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self showAlertViewWithMessage:[error localizedDescription]];
	[self dismissActionSheet];
}

#pragma mark -
#pragma mark dealloc

- (void) dealloc {
	[imageBinary release];
	[super dealloc];
}


@end
