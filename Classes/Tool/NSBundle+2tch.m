//
//  NSBundle+2tch.m
//  2tch
//
//  Created by sonson on 09/09/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSBundle+2tch.h"

@implementation NSBundle(_2tch)

+ (id)infoValueFromMainBundleForKey:(NSString*)key {
	if ([[[self mainBundle] localizedInfoDictionary] objectForKey:key])
		return [[[self mainBundle] localizedInfoDictionary] objectForKey:key];
	return [[[self mainBundle] infoDictionary] objectForKey:key];
}

@end
