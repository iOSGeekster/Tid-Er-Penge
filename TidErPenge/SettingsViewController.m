//
//  SettingsViewController.m
//  TidErPenge
//
//  Created by Jesper Nielsen on 19/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "TidErPengeAppDelegate.h"


@implementation SettingsViewController
@synthesize fullVersionButton;
@synthesize keepActiveSwitch;
@synthesize delegate=_delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    TidErPengeAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    keepActiveSwitch.on = delegate.keepAppActive;
#ifdef LITE
    fullVersionButton.hidden = NO;
#endif
    
}

- (void)viewDidUnload
{
    [self setFullVersionButton:nil];
    [super viewDidUnload];
    self.keepActiveSwitch = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)done:(id)sender{
    [self.delegate settingsViewControllerDidFinish:keepActiveSwitch.on];
}

- (IBAction)rateApp{
#ifdef LITE
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=475393136"]];
#else
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=448691718"]];
#endif
}

- (IBAction)buyFull:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=448691718"]];
}

@end
