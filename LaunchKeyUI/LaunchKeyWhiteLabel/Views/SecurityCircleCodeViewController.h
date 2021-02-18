//
//  SecurityCircleCodeViewController.h
//  LaunchKey
//
//  Created by ani on 12/14/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecurityCircleCodeViewController : UIViewController

@property BOOL fromAdd, fromRemove, fromVerifySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *switchVerify;
@property (weak, nonatomic) IBOutlet UILabel *labelVerify;
@property (weak, nonatomic) IBOutlet UILabel *labelEnterCode;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomConstraint;

@end
