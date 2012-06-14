//
//  SettingsViewController.h
//  TidErPenge
//
//  Created by Jesper Nielsen on 19/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate; 

@interface SettingsViewController : UIViewController {
    
    UISwitch *keepActiveSwitch;
}

@property (nonatomic, strong) IBOutlet UISwitch *keepActiveSwitch;
@property (nonatomic, unsafe_unretained) id <SettingsViewControllerDelegate> delegate;
-(IBAction)done:(id)sender;
- (IBAction)rateApp;
- (IBAction)buyFull:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *fullVersionButton;
@end

@protocol SettingsViewControllerDelegate <NSObject>
@required
- (void) settingsViewControllerDidFinish:(BOOL) idleDisabled;
@end