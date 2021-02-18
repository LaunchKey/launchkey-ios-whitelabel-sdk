//
//  LocationsWidgetViewController.m
//  Authenticator
//
//  Created by ani on 4/2/19.
//  Copyright © 2019 LaunchKey. All rights reserved.
//

#import "LocationsWidgetViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AuthRequestContainer.h"
#import "LKUIConstants.h"
#import "LaunchKeyUIBundle.h"
#import <LKCAuthenticator/LKCLocationsManager.h>
#import <LKCAuthenticator/LKCErrorCode.h>

@interface LocationsWidgetViewController ()
{
    BOOL checkComplete;
}

@end

@implementation LocationsWidgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([AuthRequestContainer appearance].imageAuthRequestGeofence != nil)
        [_imageFactor setImage:[AuthRequestContainer appearance].imageAuthRequestGeofence];
    else
    {
        NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
        UIImage *image = [UIImage imageNamed:@"ic_place_48pt_2x" inBundle:bundle compatibleWithTraitCollection:nil];
        [_imageFactor setImage:image];
    }
    
    [self runSpinAnimationWithDuration:100.0];
    
    checkComplete = NO;
    
    // Start checking for locations after 1 second for UX
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startLookingForFence];
    });
}

-(void)viewDidDisappear:(BOOL)animated
{
    // Ensure geo-fence check is stopped if Auth Request View is left and check isn't complete
    if(!checkComplete)
    {
        [LKCLocationsManager stopLocationsScanning];
        checkComplete = YES;
    }
}

#pragma mark - Start Fence Scan
-(void)startLookingForFence
{
    [LKCLocationsManager verifyLocationsForAuthRequest:_authRequestDetails withCompletion:^(BOOL sucess, NSError *errorMessage, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
        if(sucess)
        {
            //Fence is valid
            if(!checkComplete)
            {
                checkComplete = YES;
                [self locationsCheckComplete];
            }
        }
        else
        {
            // GeoFence invalid
            if(!checkComplete)
            {
                checkComplete = YES;
                
                if([errorMessage.localizedFailureReason isEqualToString:NSLocalizedStringFromTableInBundle(@"Orbit_Location_Off", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
                {
                    [self.delegate locationsVerified:self locationVerified:NO withAuthResponseReason:PERMISSION];
                }
                else if([errorMessage.localizedFailureReason
                         isEqualToString:NSLocalizedStringFromTableInBundle(@"Orbit_Location_Services_Off", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
                {
                    [self.delegate locationsVerified:self locationVerified:NO withAuthResponseReason:SENSOR];
                }
                else
                {
                    // Total # of attempts have exceeded unlink count
                    // Unlink device
                    if (errorMessage.code == LocationFailureUnlinkError)
                    {
                        [self showTempAlertForUnlink];
                    }
                    else if(autoUnlinkWarningThresholdMet)
                    {
                        [self.delegate locationsVerified:self locationVerified:NO withAuthResponseReason:AUTHENTICATION];

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
                        [self.delegate locationsVerified:self locationVerified:NO withAuthResponseReason:AUTHENTICATION];
                    }
                }
            }
        }
    }];
}

-(void)locationsCheckComplete
{
    // Locations Check Complete
    [self.delegate locationsVerified:self locationVerified:YES withAuthResponseReason:APPROVED];
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
    
    [_imgBorder.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - Show Temp Alert for Unlink
-(void)showTempAlertForUnlink
{
    // this posts a notification to the Request View Controller & responds to Auth Request w/ Failure
     [[NSNotificationCenter defaultCenter] postNotificationName:kLKUnlinkDeviceLocationsFailed object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Show Unlink Alert in Failure View
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [[LKCAuthenticatorManager sharedClient] getAuthenticatorConfigInstance].thresholdAutoUnlink]];
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
