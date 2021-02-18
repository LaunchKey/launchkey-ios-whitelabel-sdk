//
//  SecurityFingerprintViewController.h
//  LaunchKey
//
//  Created by ani on 12/15/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticatorButton.h"

@interface SecurityFingerprintViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *switchVerify;
@property (weak, nonatomic) IBOutlet UILabel *labelVerify;
@property (weak, nonatomic) IBOutlet UILabel *labelScan;
@property (weak, nonatomic) IBOutlet AuthenticatorButton *btnStartScan;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;


@end
