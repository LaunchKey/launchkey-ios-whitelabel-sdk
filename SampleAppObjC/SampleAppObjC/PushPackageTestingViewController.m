//
//  PushPackageTestingViewController.m
//  SampleAppObjC
//
//  Created by Steven Gerhard on 7/16/19.
//  Copyright © 2019 LaunchKey. All rights reserved.
//

#import "PushPackageTestingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PushPackageTestingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTestPushPackage;
@property (strong, nonatomic) IBOutlet UITextField *pushPackageTextField;
@end

@implementation PushPackageTestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        _pushPackageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Push Package" attributes:@{NSForegroundColorAttributeName:[UIColor colorNamed:@"placeholderTextColor"]}];
        _labelTestPushPackage.textColor = [UIColor colorNamed:@"viewTextColor"];

    } else {
        _pushPackageTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Push Package" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        _labelTestPushPackage.textColor = [UIColor blackColor];
    }
}

- (IBAction)pressedSubmitButton:(UIButton *)sender {
    NSString *text = [[self pushPackageTextField] text];
    if (text != nil) {
        if (text.length > 0) {
            [[LKCAuthenticatorManager sharedClient] handleThirdPartyPushPackage:text];
        }
    }
        
}

@end
