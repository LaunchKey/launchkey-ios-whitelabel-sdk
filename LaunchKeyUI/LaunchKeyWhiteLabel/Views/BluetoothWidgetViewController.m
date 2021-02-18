//
//  BluetoothWidgetViewController.m
//  LaunchKey
//
//  Created by ani on 12/22/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import "BluetoothWidgetViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AuthRequestContainer.h"
#import "LKUIConstants.h"
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import "LaunchKeyUIBundle.h"
#import "AuthenticatorManager.h"
#import <LKCAuthenticator/LKCWearablesManager.h>
#import <LKCAuthenticator/LKCErrorCode.h>

@interface BluetoothWidgetViewController ()
{
    BOOL checkComplete;
}

@end

@implementation BluetoothWidgetViewController

@synthesize imgCircle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([AuthRequestContainer appearance].imageAuthRequestBluetooth != nil)
        [_imageFactor setImage:[AuthRequestContainer appearance].imageAuthRequestBluetooth];
    else
    {
        NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
        UIImage *image = [UIImage imageNamed:@"ic_bluetooth_searching_48pt_2x" inBundle:bundle compatibleWithTraitCollection:nil];
        [_imageFactor setImage:image];
    }
    
    [self runSpinAnimationWithDuration:100.0];
    
    checkComplete = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self startBluetoothScan];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidDisappear:(BOOL)animated
{
    // Ensure wearables check is stopped if Auth Request View is left and check isn't complete
    if(!checkComplete)
        checkComplete = YES;
}

#pragma mark - Start Bluetooth Scan
-(void)startBluetoothScan
{
    [LKCWearablesManager verifyWearablesForAuthRequest:_authRequestDetails withCompletion:^(BOOL sucess, NSError *errorMessage, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
        if(sucess)
        {
            //Bluetooth is valid
            if(!checkComplete)
            {
                [self bluetoothComplete];
            }
        }
        else
        {
            //Bluetooth is invalid
            if(!checkComplete)
            {
                if([errorMessage.localizedFailureReason isEqualToString:NSLocalizedStringFromTableInBundle(@"Bluetooth_Off_Auth_Request", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
                    [self.delegate BluetoothVerified:self BluetoothVerified:NO withReason:SENSOR];
                else
                {
                    // Total # of attempts have exceeded unlink count
                    // Unlink device
                    if (errorMessage.code == WearableFailureUnlinkError)
                    {
                        [self showTempAlertForUnlink];
                    }
                    else if(autoUnlinkWarningThresholdMet)
                    {
                        [self.delegate BluetoothVerified:self BluetoothVerified:NO withReason:AUTHENTICATION];
                        
                        // Show Alert after delay to ensure warning alert is shown on failure view
                        if(attemptsRemaining == 1)
                        {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), attemptsRemaining] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One", @"Localizable", [NSBundle LaunchKeyUIBundle], nil),attemptsRemaining]];
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
                        [self.delegate BluetoothVerified:self BluetoothVerified:NO withReason:AUTHENTICATION];
                    }
                }
            }
        }
    }];
}

-(void)bluetoothComplete
{
    // Bluetooth Complete
    [self.delegate BluetoothVerified:self BluetoothVerified:YES withReason:APPROVED];
}

#pragma mark - Animation Methods
- (void) runSpinAnimationWithDuration:(CGFloat) duration;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 1 * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.speed = 0.10;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1.0;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [imgCircle.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - Show Temp Alert for Unlink
-(void)showTempAlertForUnlink
{
    // this posts a notification to the Request View Controller & responds to Auth Request w/ Failure
    [[NSNotificationCenter defaultCenter] postNotificationName:kLKUnlinkDeviceWearablesFailed object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // Show Unlink Alert in Failure View
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].thresholdAutoUnlink]];
    });
}

#pragma mark - Alert View Methods
-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * action)
                               {
                               }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
