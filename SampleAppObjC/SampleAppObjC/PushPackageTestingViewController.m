//
//  PushPackageTestingViewController.m
//  SampleAppObjC
//
//  Created by Steven Gerhard on 7/16/19.
//  Copyright © 2019 LaunchKey. All rights reserved.
//

#import "PushPackageTestingViewController.h"

@interface PushPackageTestingViewController ()
@property (strong, nonatomic) IBOutlet UITextField *pushPackageTextField;
@end

@implementation PushPackageTestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)pressedSubmitButton:(UIButton *)sender {
    NSString *text = [[self pushPackageTextField] text];
    if (text != nil) {
        if (text.length > 0) {
            [[AuthenticatorManager sharedClient] handlePushPackage:text];
        }
    }
        
}

@end
