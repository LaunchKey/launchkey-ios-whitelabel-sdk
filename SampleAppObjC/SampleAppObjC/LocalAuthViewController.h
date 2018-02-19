//
//  LocalAuthViewController.h
//  WhiteLabelDemoApp
//
//  Created by ani on 12/8/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalAuthViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tfCountInput;
@property (weak, nonatomic) IBOutlet UISwitch *switchCount;
@property (weak, nonatomic) IBOutlet UISwitch *switchType;
@property (weak, nonatomic) IBOutlet UISwitch *switchKnowledge;
@property (weak, nonatomic) IBOutlet UISwitch *switchInherence;
@property (weak, nonatomic) IBOutlet UISwitch *switchPossession;
@property (weak, nonatomic) IBOutlet UIButton *btnGenerateAuth;
@property (weak, nonatomic) IBOutlet UITextField *tfLARName;
@property (weak, nonatomic) IBOutlet UITextField *tfExpirationDuration;

@end
