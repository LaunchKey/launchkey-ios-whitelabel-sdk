//
//  SettingsViewController.h
//  WhiteLabel
//
//  Created by ani on 4/27/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticatorButton.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>

@interface SettingsViewController : UIViewController

@property AuthMethodType mode;
@property (weak, nonatomic) IBOutlet AuthenticatorButton *btnRemove;
@property (weak, nonatomic) IBOutlet UISwitch *switchVerify;
@property (weak, nonatomic) IBOutlet UILabel *labelVerify;
@property (weak, nonatomic) IBOutlet UITableView *tblFactors;
@property (weak, nonatomic) IBOutlet UILabel *labelChangeEffectiveIn;
@property (weak, nonatomic) IBOutlet UILabel *labelRemove;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end
