//
//  IASKHelper.m
//  iPadTest
//
//  Created by Christopher Atlan on 02.05.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IASKHelper.h"


BOOL isPad()
{
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
	if ([[UIDevice currentDevice] respondsToSelector: @selector(userInterfaceIdiom)])
		return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
#endif
	
	return NO;
}