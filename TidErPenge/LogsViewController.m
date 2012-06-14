//
//  FlipsideViewController.m
//  HvadKosterMoedet
//
//  Created by Jesper Nielsen on 30/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogsViewController.h"
#import "TidErPengeAppDelegate.h"
#import "ShowLogViewController.h"
#import "MessageUI/MessageUI.h"

@interface LogsViewController (Private)
-(void)setupNavbarAndToolbar;
- (void)hideTopBanner:(UIView *)banner;
- (void)showTopBanner:(UIView *)banner;
@end

@implementation LogsViewController
@synthesize delegate=_delegate,logsTable,logsTableData,iAdBannerView,gAdBannerView;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    TidErPengeAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    logsTableData = delegate.logsData;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    [self setupNavbarAndToolbar];
#ifdef LITE
    if([ADBannerView respondsToSelector:@selector(class)]) {
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        iAdBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -bannerSize.height, bannerSize.width, bannerSize.height)];
        iAdBannerView.delegate = self;
        iAdBannerView.hidden = YES;
        [self.view addSubview:iAdBannerView]; 
    }
    
    gAdBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, -GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    gAdBannerView.adUnitID = @"a14f50dbd767a96";
    gAdBannerView.hidden = YES;
    gAdBannerView.rootViewController = self;
    [self.view addSubview:gAdBannerView];
#endif
}

- (void)setupNavbarAndToolbar
{
    UIBarButtonItem *editButton = [[UIBarButtonItem new] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(editLogs)];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem new] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = editButton;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.topItem.title = @"Log";
    
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *deleteSingleButton = [[UIBarButtonItem new] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteSelectedLogs)];
    UIBarButtonItem *deleteAllButton = [[UIBarButtonItem new] initWithTitle:NSLocalizedString(@"DeleteAll", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAllLogs)];
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem new] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:[NSArray arrayWithObjects:deleteSingleButton,flexibleSpace,deleteAllButton, nil] animated:NO];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    logsTable = nil;
    logsTableData = nil;
    iAdBannerView = nil;
    gAdBannerView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate logsViewControllerDidFinish:self];
}

- (IBAction)editLogs{
    [self.logsTable setEditing:!self.logsTable.editing animated:YES];
    if (self.logsTable.editing) {
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Cancel", nil)];
        self.navigationController.toolbarHidden = NO;
#ifdef LITE
        self.logsTable.frame = CGRectMake(0, 50, 320, 322);
#else
        self.logsTable.frame  = CGRectMake(0, 0, 320, 372);
#endif
    }else{
        [self.navigationController setToolbarHidden:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Edit", nil)];
        self.navigationController.toolbarHidden = YES;
#ifdef LITE
        self.logsTable.frame = CGRectMake(0, 50, 320, 366);
#else
        self.logsTable.frame  = CGRectMake(0, 0, 320, 416);        
#endif
    }
}


- (void)deleteSelectedLogs{
    NSArray *selectedLogs = [self.logsTable indexPathsForSelectedRows];
    TidErPengeAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    for (NSIndexPath *indexPath in selectedLogs) {
        NSUInteger row = [logsTableData count] - indexPath.row - 1;
        [delegate removeSingleLog:row];
    }
    [self.logsTable deleteRowsAtIndexPaths:selectedLogs withRowAnimation:UITableViewRowAnimationFade];
    [self editLogs];
}

- (void)deleteAllLogs{
    if ([logsTableData count] == 0) {
        UIAlertView *rydAlert = [[UIAlertView new] initWithTitle:NSLocalizedString(@"NothingToClear", nil) message:NSLocalizedString(@"LogEmpty", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [rydAlert show];
    }else{
        UIActionSheet *sheet = [[UIActionSheet new] initWithTitle:NSLocalizedString(@"Sure", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Yes", nil) otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        TidErPengeAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        if ([delegate.logsData count] > 0) {
            [delegate removeLogData];
            [self.logsTable reloadData];
            [self editLogs];
        }
    }
}

#pragma mark - UITable methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [logsTableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [logsTable dequeueReusableCellWithIdentifier:@"cell"];
	if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
	}
    NSString *log = [logsTableData objectAtIndex:[logsTableData count] - indexPath.row -1];
    NSArray *components = [log componentsSeparatedByString:@";"];
    NSString *headLine;
    if ([components count] > 4) {
        headLine = [NSString stringWithFormat:NSLocalizedString(@"LogHeadline", nil),[components objectAtIndex:0],[components objectAtIndex:4]];
    }else{
        headLine = [NSString stringWithFormat:NSLocalizedString(@"LogHeadline", nil),[components objectAtIndex:0],NSLocalizedString(@"NoTitle", nil)];
    }
    
    NSString *subtitle = [NSString stringWithFormat:NSLocalizedString(@"LogSubtitle", nil),[components objectAtIndex:3], [components objectAtIndex:1]];
    cell.textLabel.text = headLine;
    cell.detailTextLabel.text = subtitle;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.logsTable.editing) {
        NSString *log = [logsTableData objectAtIndex:[logsTableData count] - indexPath.row - 1];
        ShowLogViewController *showLog = [[ShowLogViewController alloc] initWithLogString:log];
        [self.navigationController pushViewController:showLog animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"Delete", nil);
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 3;//Multi row selection
//    return UITableViewCellEditingStyleDelete;
}

#pragma mark iAd methods
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
#ifdef LITE
    //if([iAdBannerView isHidden]){
        [self hideTopBanner:gAdBannerView];
        [self showTopBanner:banner];
    //}
    
#endif
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
#ifdef LITE
    [gAdBannerView loadRequest:[GADRequest request]];
    [self hideTopBanner:iAdBannerView];
    [self showTopBanner:gAdBannerView];
#endif
}

#pragma mark AdMob methods

- (void) adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error{
    [self hideTopBanner:banner];
}

- (void) adViewDidReceiveAd:(GADBannerView *)banner{
    if ([iAdBannerView isHidden]) {
        [self showTopBanner:banner];
    }
}


- (void)hideTopBanner:(UIView *)banner{
    if (banner && ![banner isHidden]) {
        [UIView beginAnimations:@"bannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        self.logsTable.frame = CGRectMake(0, 0, 320, 416);
        [UIView commitAnimations];
        banner.hidden = YES;
    }
}

- (void)showTopBanner:(UIView *)banner{
    if (banner && [banner isHidden]) {
        [UIView beginAnimations:@"bannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        CGRect newTableSize = CGRectMake(0, 50, 320, 370);
        self.logsTable.frame = newTableSize;
        [UIView commitAnimations];
        banner.hidden = NO;
    }
}

@end
