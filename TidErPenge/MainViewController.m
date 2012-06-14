//
//  MainViewController.m
//  HvadKosterMoedet
//
//  Created by Jesper Nielsen on 30/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "TidErPengeAppDelegate.h"
#import "MessageUI/MessageUI.h"
#import <CoreMotion/CoreMotion.h>
#define kProVersionAlert 1
#define kFullSaveAlert 2
#define kLiteSaveAlert 3

@implementation MainViewController
@synthesize antalPersoner,timeLoen,startKnap,rydKnap,taeller,tid,myTimer,tidLabel,antalPersonerLabel,timeLoenLabel,pengeLabel,logKnap,startInterval,timePassed,beskrivelseLabel;
@synthesize running, settingPoc;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *separator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setGroupingSeparator:separator];
    taeller.text = [formatter stringFromNumber:[NSNumber numberWithDouble:0.0]];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)logsViewControllerDidFinish:(LogsViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{
    //Keeping this code for future reference
/*#ifdef LITE
    UIAlertView *liteVersionAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NotAvailable", nil) message:NSLocalizedString(@"Feature", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:NSLocalizedString(@"Upgrade", nil), nil];
    liteVersionAlert.tag = kProVersionAlert;
    [liteVersionAlert show];
    [liteVersionAlert release];
    return;
#endif*/
    LogsViewController *controller = [[LogsViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    controller.delegate = self;
    
    //controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (IBAction)showSettings:(id)sender{
    SettingsViewController *controller = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
    controller.delegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIPopoverController *settingPopover = [[UIPopoverController alloc] initWithContentViewController:controller];
        settingPopover.popoverContentSize = CGSizeMake(320, 400);
        CGRect pos = CGRectMake(30, 947, 44, 44);
        [settingPopover presentPopoverFromRect:pos inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        self.settingPoc = settingPopover;
    }else{
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:controller animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.taeller.frame = CGRectMake(79, 60, 313, 176);
        self.taeller.font = [UIFont fontWithName:@"Futura" size:72.0];
        [self.taeller setTextAlignment:UITextAlignmentCenter];
        self.timeLoen.hidden = YES;
        self.antalPersoner.hidden = YES;
        self.timeLoenLabel.hidden = YES;
        self.pengeLabel.hidden = YES;
        self.antalPersonerLabel.hidden = YES;
        self.tid.hidden = YES;
        self.tidLabel.hidden = YES;
        self.logKnap.hidden = YES;
        self.beskrivelseLabel.hidden = YES;
    } else {
        self.taeller.frame = CGRectMake(79, 99, 162, 50);
        self.taeller.font = [UIFont fontWithName:@"Futura" size:36.0];
        [self.taeller setTextAlignment:UITextAlignmentRight];
        self.timeLoen.hidden = NO;
        self.antalPersoner.hidden = NO;
        self.timeLoenLabel.hidden = NO;
        self.pengeLabel.hidden = NO;
        self.antalPersonerLabel.hidden = NO;
        self.tid.hidden = NO;
        self.tidLabel.hidden = NO;
        self.logKnap.hidden = NO;
        self.beskrivelseLabel.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


-(void)startCalculating{
    if(!self.running){
        if ([self.antalPersoner.text intValue] == 0) {
            [self showPersonerWarning];
            return;
        }
        if ([self.timeLoen.text intValue] == 0) {
            [self showTimeLoenWarning];
            return;
        }
        self.running = YES;
        [self.antalPersoner resignFirstResponder];
        [self.antalPersoner setEnabled:NO];
        [self.timeLoen resignFirstResponder];
        [self.timeLoen setEnabled:NO]; 
        [self.startKnap setTintColor:[UIColor redColor]];
        hourlyBurn = [antalPersoner.text doubleValue] * [timeLoen.text doubleValue];
        burnPrSecond = hourlyBurn/60/60/10;
        spent = 0.0;
        
        self.taeller.text = @"0,0";
        self.startKnap.title = @"Stop";
        self.rydKnap.enabled = NO;
        startInterval = [NSDate timeIntervalSinceReferenceDate];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTaeller:) userInfo:nil repeats:YES];
        
    } else if(self.running){
        self.running = NO;
        timePassed = [NSDate timeIntervalSinceReferenceDate] - startInterval;
        [myTimer setFireDate:[NSDate distantFuture]];
        [self becomeFirstResponder];
        [self.antalPersoner setEnabled:YES];
        [self.timeLoen setEnabled:YES];
//#ifdef LITE
       /* UIAlertView *resultat = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Result", nil) message:[NSString stringWithFormat:NSLocalizedString(@"ResultTxt", nil),self.tid.text,self.taeller.text] delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:NSLocalizedString(@"Resume", nil), nil];
        resultat.tag = kLiteSaveAlert; */
//#else
        UIAlertView *resultat = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Result", nil) message:[NSString stringWithFormat:NSLocalizedString(@"ResultTxt", nil),self.tid.text,self.taeller.text] delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:NSLocalizedString(@"SaveLog", nil),NSLocalizedString(@"Resume", nil), nil];
        resultat.tag = kFullSaveAlert;
//#endif
        [resultat show];
        
    }
}

-(void)updateTaeller:(NSTimer*)timer{
    stopInterval = [NSDate timeIntervalSinceReferenceDate];
    elapsedInterval = stopInterval - startInterval;
    int seconds = fmod(elapsedInterval, 60);
    int minutes = fmod(elapsedInterval/60, 60);
    int hours = elapsedInterval/60/60;
    NSString *elapsedTime = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    spent = (burnPrSecond*(elapsedInterval*10));
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *separator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setGroupingSeparator:separator];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setGroupingSize:3];
    self.tid.text = elapsedTime;    
    self.taeller.text = [formatter stringFromNumber:[NSNumber numberWithDouble:spent]];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.antalPersoner resignFirstResponder];
    [self.timeLoen resignFirstResponder];
    [self becomeFirstResponder];
}

-(void)showPersonerWarning{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"PersonWarningTitle", nil) message:NSLocalizedString(@"PersonWarningMsg", nil) delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
    [alert show];
}

-(void)showTimeLoenWarning{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SalaryWarningTitle", nil) message:NSLocalizedString(@"SalaryWarningMsg", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(IBAction)clear{
    self.antalPersoner.text = @"";
    self.timeLoen.text = @"";
    self.tid.text = @"00:00:00";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *separator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];

    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setGroupingSeparator:separator];
    taeller.text = [formatter stringFromNumber:[NSNumber numberWithDouble:0.0]];
    [self becomeFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case kFullSaveAlert:
            if (buttonIndex == 1) {
                [myTimer invalidate];
                [self.startKnap setTintColor:nil];
//r                [self.startKnap setStyle:UIBarButtonItemStyleDone];
                self.startKnap.title = @"Start";
                self.rydKnap.enabled = YES;
                SaveLogViewController *saveController = [[SaveLogViewController alloc] initWithNibName:@"SaveLogView" bundle:nil];
                saveController.delegate = self;
                saveController.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [self presentModalViewController:saveController animated:YES];
            } else if (buttonIndex == 2){
                self.running = YES;
                startInterval = [NSDate timeIntervalSinceReferenceDate] - timePassed;
                [myTimer setFireDate:[NSDate date]];
                return;
            } else if (buttonIndex == 0){
                if (![myTimer isValid]) {
                    [myTimer invalidate];
                }
                [self.startKnap setTintColor:nil];
//                [self.startKnap setStyle:UIBarButtonItemStyleDone];
                self.startKnap.title = @"Start";
                self.rydKnap.enabled = YES;
                
            }
            break;
        case kLiteSaveAlert:
            if (buttonIndex == 1) {
                self.running = YES;
                startInterval = [NSDate timeIntervalSinceReferenceDate] - timePassed;
                [myTimer setFireDate:[NSDate date]];
                return;
            } else if (buttonIndex == 0){
                if (![myTimer isValid]) {
                    [myTimer invalidate];
                }
//                [self.startKnap setStyle:UIBarButtonItemStyleDone];
                self.startKnap.title = @"Start";
                self.rydKnap.enabled = YES;
            }
            break;
        case kProVersionAlert:
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=448691718"]];
            }
            break;
        default:
            break;
    }
}

-(void)saveControllerDidFinish:(SaveLogViewController*)controller{
    
    TidErPengeAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSDate *today = [NSDate new];
    NSString *date = [formatter stringFromDate:today];
    NSString *log = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@",date,self.tid.text,self.antalPersoner.text,self.taeller.text,controller.meetingTitle.text,controller.meetingInfo.text];
    [delegate saveLog:log];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)saveControllerDidCancel{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)settingsViewControllerDidFinish:(BOOL) idleDisabled{
    TidErPengeAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [[UIApplication sharedApplication] setIdleTimerDisabled:idleDisabled];
    delegate.keepAppActive = idleDisabled;
    [delegate saveIdleSetting:idleDisabled];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self.settingPoc dismissPopoverAnimated:YES];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark Motion method
-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(motion == UIEventSubtypeMotionShake && (!self.running)){
        [self clear];
    }
    [self becomeFirstResponder];
}

@end
