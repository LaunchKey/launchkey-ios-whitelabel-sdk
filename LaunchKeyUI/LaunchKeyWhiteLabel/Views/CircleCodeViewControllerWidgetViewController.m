//
//  CircleCodeViewControllerWidgetViewController.m
//  LaunchKey
//
//  Created by ani on 1/2/16.
//  Copyright © 2016 LaunchKey, Inc. All rights reserved.
//

#import "CircleCodeViewControllerWidgetViewController.h"
#import "CircleCodeWidgetControl.h"
#import "SecurityViewController.h"
#import "LKUIConstants.h"
#import "AuthenticatorManager.h"
#import <LKCAuthenticator/LKCCircleCodeManager.h>
#import <LKCAuthenticator/LKCErrorCode.h>
#import "LaunchKeyUIBundle.h"

@interface CircleCodeViewControllerWidgetViewController ()
{
    BOOL creation;
}

@end

@implementation CircleCodeViewControllerWidgetViewController

@synthesize combo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_state == calledFromAdd)
        creation = true;
    if(_state == calledFromAdd || _state == calledFromRemove)
        _labelWarning.hidden = YES;
        
    combo = [[CircleCodeWidgetControl alloc] initWithFrame:CGRectMake(0, 0, 375, 375) andDelegate:self];
    combo.createCombo = creation;
    [self.view addSubview:combo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Combo Methods
-(void)combosDoNotMatch
{
    NSString *label;
    label = NSLocalizedStringFromTableInBundle(@"Combo_Not_Match", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    if(_state != calledFromAuthRequest)
        [self.delegate updateLabel:self updateString:label];
}

-(void)firstComboSet
{
    NSString *label;
    label = NSLocalizedStringFromTableInBundle(@"circlepad_add_instructions_repeat", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    if(_state != calledFromAuthRequest)
        [self.delegate updateLabel:self updateString:label];
}

-(void)invalidShortComboSet
{
    NSString *label;

    label = NSLocalizedStringFromTableInBundle(@"Combo_Short", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    if(_state != calledFromAuthRequest)
        [self.delegate updateLabel:self updateString:label];

}
    
-(void)invalidLongComboSet
{
    NSString *label;
    
    label = NSLocalizedStringFromTableInBundle(@"Combo_Long", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    if(_state != calledFromAuthRequest)
    [self.delegate updateLabel:self updateString:label];
    
}

- (void)comboSetAndDismissedWithCircleCode:(NSArray*)circleCode
{
    if(_verifyAlways)
    {
        [LKCCircleCodeManager setCircleCode:circleCode withVerificationFlag:ALWAYS];
    }
    else
    {
        [LKCCircleCodeManager setCircleCode:circleCode withVerificationFlag:WHENREQUIRED];
    }
    
    NSString *label;
    label = NSLocalizedStringFromTableInBundle(@"Combo_Set", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    if(_state != calledFromAuthRequest)
        [self.delegate updateLabel:self updateString:label];
    
    [self comboDismissed];
}

- (void)comboDismissed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"circleCodeSet" object:nil userInfo:nil];
}

- (void)comboUnlockedWithCircleCode:(NSArray*)circleCode
{
    switch (_state) {
        case calledFromAdd:
            break;
        case calledFromRemove:
        {
            self.view.userInteractionEnabled = NO;
            [LKCCircleCodeManager removeCircleCode:circleCode withCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
                    if(success)
                    {
                        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                        for (UIViewController *aViewController in allViewControllers) {
                            if ([aViewController isKindOfClass:[SecurityViewController class]]) {
                                [self.navigationController popToViewController:aViewController animated:YES];
                            }
                        }
                    }
                    else
                    {
                        NSString *label;
                        label = NSLocalizedStringFromTableInBundle(@"Combo_Invalid", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                        [self.delegate updateLabel:self updateString:label];
                        [self shakeTheView];
                        
                        if(error.code == CircleCodeWrongFailureUnlinkError)
                        {
                            [self showTempAlertForUnlink];
                        }
                        else
                        {
                            if(autoUnlinkWarningThresholdMet)
                            {
                                [self handleIncorrectCircleCodeWithRemainingAttempts:attemptsRemaining];
                            }
                            else
                            {
                                self.view.userInteractionEnabled = YES;
                            }
                        }
                    }
                }];
                break;
        }
        case calledFromVerify:
        {
            self.view.userInteractionEnabled = NO;
            [LKCCircleCodeManager changeVerificationFlag:circleCode withCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
                if(success)
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *label;
                    label = NSLocalizedStringFromTableInBundle(@"Combo_Invalid", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    [self.delegate updateLabel:self updateString:label];
                    [self shakeTheView];

                    if(error.code == CircleCodeWrongFailureUnlinkError)
                    {
                        [self showTempAlertForUnlink];
                    }
                    else
                    {
                        if(autoUnlinkWarningThresholdMet)
                        {
                            [self handleIncorrectCircleCodeWithRemainingAttempts:attemptsRemaining];
                        }
                        else
                        {
                            self.view.userInteractionEnabled = YES;
                        }
                    }
                }
            }];
            break;
        }
        case calledFromAuthRequest:
        {
            self.view.userInteractionEnabled = NO;
            [LKCCircleCodeManager verifyCircleCode:circleCode forAuthRequest:_authRequestDetails withCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
                if(success)
                {
                    // Disable View before transitioning container views:
                    [self.delegate CircleCodeVerified:self CircleCodeIsVerfied:true];
                }
                else
                {
                    NSString *label;
                    label = NSLocalizedStringFromTableInBundle(@"Combo_Invalid", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                    _labelWarning.text = label;
                    [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(fadeOutLabels:) userInfo:nil repeats:NO];
                    [self shakeTheView];

                    if(error.code == CircleCodeWrongFailureUnlinkError)
                    {
                        [self showTempAlertForUnlink];
                    }
                    else if(error.code == CircleCodeWrongFailureError)
                    {
                        // Auto faulure threshold has passed, Circle Code fails auth request
                        [self.delegate CircleCodeVerified:self CircleCodeIsVerfied:false];
                    }
                    else
                    {
                        if(autoUnlinkWarningThresholdMet)
                        {
                            [self handleIncorrectCircleCodeWithRemainingAttempts:attemptsRemaining];
                        }
                        else
                        {
                            self.view.userInteractionEnabled = YES;
                        }
                    }
                }
            }];
            break;
        }
    }
}

-(void)handleIncorrectCircleCodeWithRemainingAttempts:(int)remainingAttempts
{
    if (!creation)
    {
        // Show Alert after delay to ensure warning alert is shown on failure view
        if(remainingAttempts == 1)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts]];
            });
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts]];
            });
        }
    }
    else
    {
        // Show without delay
        if(remainingAttempts == 1)
        {
            [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts]];
        }
        else
        {
            [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts]];
        }
    }
}

-(void)shakeTheView
{
    UIView *theView = self.view;
    
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([theView center].x - 5.0f, [theView center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([theView center].x + 5.0f, [theView center].y)]];
    [[theView layer] addAnimation:animation forKey:@"position"];
}

-(void)fadeOutLabels:(id)sender
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                     }
                     completion:^(BOOL finished) {
                         _labelWarning.text = @"";
                     }];
}

#pragma mark - Alert View Methods
-(void)showTempAlertForUnlink
{
    if(_state == calledFromAuthRequest)
    {
        // this posts a notification to the Request View Controller
        [[NSNotificationCenter defaultCenter] postNotificationName:kLKUnlinkDeviceCircleFailed object:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // Show Unlink Alert in Failure View
            [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].thresholdAutoUnlink]];
        });
        
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                                   message:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Unlinked", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].thresholdAutoUnlink]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * action)
                               {
                                   // Pop views
                                   if(_state == calledFromRemove || _state == calledFromVerify)
                                   {
                                       // Pop back 3 views
                                       [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
                                   }
                               }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"OK", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * action)
                               {
                                    self.view.userInteractionEnabled = YES;
                               }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
