//
//  FingerprintWidgetViewController.m
//  LaunchKey
//
//  Created by ani on 12/22/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import "FingerprintWidgetViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AuthRequestContainer.h"
#import "LKUIConstants.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import "AuthenticatorManager.h"
#import "LaunchKeyUIBundle.h"
#import <LKCAuthenticator/LKCFingerprintScanManager.h>
#import <LKCAuthenticator/LKCFaceScanManager.h>
#import <LKCAuthenticator/LKCErrorCode.h>

@interface FingerprintWidgetViewController ()

@end

@implementation FingerprintWidgetViewController

@synthesize btnStartScan;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set button title and set to hidden
    [btnStartScan setTitle:NSLocalizedStringFromTableInBundle(@"fingerprint_button_restart_scan", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) forState:UIControlStateNormal];
    btnStartScan.hidden = YES;
    btnStartScan.enabled = NO;

    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if([LKCFingerprintScanManager isTouchIDAvailable])
        {
            [self startFingerprintScan];
        }
        else
        {
            [self startFaceScan];
        }
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidDisappear:(BOOL)animated
{
    // Remove biometric prompt
    [LKCFingerprintScanManager invalidateTouchIDRequest];
}

- (IBAction)btnStartScanPressed:(id)sender
{
    btnStartScan.hidden = YES;
    btnStartScan.enabled = NO;
    if([LKCFingerprintScanManager isTouchIDAvailable])
    {
        [self startFingerprintScan];
    }
    else
    {
        [self startFaceScan];
    }
}

-(void)startFaceScan
{
     [LKCFaceScanManager verifyFaceScanForAuthRequest:_authRequestDetails withCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
        if(success)
        {
            [self.delegate FingerprintVerified:self FingerprintVerified:YES withAuthReason:APPROVED];
        }
        else if([error.localizedFailureReason isEqualToString:NSLocalizedStringFromTableInBundle(@"facid_error_permission", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
        {
            [self.delegate FingerprintVerified:self FingerprintVerified:NO withAuthReason:PERMISSION];
        }
        else if([error.localizedFailureReason isEqualToString:NSLocalizedStringFromTableInBundle(@"faceid_error_not_enrolled", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
        {
            [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:error.localizedFailureReason];
            btnStartScan.hidden = NO;
            btnStartScan.enabled = YES;
        }
        else
        {
            // Total # of attempts have exceeded unlink count
            // Unlink device
            if (error.code == FaceScanWrongFailureUnlinkError)
            {
                [self showTempAlertForUnlink];
            }
            else if(autoUnlinkWarningThresholdMet)
            {
                [self.delegate FingerprintVerified:self FingerprintVerified:NO withAuthReason:AUTHENTICATION];
                // Show Alert after delay to ensure warning alert is shown on failure view
                if(attemptsRemaining == 1)
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), attemptsRemaining] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), attemptsRemaining]];
                    });
                }
                else
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), attemptsRemaining] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), attemptsRemaining]];
                    });
                }
            }
            else
            {
                [self.delegate FingerprintVerified:self FingerprintVerified:NO withAuthReason:AUTHENTICATION];
            }
        }
    }];
}

-(void)startFingerprintScan
{
    [LKCFingerprintScanManager verifyFingerprintScanForAuthRequest:_authRequestDetails withCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
         if(success)
         {
             [self.delegate FingerprintVerified:self FingerprintVerified:YES withAuthReason:APPROVED];
         }
         else if([error.localizedFailureReason isEqualToString:NSLocalizedStringFromTableInBundle(@"biometric_cancel_error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)] && [LKCFingerprintScanManager isTouchIDAvailable])
         {
             // Show Restart Scan Button
             btnStartScan.hidden = NO;
             btnStartScan.enabled = YES;
         }
        else if([error.localizedFailureReason isEqualToString:NSLocalizedStringFromTableInBundle(@"touchid_error_not_enrolled", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
        {
            [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:error.localizedFailureReason];
            btnStartScan.hidden = NO;
            btnStartScan.enabled = YES;
        }
        else
         {
             if([LKCFingerprintScanManager isTouchIDAvailable] || [error.localizedFailureReason isEqualToString:NSLocalizedStringFromTableInBundle(@"fingerprint_error_lockout", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
             {
                 // Total # of attempts have exceeded unlink count
                 // Unlink device
                 if (error.code == FingerprintScanWrongFailureUnlinkError)
                 {
                     [self showTempAlertForUnlink];
                 }
                 else if(autoUnlinkWarningThresholdMet)
                 {
                     [self.delegate FingerprintVerified:self FingerprintVerified:NO withAuthReason:AUTHENTICATION];
                     // Show Alert after delay to ensure warning alert is shown on failure view
                     if(attemptsRemaining == 1)
                     {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             
                             [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), attemptsRemaining] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), attemptsRemaining]];
                         });
                     }
                     else
                     {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             
                             [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), attemptsRemaining] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), attemptsRemaining]];
                         });
                     }
                 }
                 else
                 {
                     [self.delegate FingerprintVerified:self FingerprintVerified:NO withAuthReason:AUTHENTICATION];
                 }
             }
         }
     }];
}

#pragma mark - Show Temp Alert for Unlink
-(void)showTempAlertForUnlink
{
    // this posts a notification to the Request View Controller & responds to Auth Request w/ Failure
    if([LKCFingerprintScanManager isTouchIDAvailable])
        [[NSNotificationCenter defaultCenter] postNotificationName:kLKUnlinkDeviceFingerprintFailed object:nil];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:kLKUnlinkDeviceFaceFailed object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Show Unlink Alert in Failure View
        if([LKCFingerprintScanManager isTouchIDAvailable])
            [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].thresholdAutoUnlink]];
        else
            [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].thresholdAutoUnlink]];
    });
}

#pragma mark - Show Alert
-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message
{
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
