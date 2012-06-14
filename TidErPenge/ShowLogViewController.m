//
//  ShowLogViewController.m
//  TidErPenge
//
//  Created by Jesper Nielsen on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowLogViewController.h"
#import "Twitter/TWTweetComposeViewController.h"
#define kTwitterMsgLength 140
#define kTwitterMsgTruncate 137
@interface ShowLogViewController (Private) {
@private
}
- (void)twitterPressed;
- (void)mailButtonPressed;
- (void)smsButtonPressed;
@end

@implementation ShowLogViewController
@synthesize selectedLog,titelLabel,forbrugLabel,tidLabel,datoLabel,infoText,antalPersonerLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLogString:(NSString *)log
{
    self = [super init];
    if (self) {
        selectedLog = log;
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    // Do any additional setup after loading the view from its nib.
    NSArray *components = [selectedLog componentsSeparatedByString:@";"];
    self.navigationItem.title = NSLocalizedString(@"Meeting", nil);
    if ([components count] == 6) {
        self.datoLabel.text = [components objectAtIndex:0];
        self.tidLabel.text = [components objectAtIndex:1];
        self.antalPersonerLabel.text = [components objectAtIndex:2];
        self.forbrugLabel.text = [components objectAtIndex:3];
        self.titelLabel.text = [components objectAtIndex:4];
        self.infoText.text = [components objectAtIndex:5];

    }else{
        self.datoLabel.text = [components objectAtIndex:0];
        self.tidLabel.text = [components objectAtIndex:1];
        self.antalPersonerLabel.text = [components objectAtIndex:2];
        self.forbrugLabel.text = [components objectAtIndex:3];

        self.titelLabel.text = NSLocalizedString(@"NoTitle", nil);
        self.infoText.text = NSLocalizedString(@"NoInfo", nil);
    }

    
}

- (void)viewDidUnload
{
 
    [super viewDidUnload];
    antalPersonerLabel = nil;
    datoLabel = nil;
    infoText = nil;
    tidLabel = nil;
    forbrugLabel = nil;
    titelLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)shareButtonPressed:(id)sender{
    UIActionSheet *shareSheet = [[UIActionSheet new] initWithTitle:NSLocalizedString(@"ShareTitle", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Twitter",NSLocalizedString(@"ShareSMS", nil), NSLocalizedString(@"ShareMail", nil), nil];
    [shareSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        if (buttonIndex == 0) {
            [self twitterPressed];
        } else if (buttonIndex == 1) {
            [self smsButtonPressed];
        }else if(buttonIndex == 2){
            [self mailButtonPressed];
        }
    }
}

#pragma mark MessageCompose methods

- (void)twitterPressed {
        TWTweetComposeViewController *controller = [TWTweetComposeViewController new];
    NSString *tweetString = [[NSLocalizedString(@"TimeIsMoney", nil) stringByAppendingString:@":\n"] stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"LogMsg", nil),self.titelLabel.text,datoLabel.text,forbrugLabel.text,tidLabel.text,antalPersonerLabel.text,infoText.text]];
    if ([tweetString length] > kTwitterMsgLength) {
        NSString *truncated = [tweetString substringToIndex:kTwitterMsgTruncate];
        truncated = [truncated stringByAppendingString:@"..."];
        [controller setInitialText:truncated];
    }else{
        [controller setInitialText:tweetString];
    }
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)mailButtonPressed {
    MFMailComposeViewController *controller = [MFMailComposeViewController new];
    [controller setSubject:NSLocalizedString(@"TimeIsMoney", nil)];
    [controller setMessageBody:[NSString stringWithFormat:NSLocalizedString(@"LogMsg", nil),self.titelLabel.text,datoLabel.text,forbrugLabel.text,tidLabel.text,antalPersonerLabel.text,infoText.text] isHTML:NO];
    controller.mailComposeDelegate = self;
    [self presentModalViewController:controller animated:YES];

}

- (void)smsButtonPressed {
    MFMessageComposeViewController *controller = [MFMessageComposeViewController new];
    controller.body = [NSString stringWithFormat:NSLocalizedString(@"LogMsg", nil),self.titelLabel.text,datoLabel.text,forbrugLabel.text,tidLabel.text,antalPersonerLabel.text,infoText.text];
    controller.messageComposeDelegate = self;
    [self presentModalViewController:controller animated:YES];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    UIAlertView *alertView = [[UIAlertView new] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    switch (result) {
        case MessageComposeResultSent:
            alertView.title = NSLocalizedString(@"MsgSentTitle", nil);
            alertView.message = NSLocalizedString(@"MsgSent", nil);
            [alertView show];
            break;
        case MessageComposeResultFailed:
            alertView.title = NSLocalizedString(@"Error", nil);
            alertView.message = NSLocalizedString(@"MsgNotSent", nil);
            [alertView show];
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    UIAlertView *alertView = [[UIAlertView new] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    switch (result) {
        case MFMailComposeResultSent:
            alertView.title = NSLocalizedString(@"MailSentTitle", nil);
            alertView.message = NSLocalizedString(@"MailSent", nil);
            [alertView show];
            break;
            
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
