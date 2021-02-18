//
//  SecurityFingerprintViewController.m
//  LaunchKey
//
//  Created by ani on 12/15/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import "SecurityFingerprintViewController.h"
#import "SecurityViewController.h"
#import <LKCAuthenticator/LKCAuthenticator.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import "AuthenticatorManager.h"
#import "LaunchKeyUIBundle.h"
#import <LKCAuthenticator/LKCFingerprintScanManager.h>
#import <LKCAuthenticator/LKCFaceScanManager.h>

@interface SecurityFingerprintViewController ()
{
    BOOL isFingerprintScan;
}
@end

@implementation SecurityFingerprintViewController

@synthesize labelScan, labelVerify, btnStartScan;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UIButton *rightHelp = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [rightHelp addTarget:self action:@selector(helpPressed:) forControlEvents:UIControlEventTouchDown];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableInfoButtons)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightHelp];

    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
    {
        [labelScan setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:16]];
        [labelVerify setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:16]];
    }

    btnStartScan.titleLabel.numberOfLines = 1;
    btnStartScan.titleLabel.adjustsFontSizeToFitWidth = YES;
    btnStartScan.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    _viewHeader.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].controlsBackgroundColor;
    
    isFingerprintScan = [LKCFingerprintScanManager isTouchIDAvailable];
    
    if(!isFingerprintScan)
    {
        [btnStartScan setTitle:NSLocalizedStringFromTableInBundle(@"faceid_add_button_scan_text", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forState:UIControlStateNormal];

        self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"faceid_add", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        labelScan.text = NSLocalizedStringFromTableInBundle(@"faceid_security_scanrequired", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    else
    {
        [btnStartScan setTitle:NSLocalizedStringFromTableInBundle(@"fingerprint_add_button_scan_text", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forState:UIControlStateNormal];

        self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"fingerprint_add", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        labelScan.text = NSLocalizedStringFromTableInBundle(@"security_fingerprint_scanrequired", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }

    labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    [self.switchVerify addTarget:self
                          action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Set Color Configurations
    labelVerify.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
    labelScan.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Menu Methods
-(void)doneSelected:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)helpPressed:(id)sender
{
    NSString *alertTitle = @"";
    NSString *alertMessage = @"";
    
    if(!isFingerprintScan)
    {
        alertTitle = NSLocalizedStringFromTableInBundle(@"About_Face_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        alertMessage = NSLocalizedStringFromTableInBundle(@"help_security_add_faceid", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    else
    {
        alertTitle = NSLocalizedStringFromTableInBundle(@"About_Fingerprint_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        alertMessage = NSLocalizedStringFromTableInBundle(@"help_security_add_finger", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    
    [self showAlertViewWithTitle:alertTitle withMessage:alertMessage];
}

#pragma mark - Button Methods
- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn])
    {
        labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    else
    {
        labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
}
- (IBAction)btnStartScanPressed:(id)sender
{
    FlagState state = ([_switchVerify isOn]) ? ALWAYS : WHENREQUIRED;
    
    if(isFingerprintScan)
    {
        [LKCFingerprintScanManager setFingerprintScanWithVerificationFlag:state withCompletion:^(BOOL success, NSError *error) {
            
            if(success)
                [self doneSelected:self];
            else
                [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:error.localizedFailureReason];
        }];
    }
    else
    {
        [LKCFaceScanManager setFaceScanWithVerificationFlag:state withCompletion:^(BOOL success, NSError *error) {
            
            if(success)
                [self doneSelected:self];
            else
                [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:error.localizedFailureReason];
        }];
    }
}

#pragma mark - Show Alert
-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message
{
    if(UIAccessibilityIsVoiceOverRunning())
    {
        title = @"";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_OK", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * action)
                               {
                               }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
