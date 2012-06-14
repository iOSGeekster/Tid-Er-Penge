//
//  MainViewController.h
//  HvadKosterMoedet
//
//  Created by Jesper Nielsen on 30/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "LogsViewController.h"
#import "SaveLogViewController.h"
#import "SettingsViewController.h"
#import "MessageUI/MessageUI.h"

#import <CoreMotion/CoreMotion.h>

#define kUpdateInterval (1.0/10.0)

@interface MainViewController : UIViewController <LogsViewControllerDelegate,SaveLogViewControllerDelegate,SettingsViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate,UINavigationControllerDelegate,UIAccelerometerDelegate> {
    UITextField *antalPersoner;
    UITextField *timeLoen;
    UIBarButtonItem *startKnap;
    UIBarButtonItem *rydKnap;
    UILabel *beskrivelseLabel;
    UILabel *taeller;
    UILabel *tid;
    UILabel *antalPersonerLabel;
    UILabel *timeLoenLabel;
    UILabel *tidLabel;
    UILabel *pengeLabel;
    UIButton *logKnap;
    NSTimeInterval startInterval;
    NSTimeInterval stopInterval;
    NSTimeInterval elapsedInterval;
    NSTimeInterval timePassed;
    NSTimer *myTimer;
    double hourlyBurn;
    double burnPrSecond;
    double spent;
    BOOL running;
}
@property (nonatomic, strong) IBOutlet UITextField *antalPersoner;
@property (nonatomic, strong) IBOutlet UITextField *timeLoen;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *startKnap;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *rydKnap;
@property (nonatomic, strong) IBOutlet UILabel *taeller;
@property (nonatomic, strong) IBOutlet UILabel *tid;
@property (nonatomic, strong) IBOutlet UILabel *tidLabel;
@property (nonatomic, strong) IBOutlet UILabel *antalPersonerLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLoenLabel;
@property (nonatomic, strong) IBOutlet UILabel *pengeLabel;
@property (nonatomic, strong) IBOutlet UILabel *beskrivelseLabel;
@property (nonatomic, strong) IBOutlet UIButton *logKnap;
@property (nonatomic, strong) NSTimer *myTimer;
@property NSTimeInterval startInterval;
@property NSTimeInterval timePassed;
@property BOOL running;
@property (nonatomic, strong) UIPopoverController *settingPoc;
- (IBAction)showInfo:(id)sender;
- (IBAction)startCalculating;
- (IBAction)clear;
- (IBAction)showSettings:(id)sender;
-(void)updateTaeller:(NSTimer*)timer;
-(void)showPersonerWarning;
-(void)showTimeLoenWarning;
@end
