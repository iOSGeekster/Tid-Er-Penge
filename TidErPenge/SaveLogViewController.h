//
//  SaveLogViewController.h
//  TidErPenge
//
//  Created by Jesper Nielsen on 26/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SaveLogViewControllerDelegate;

@interface SaveLogViewController : UIViewController {
    IBOutlet UITextField *meetingTitle;
    IBOutlet UITextView *meetingInfo;
}
@property (nonatomic, unsafe_unretained) id<SaveLogViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextField *meetingTitle;
@property (nonatomic, strong) IBOutlet UITextView *meetingInfo;
-(IBAction)annuller:(id)sender;
-(IBAction)saveLog:(id)sender;
@end


@protocol SaveLogViewControllerDelegate <NSObject>
@required
-(void)saveControllerDidFinish:(SaveLogViewController *)controller;
-(void)saveControllerDidCancel;
@end

