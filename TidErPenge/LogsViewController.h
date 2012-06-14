//
//  FlipsideViewController.h
//  HvadKosterMoedet
//
//  Created by Jesper Nielsen on 30/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowLogViewController.h"
#import "iAd/ADBannerView.h"
#import "GADBannerView.h"


@protocol LogsViewControllerDelegate;

@interface LogsViewController : UIViewController <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate, GADBannerViewDelegate> {
    UITableView *logsTable;
    NSMutableArray *logsTableData;
}

@property (nonatomic, unsafe_unretained) id <LogsViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITableView *logsTable;
@property (nonatomic, strong) NSMutableArray *logsTableData;
@property (nonatomic, strong) ADBannerView *iAdBannerView;
@property (nonatomic, strong) GADBannerView *gAdBannerView;
- (IBAction)done:(id)sender;
- (IBAction)editLogs;
@end


@protocol LogsViewControllerDelegate
- (void)logsViewControllerDidFinish:(LogsViewController *)controller;
@end
