//
//  HvadKosterMoedetAppDelegate.m
//  HvadKosterMoedet
//
//  Created by Jesper Nielsen on 30/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TidErPengeAppDelegate.h"

#import "MainViewController.h"

@implementation TidErPengeAppDelegate


@synthesize window=_window;

@synthesize mainViewController=_mainViewController;
@synthesize logsData,keepAppActive;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *settingsPath = [self settingsFilePath];
    BOOL idle;
    if ([[NSFileManager defaultManager] fileExistsAtPath:settingsPath]) {
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
        idle = [[dict objectForKey:@"idle"] boolValue];
    } else {
        idle = YES;
    }
    [application setIdleTimerDisabled:idle];
    keepAppActive = idle;
    application.applicationSupportsShakeToEdit = YES;
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        logsData = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    } else {
        logsData = [[NSMutableArray alloc] init];
    }
    
    UIImage *navbarBackground = [UIImage imageNamed:@"leather-navbar-black"];
    [[UINavigationBar appearance] setBackgroundImage:navbarBackground forBarMetrics:UIBarMetricsDefault];
    
    UIImage *buttonBackground = [[UIImage imageNamed:@"navbar-button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, -2, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:buttonBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonBackground = [[UIImage imageNamed:@"navbar-back-button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // Override point for customization after application launch.
    // Add the main view controller's view to the window and display.
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    //_mainViewController.timePassed = [NSDate timeIntervalSinceReferenceDate] - _mainViewController.startInterval;
    //_mainViewController.startInterval = [NSDate timeIntervalSinceReferenceDate] - _mainViewController.timePassed;

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


- (void)saveLog:(NSString*)log{
    [logsData addObject:log];
    [logsData writeToFile:[self dataFilePath] atomically:YES];
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void)removeLogData{
    [self.logsData removeAllObjects];
    [self.logsData writeToFile:[self dataFilePath] atomically:YES];
}

- (void)removeSingleLog:(NSUInteger)index{
    [self.logsData removeObjectAtIndex:index];
    [self.logsData writeToFile:[self dataFilePath] atomically:YES];
}

- (NSString *)settingsFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kSettingsFile];
}

- (void)saveIdleSetting:(BOOL)idle{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:(NSNumber *)[NSNumber numberWithBool:idle] forKey:@"idle"];
    [dict writeToFile:[self settingsFilePath] atomically:YES];

}

@end
