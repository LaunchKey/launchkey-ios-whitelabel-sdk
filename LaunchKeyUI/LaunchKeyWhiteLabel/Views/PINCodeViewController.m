//
//  PINCodeViewController.m
//  LaunchKey
//
//  Created by ani on 12/2/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import "PINCodeViewController.h"
#import "SecurityPINCodeViewController.h"
#import "SecurityViewController.h"
#import "LKUIConstants.h"
#import "PinCodeButton.h"
#import "AuthenticatorManager.h"
#import <LKCAuthenticator/LKCPINCodeManager.h>
#import <LKCAuthenticator/LKCErrorCode.h>
#import "LaunchKeyUIBundle.h"
#import "LKUIStringVerification.h"

@interface PINCodeViewController ()
{
    NSString *one, *two, *three, *four, *five, *six;
    NSString *seven, *eight, *nine, *zero;
}

@property (weak, nonatomic) IBOutlet UILabel *titleOne;
@property (weak, nonatomic) IBOutlet UILabel *titleTwo;
@property (weak, nonatomic) IBOutlet UILabel *titleThree;
@property (weak, nonatomic) IBOutlet UILabel *titleFour;
@property (weak, nonatomic) IBOutlet UILabel *titleFive;
@property (weak, nonatomic) IBOutlet UILabel *titleSix;
@property (weak, nonatomic) IBOutlet UILabel *titleSeven;
@property (weak, nonatomic) IBOutlet UILabel *titleEight;
@property (weak, nonatomic) IBOutlet UILabel *titleNine;

@end

@implementation PINCodeViewController
{
    NSString *firstPin;
    BOOL deviceUnlinked;
}

@synthesize btnPinOne, btnPinTwo, btnPinThree;
@synthesize btnPinFour, btnPinFive, btnPinSix;
@synthesize btnPinSeven, btnPinEight, btnPinNine;
@synthesize btnPinZero, btnDelete, btnDone;
@synthesize stringPINCode, validPin, verifyAlways, labelPINDots;
@synthesize labelABC, labelDEF, labelGHI, labelJKL, labelMNO, labelTUV, labelPQRS, labelWXYZ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    one = @"1";
    two = @"2";
    three = @"3";
    four = @"4";
    five = @"5";
    six = @"6";
    seven = @"7";
    eight = @"8";
    nine = @"9";
    zero = @"0";
    
    firstPin = @"";
    
    deviceUnlinked = NO;

    _imgDelete.image = [_imgDelete.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_imgDelete setTintColor:[UIColor colorWithRed:(153.0/255.0) green:(153.0/255.0) blue:(153.0/255.0) alpha:1.0]];
    _imgDone.image = [_imgDone.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_imgDone setTintColor:[UIColor colorWithRed:(153.0/255.0) green:(153.0/255.0) blue:(153.0/255.0) alpha:1.0]];
    
    labelPINDots.hidden = YES;
    [self setDoneButtonEnabled:NO];

    if(_state == calledFromAuthRequest)
        labelPINDots.hidden = NO;
    
    stringPINCode = [NSMutableString stringWithString:@""];
    
    _imgDelete.tintColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
    _imgDone.tintColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
    
    UIColor *lettersColor;
    if([PinCodeButton appearance].lettersColor == nil)
        lettersColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
    else
        lettersColor = [PinCodeButton appearance].lettersColor;
    
    labelABC.textColor = lettersColor;
    labelDEF.textColor = lettersColor;
    labelGHI.textColor = lettersColor;
    labelJKL.textColor = lettersColor;
    labelMNO.textColor = lettersColor;
    labelPQRS.textColor = lettersColor;
    labelTUV.textColor = lettersColor;
    labelWXYZ.textColor = lettersColor;
    
    if([[PinCodeButton appearance] titleColorForState:UIControlStateNormal] != nil)
    {
        _titleOne.textColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
        _titleTwo.textColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
        _titleThree.textColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
        _titleFour.textColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
        _titleFive.textColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
        _titleSix.textColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
        _titleSeven.textColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
        _titleEight.textColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
        _titleNine.textColor = [[PinCodeButton appearance] titleColorForState:UIControlStateNormal];
    }
    
    // Set localized accessibility labels
    [btnPinOne setAccessibilityLabel:NSLocalizedString(@"Pin Code Button 1",@"voice over for pin code button 1")];
    [btnPinTwo setAccessibilityLabel:NSLocalizedString(@"Pin Code Button 2",@"voice over for pin code button 2")];
    [btnPinThree setAccessibilityLabel:NSLocalizedString(@"Pin Code Button 3",@"voice over for pin code button 3")];
    [btnPinFour setAccessibilityLabel:NSLocalizedString(@"Pin Code Button 4",@"voice over for pin code button 4")];
    [btnPinFive setAccessibilityLabel:NSLocalizedString(@"Pin Code Button 5",@"voice over for pin code button 5")];
    [btnPinSix setAccessibilityLabel:NSLocalizedString(@"Pin Code Button 6",@"voice over for pin code button 6")];
    [btnPinSeven setAccessibilityLabel:NSLocalizedString(@"Pin Code Button 7",@"voice over for pin code button 7")];
    [btnPinEight setAccessibilityLabel:NSLocalizedString(@"Pin Code Button 8",@"voice over for pin code button 8")];
    [btnPinNine setAccessibilityLabel:NSLocalizedString(@"Pin Code Button 9",@"voice over for pin code button 9")];
    [btnPinZero setAccessibilityLabel:NSLocalizedString(@"Pin Code Button 0",@"voice over for pin code button 0")];
    [btnDelete setAccessibilityLabel:NSLocalizedString(@"Pin Code Button Backspace",@"voice over for pin code backspace button")];
    [btnDone setAccessibilityLabel:NSLocalizedString(@"Pin Code Button Submit",@"voice over for pin code submit button")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Methods
- (IBAction)btnPinOnePressed:(id)sender
{
    [stringPINCode insertString:one atIndex:[stringPINCode length]];
    [self doButtonUpdates];
}
- (IBAction)btnPinTwoPressed:(id)sender
{
    [stringPINCode insertString:two atIndex:[stringPINCode length]];
    [self doButtonUpdates];
}
- (IBAction)btnPinThreePressed:(id)sender
{
    [stringPINCode insertString:three atIndex:[stringPINCode length]];
    [self doButtonUpdates];
}

- (IBAction)btnPinFourPressed:(id)sender
{
    [stringPINCode insertString:four atIndex:[stringPINCode length]];
    [self doButtonUpdates];
}

- (IBAction)btnPinFivePressed:(id)sender
{
    [stringPINCode insertString:five atIndex:[stringPINCode length]];
    [self doButtonUpdates];
}

- (IBAction)btnPinSixPressed:(id)sender
{
    [stringPINCode insertString:six atIndex:[stringPINCode length]];
    [self doButtonUpdates];
}

- (IBAction)btnPinSevenPressed:(id)sender
{
    [stringPINCode insertString:seven atIndex:[stringPINCode length]];
    [self doButtonUpdates];
}

- (IBAction)btnPinEightPressed:(id)sender
{
    [stringPINCode insertString:eight atIndex:[stringPINCode length]];
    [self doButtonUpdates];
}

- (IBAction)btnPinNinePressed:(id)sender
{
    [stringPINCode insertString:nine atIndex:[stringPINCode length]];
    [self doButtonUpdates];
}

- (IBAction)btnPinZeroPressed:(id)sender
{
    [stringPINCode insertString:zero atIndex:[stringPINCode length]];
    [self doButtonUpdates];
}

- (IBAction)btnDeletePressed:(id)sender
{
    if([stringPINCode length] > 0)
        [stringPINCode deleteCharactersInRange:NSMakeRange([stringPINCode length] - 1, 1)];
    [self doButtonUpdates];
}

-(void)doButtonUpdates
{
    [self updatePINLabel];
    if(_state == calledFromAuthRequest)
        [self updatePINDotsLabel];
}

- (void)updatePINLabel
{
    // A PIN must be 4-25 characters in length
    BOOL userEntryIsWithinAcceptableRangeForPIN = [stringPINCode length] >= 4 && [stringPINCode length] <= 25;
    // Entry must be at least one character when verifying PIN
    BOOL userEntryIsAtLeastOneCharacter = [stringPINCode length] >= 1;
    if(_state == calledFromAdd) { // User is adding a PIN
        [self setDoneButtonEnabled:userEntryIsWithinAcceptableRangeForPIN];
    }
    else { // User is not adding a pin, they are verifying a previously set pin
        [self setDoneButtonEnabled:userEntryIsAtLeastOneCharacter];
    }
    if(_state != calledFromAuthRequest) {
        [self.delegate updatePinCode:self updateString:stringPINCode];
    }
}

- (void)updatePINDotsLabel
{
    NSMutableString *dottedPassword = [NSMutableString new];
    
    for (int i = 0; i < [self.stringPINCode length]; i++)
    {
        [dottedPassword appendString:@"●"]; // BLACK CIRCLE Unicode: U+25CF, UTF-8: E2 97 8F
    }
    
    labelPINDots.text = dottedPassword;
    if([PinCodeButton appearance].bulletColor != nil)
        labelPINDots.textColor = [PinCodeButton appearance].bulletColor;
}

- (IBAction)btnDonePressed:(id)sender
{
    switch (_state) {
        case calledFromAdd:
        {
            if([stringPINCode length] < 4)
            {
                [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"pincode_add_short", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            }
            else if([stringPINCode length] > 25)
            {
                [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Error", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"pincode_add_long", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
            }
            
            if([stringPINCode length] > 3 && [stringPINCode length] < 26)
            {
                firstPin = stringPINCode;
                [self setPINCode];
            }
            break;
        }
        case calledFromRemove:
        {
            [LKCPINCodeManager removePINCode:stringPINCode withCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
                
                if(success)
                {
                    [self popBackViewAfterRemove];
                }
                else
                {
                    if(error.code == PINCodeWrongFailureUnlinkError)
                    {
                        deviceUnlinked = YES;
                        [self showTempAlertForUnlink];
                    }
                    else
                    {
                        if(autoUnlinkWarningThresholdMet)
                        {
                            [self handleIncorrectPINCodeWithRemainingAttempts:attemptsRemaining];
                        }
                    }
                    
                    [self updateUIAfterIncorrectInput];
                }
            }];
            break;
        }
        case calledFromVerify:
        {
            [LKCPINCodeManager changeVerificationFlag:stringPINCode withCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
                if(success)
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    if(error.code == PINCodeWrongFailureUnlinkError)
                    {
                        deviceUnlinked = YES;
                        [self showTempAlertForUnlink];
                    }
                    else
                    {
                        if(autoUnlinkWarningThresholdMet)
                        {
                            [self handleIncorrectPINCodeWithRemainingAttempts:attemptsRemaining];
                        }
                    }
                        
                    [self updateUIAfterIncorrectInput];
                }
            }];
            break;
        }
        case calledFromAuthRequest:
        {
            [LKCPINCodeManager verifyPINCode:stringPINCode forAuthRequest:_authRequestDetails withCompletion:^(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining) {
                if(success)
                {
                    // Disable View before transitioning container views:
                    self.view.userInteractionEnabled = NO;
                    
                    // Ensure highlighted state ends before transitioning container views:
                    if([PinCodeButton appearance].backgroundColor == nil)
                    {
                        btnDone.backgroundColor = [UIColor colorWithRed:(232/255.0) green:(232/255.0) blue:(232/255.0) alpha:1.0];
                    }
                    else
                    {
                        btnDone.backgroundColor = [PinCodeButton appearance].backgroundColor;
                    }
                    
                    btnDone.enabled = NO;
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [self.delegate PINVerified:self PINIsVerified:true];
                    });
                }
                else
                {
                    [self updateUIAfterIncorrectInput];

                    if(error.code == PINCodeWrongFailureUnlinkError)
                    {
                        deviceUnlinked = YES;
                        [self showTempAlertForUnlink];
                    }
                    if(error.code == PINCodeWrongFailureError)
                    {
                        // Auto faulure threshold has passed, PIN Code fails auth request
                        [self.delegate PINVerified:self PINIsVerified:false];
                    }
                    else
                    {
                        if(autoUnlinkWarningThresholdMet)
                        {
                            [self handleIncorrectPINCodeWithRemainingAttempts:attemptsRemaining];
                        }
                    }
                }
            }];
            break;
        }
    }
}

- (void)setDoneButtonEnabled:(BOOL) enabled {
    if (enabled) {
        [btnDone setEnabled:YES];
        [_imgDone setAlpha:1.0];
        [btnDone setAlpha:1.0];
    }
    else {
        [btnDone setEnabled:NO];
        [_imgDone setAlpha:0.3];
        [btnDone setAlpha:0.3];
    }
}

#pragma mark - Verify PIN Code
-(void)handleIncorrectPINCodeWithRemainingAttempts:(int)remainingAttempts
{
    // Total # of attempts equal warning count
    // Show warning alert

    if(_state == calledFromAuthRequest)
    {        
        // Show Alert after delay to ensure warning alert is shown on failure view
        if(remainingAttempts  == 1)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts]];
            });
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts ] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts]];
            });
        }
    }
    else
    {
        // Show without delay
        if(remainingAttempts  == 1)
        {
            [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_One", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts]];

        }
        else
        {
            [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts] withMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Failed_Attempts_Warn", @"Localizable", [NSBundle LaunchKeyUIBundle], nil), remainingAttempts]];

        }
    }
}

#pragma mark - Set PIN Code
- (void)setPINCode
{
    if ([firstPin isEqualToString:stringPINCode])
    {
        if(verifyAlways)
        {
            [LKCPINCodeManager setPINCode:stringPINCode withVerificationFlag:ALWAYS];
        }
        else
        {
            [LKCPINCodeManager setPINCode:stringPINCode withVerificationFlag:WHENREQUIRED];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pinSet" object:nil userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if ([firstPin isEqualToString:@""])
        firstPin = stringPINCode;
    else
        firstPin = @"";
}

#pragma mark - Pop Back View After Remove
- (void)popBackViewAfterRemove
{
    NSDictionary *aDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [LKUIStringVerification getEscapedString:@""], @"token",
                                 nil];
    NSString *locked = [aDictionary objectForKey:@"token"];
    if(![locked isEqualToString:[LKUIStringVerification getEscapedString:@""]])
        return;
        
    BOOL poppedView = NO;
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers)
    {
        if ([aViewController isKindOfClass:[SecurityViewController class]])
        {
            // Go Back to Security View Controller
            poppedView = YES;
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }
    
    if(!poppedView)
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

#pragma mark - Update UI After Inocrrect Input
-(void)updateUIAfterIncorrectInput
{
    NSString *labelMessage = @"";
    if(!deviceUnlinked)
    {
        labelMessage = NSLocalizedStringFromTableInBundle(@"label_Wrong_PIN", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    stringPINCode = [NSMutableString stringWithString:@""];
    [self updatePINLabel];
    [self shakeTheView];
    
    if(_state == calledFromAuthRequest)
    {
        labelPINDots.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].authTextColor;
        labelPINDots.text = labelMessage;
    }
    else
    {
        [self.delegate updateLabel:self updateString:labelMessage];
        [self.delegate updatePinCode:self updateString:stringPINCode];
    }
}

#pragma mark - Shake The View
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

#pragma mark - Alert View Methods
-(void)showTempAlertForUnlink
{
    if(_state == calledFromAuthRequest)
    {        
        // this posts a notification to the Request View Controller & responds to Auth Request w/ Failure
        [[NSNotificationCenter defaultCenter] postNotificationName:kLKUnlinkDevicePINFailed object:nil];
        
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
                               }];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
