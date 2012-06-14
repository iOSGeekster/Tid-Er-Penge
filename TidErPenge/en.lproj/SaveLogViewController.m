//
//  SaveLogViewController.m
//  TidErPenge
//
//  Created by Jesper Nielsen on 26/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaveLogViewController.h"

@implementation SaveLogViewController
@synthesize delegate,meetingTitle,meetingInfo;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    meetingTitle = nil;
    meetingInfo = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)annuller:(id)sender
{
    [self.delegate saveControllerDidCancel];
}

- (IBAction)saveLog:(id)sender
{
    if ([self.meetingTitle.text isEqualToString:@""]) {
         UIAlertView *noTitleAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"EnterTitle", nil) message:NSLocalizedString(@"EnterTitleMsg", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noTitleAlert show];
        return;
    }
    [self.delegate saveControllerDidFinish:self];
}

@end
