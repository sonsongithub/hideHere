//
//  hideHereAppDelegate.m
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "hideHereAppDelegate.h"
#import "RootViewController.h"
#import "SNHUDActivityView.h"

@implementation hideHereAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize stamp;
@synthesize imageURL;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self initializePreInstallSQLiteDBAndStampImages];
	[self initMosaicSizeOfUserInfo];
	
	UIAppDelegate = self;
	
	hud = [[SNHUDActivityView alloc] init];
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	
	//
	//
	//
	[self performSelector:@selector(confirmUpdateStamp) withObject:nil afterDelay:0.0];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	NSString* absURLString = [url absoluteString];
	if ( !url || !absURLString ) {
		return NO;
	}
	
	//
	// hidehere://post?url=
	//
	NSString *decodedURL = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
																							  kCFAllocatorDefault,
																							  (CFStringRef)[absURLString substringWithRange:NSMakeRange(20,[absURLString length]-20)],
																							  CFSTR(""),
																							  kCFStringEncodingUTF8);
	
	self.imageURL = [[[NSString alloc] initWithString:decodedURL] autorelease];
	DNSLog(@"decodedURL=%@", decodedURL);
	[decodedURL release];
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			//
			// Handle error
			//
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}

#pragma mark -
#pragma mark for OpenURL

- (void)confirmUpdateStamp {
}

#pragma mark -
#pragma mark HUD

- (void)openHUDOfString:(NSString*)message {
	if( hud.superview == nil ) {
		[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
		[message retain];	// add retain count, for another thread.
		[NSThread detachNewThreadSelector:@selector(openActivityHUDOfString:) toTarget:self withObject:message];
	}
}

- (void)openActivityHUDOfString:(id)obj {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	@synchronized( self ) {
		[hud setupWithMessage:(NSString*)obj];
		[obj release];
		[hud arrange:window.frame];
		[window addSubview:hud];
	}
	[pool release];
	[NSThread exit];
}

- (void)closeHUD {
	if( hud.superview != nil ) {
		while( [[UIApplication sharedApplication] isIgnoringInteractionEvents] ) {
			DNSLog( @"try to cancel ignoring interaction" );
			[NSThread sleepForTimeInterval:0.05];
			[[UIApplication sharedApplication] endIgnoringInteractionEvents];
		}
		[hud dismiss];
	}
}

#pragma mark -
#pragma mark Init mosaic size user info

- (void)initMosaicSizeOfUserInfo {
	int mosaicSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"MosaicSize"];
	if (mosaicSize == 0) {
		[[NSUserDefaults standardUserDefaults] setInteger:DEFAULT_MOSAIC_SIZE forKey:@"MosaicSize"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

#pragma mark -
#pragma mark Initialize, copy SQLite and stamp images into ~/Document/

- (void)initializePreInstallSQLiteDBAndStampImages {
	//
	// Get document directory
	//
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	//
	// Source and destination path
	//
	NSString *applicationPath = [[NSBundle mainBundle] bundlePath];
    NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *stampPath = [documentPath stringByAppendingPathComponent:@"stamp"];
	
	//
	// Make directory ~/Document/stamp/
	//
	BOOL isDirectory = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:stampPath isDirectory:&isDirectory]) {
		if (isDirectory) {
		}
	}
	if ([[NSFileManager defaultManager] createDirectoryAtPath:stampPath withIntermediateDirectories:YES attributes:nil error:nil]) {
	}
	
	//
	// Copy sqlite file
	//
	NSString *sqliteSourcePath = [applicationPath stringByAppendingPathComponent:@"stamp.sqlite"];
	NSString *sqliteDestinationPath = [documentPath stringByAppendingPathComponent:@"stamp.sqlite"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:sqliteDestinationPath isDirectory:&isDirectory]) {
		//
		// Not already existing
		//
		[[NSFileManager defaultManager] copyItemAtPath:sqliteSourcePath toPath:sqliteDestinationPath error:nil];
	}
	
	//
	// Copy stamp files
	//
	NSArray* preinstallStampfilenames = [NSArray arrayWithObjects:
										 @"3d08c76ea296e11b88e8ccdc4eb2c38d",
										 @"9b6441177de3a7a291a7959b4e814f5c",
										 @"232d69260be8bbeb92f6d913a6a4b3ec",
										 @"ac99370febba7c267f7c5ebcb755b1a9",
										 @"c78651ca7bd0c42f3a7b58ae971da6ea",
										 @"f2cb8bbd118d5175e793bc292ad8b89b",
							nil];
	
	for (NSString *filename in preinstallStampfilenames) {
		NSString *stampSourcePath = [applicationPath stringByAppendingPathComponent:filename];
		NSString *stampDestinationPath = [stampPath stringByAppendingPathComponent:filename];
		if (![[NSFileManager defaultManager] fileExistsAtPath:stampDestinationPath isDirectory:&isDirectory]) {
			//
			// Not already existing
			//
			[[NSFileManager defaultManager] copyItemAtPath:stampSourcePath toPath:stampDestinationPath error:nil];
		}
	}
}

#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"stamp.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

