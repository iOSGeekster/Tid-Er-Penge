//
//  ShowLogViewController.h
//  TidErPenge
//
//  Created by Jesper Nielsen on 10/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"

@interface ShowLogViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>{
    NSString *selectedLog;
    IBOutlet UILabel *titelLabel;
    IBOutlet UILabel *forbrugLabel;
    IBOutlet UILabel *tidLabel;
    IBOutlet UILabel *datoLabel;
    IBOutlet UILabel *antalPersonerLabel;
    IBOutlet UITextView *infoText;

}
@property (nonatomic, strong) NSString *selectedLog;
@property (nonatomic, strong) IBOutlet UILabel *titelLabel;
@property (nonatomic, strong) IBOutlet UILabel *forbrugLabel;
@property (nonatomic, strong) IBOutlet UILabel *tidLabel;
@property (nonatomic, strong) IBOutlet UILabel *datoLabel;
@property (nonatomic, strong) IBOutlet UILabel *antalPersonerLabel;
@property (nonatomic, strong) IBOutlet UITextView *infoText;
-(id)initWithLogString:(NSString*)log;
@end
