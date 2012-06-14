//
//  HvadKosterMoedetAppDelegate.h
//  HvadKosterMoedet
//
//  Created by Jesper Nielsen on 30/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFilename @"data.plist"
#define kSettingsFile @"settings.plist"
@class MainViewController;

@interface TidErPengeAppDelegate : NSObject <UIApplicationDelegate> {
    NSMutableArray *logsData;
    BOOL keepAppActive;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet MainViewController *mainViewController;
@property (nonatomic, strong) NSMutableArray *logsData;
@property (nonatomic) BOOL keepAppActive;
-(NSString*)dataFilePath;
-(NSString*)settingsFilePath;
-(void)saveLog:(NSString*)log;
-(void)removeLogData;
-(void)removeSingleLog:(NSUInteger)index;
-(void)saveIdleSetting:(BOOL)idle;
@end
