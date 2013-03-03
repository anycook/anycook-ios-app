//
//  RecipeProtoAppDelegate.m
//  RecipeViewPrototype
//
//  Created by Maximilian Michel on 02.05.12.
//  Copyright (c) 2012 anycook. All rights reserved.
//

#import "RecipeProtoAppDelegate.h"
#import <CoreData/CoreData.h>
#import "CachedDataHandler.h"
#import "Utility.h"
#import "RecipeResultCell.h"


@implementation RecipeProtoAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = _managedObjectContext;

// Sets all appearance settings, like background colors and fonts
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if([Utility checkForWifiConnection]){
        NSLog(@"WLAN connection");
        CachedDataHandler * cacheHandler = [CachedDataHandler instance];
        [[NSNotificationCenter defaultCenter] addObserver:cacheHandler selector:@selector(fillCache:) name:@"LocalDBReadyNotification"  object:nil];
    }
    
    UIColor * papergray = [UIColor colorWithRed:0.941 green:0.937 blue:0.922 alpha:1];
    //UIColor * papertexture = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgnoise2.png"]];
    
    [[UINavigationBar appearance] setTintColor:papergray];
    [[UINavigationBar appearance] setBackgroundColor:papergray];
    
    
    [[UINavigationBar appearance] setBackgroundImage:[Utility getTransparentImage] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], 
      UITextAttributeTextColor, 
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8], 
      UITextAttributeTextShadowColor, 
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], 
      UITextAttributeTextShadowOffset, 
      [UIFont fontWithName:@"Palatino" size:0.0], 
      UITextAttributeFont, 
      nil]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], 
      UITextAttributeTextColor, 
      [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], 
      UITextAttributeTextShadowColor, 
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], 
      UITextAttributeTextShadowOffset, 
      [UIFont fontWithName:@"Palatino-Bold" size:0.0], 
      UITextAttributeFont, 
      nil] forState:UIControlStateNormal];
    
    [[UIToolbar appearance] setTintColor:papergray];
    [[UIToolbar appearance] setBackgroundColor:papergray];
    [[UIToolbar appearance] setBackgroundImage:[Utility getTransparentImage]forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [[UISearchBar appearance] setBackgroundColor:papergray];
    [[UISearchBar appearance] setBackgroundImage:[Utility getTransparentImage]];
    //outline: [UIColor colorWithRed:0.855 green:0.851 blue:0.843 alpha:1] /*#dad9d7*/
    //anycookgreen: [UIColor colorWithRed:0.627 green:0.745 blue:0.314 alpha:1] /*#a0be50*/
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbarbackground.png"]];
    [[UITabBar appearance] setBackgroundColor:papergray];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectionIndicatorImage:[Utility getTransparentImage]];
    
    [[RecipeResultCell appearance] setBackgroundColor:papergray];
    
    return YES;
}


// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// Saves the managed object context
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
