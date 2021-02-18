//
//  SecurityPINCodeViewController.h
//  LaunchKey
//
//  Created by ani on 12/2/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PINCodeViewController.h"

@interface SecurityPINCodeViewController : UIViewController <PINCodeViewControllerDelegate>

@property (nonatomic, strong) NSMutableString *PINCodeString;
@property BOOL PINisValid;
@property BOOL fromAdd;
@property BOOL fromRemove;
@property BOOL fromVerifySwitch;
@property (weak, nonatomic) IBOutlet UILabel *labelVerifyPINCode;
@property (weak, nonatomic) IBOutlet UILabel *labelEnterPINCode;
@property (weak, nonatomic) IBOutlet UISwitch *switchVerify;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomConstraint;

@end
