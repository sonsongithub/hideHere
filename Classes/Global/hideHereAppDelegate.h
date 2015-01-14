//
//  hideHereAppDelegate.h
//  hideHere
//
//  Created by sonson on 09/06/16.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@class Stamp;
@class SNHUDActivityView;

@interface hideHereAppDelegate : NSObject <UIApplicationDelegate> {
	//
	// CoreData
	//
	NSManagedObjectModel			*managedObjectModel;
    NSManagedObjectContext			*managedObjectContext;	    
    NSPersistentStoreCoordinator	*persistentStoreCoordinator;
	
	//
	// Essential UI
	//
    UIWindow						*window;
    UINavigationController			*navigationController;
	SNHUDActivityView				*hud;
	
	//
	// Singleton, stamp object
	//
	Stamp							*stamp;
	
	//
	// For openURL scheme
	//
	NSString						*imageURL;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) Stamp *stamp;
@property (nonatomic, retain) NSString *imageURL;

#pragma mark -
#pragma mark Application lifecycle
- (void)applicationDidFinishLaunching:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;

#pragma mark -
#pragma mark HUD
- (void)openHUDOfString:(NSString*)message;
- (void)openActivityHUDOfString:(id)obj;
- (void)closeHUD;

#pragma mark -
#pragma mark Initialize, copy SQLite and stamp images into ~/Document/
- (void)initializePreInstallSQLiteDBAndStampImages;

- (void)initMosaicSizeOfUserInfo;

#pragma mark -
#pragma mark Saving
- (IBAction)saveAction:(id)sender;

#pragma mark -
#pragma mark Core Data stack
- (NSManagedObjectContext *) managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

#pragma mark -
#pragma mark Application's documents directory
- (NSString *)applicationDocumentsDirectory;

@end

