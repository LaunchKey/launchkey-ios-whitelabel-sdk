//
//  SecurityCircleCodeViewController.m
//  LaunchKey
//
//  Created by ani on 12/14/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import "SecurityCircleCodeViewController.h"
#import "CircleCodeWidgetControl.h"
#import "CircleCodeViewControllerWidgetViewController.h"
#import "LKCombinationProtocol.h"
#import "SecurityViewController.h"
#import "LKUIConstants.h"
#import "AuthenticatorManager.h"
#import "LaunchKeyUIBundle.h"

@interface SecurityCircleCodeViewController () <CircleCodeViewControllerDelegate>
{
}

@end

@implementation SecurityCircleCodeViewController

@synthesize fromAdd, fromRemove, fromVerifySwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(_switchVerify.on)
    {
        CircleCodeViewControllerWidgetViewController  *child = (CircleCodeViewControllerWidgetViewController *)[self.childViewControllers objectAtIndex:0];
        child.verifyAlways = true;
    }
    else
    {
        CircleCodeViewControllerWidgetViewController *child = (CircleCodeViewControllerWidgetViewController *)[self.childViewControllers objectAtIndex:0];
        child.verifyAlways = false;
    }
    
    UIButton *rightHelp = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [rightHelp addTarget:self action:@selector(helpPressed:) forControlEvents:UIControlEventTouchDown];
    
    if(fromAdd && [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableInfoButtons)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightHelp];
    
    _viewHeader.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].controlsBackgroundColor;
    
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])
    {
        [_labelVerify setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:15]];
        [_labelEnterCode setFont:[UIFont fontWithName:[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont size:15]];
    }
    
    if(fromAdd)
        self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"circlecode_add", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    else if(fromVerifySwitch)
        self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"lk_activity_circlecode_check_verify_title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    else
        self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"circlecode_check", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    if(fromAdd)
    {
        _labelEnterCode.hidden = NO;
        _labelEnterCode.text = NSLocalizedStringFromTableInBundle(@"circlepad_add_instructions_enter", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        _labelVerify.hidden = NO;
        _labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        _switchVerify.hidden = NO;
    }
    else if(fromVerifySwitch)
    {
        _labelEnterCode.text = NSLocalizedStringFromTableInBundle(@"lk_activity_circlecode_check_verify_subtitle", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        _labelVerify.hidden = YES;
        _switchVerify.hidden = YES;

    }
    else if(fromRemove)
    {
        _labelEnterCode.text = NSLocalizedStringFromTableInBundle(@"circlepad_add_instructions_enter", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        _labelVerify.hidden = YES;
        _switchVerify.hidden = YES;
    }

    [self.switchVerify addTarget:self
                          action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Set Color Configurations
    _labelVerify.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
    _labelEnterCode.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
    if(CGColorEqualToColor([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].controlsBackgroundColor.CGColor,  [UIApplication sharedApplication].delegate.window.backgroundColor.CGColor) || [[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].controlsBackgroundColor isEqual:[UIColor clearColor]])
        _labelBottomConstraint.constant = 0;

    if(fromVerifySwitch || fromRemove)
    {
        _labelHeightContraint.priority = 999;
        _labelMarginConstraint.constant = 12;
    }
}

#pragma mark - Menu Methods
-(void)helpPressed:(id)sender
{
    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"About_Circle_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"help_security_add_circle", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
}

#pragma mark - Update Label
-(void)updateLabel:(CircleCodeViewControllerWidgetViewController *)controller updateString:(NSString *)labelMessage
{
    _labelEnterCode.text = labelMessage;
    
    if([labelMessage isEqualToString:NSLocalizedStringFromTableInBundle(@"Combo_Short", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
        [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(fadeOutLabels:) userInfo:nil repeats:NO];
    if([labelMessage isEqualToString:NSLocalizedStringFromTableInBundle(@"Combo_Invalid", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
    {
        [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(fadeOutLabels:) userInfo:nil repeats:NO];
    }
    if([labelMessage isEqualToString:NSLocalizedStringFromTableInBundle(@"Combo_Set", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"circleCodeSet" object:nil userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)fadeOutLabels:(id)sender
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                     }
                     completion:^(BOOL finished) {
                         _labelEnterCode.text = NSLocalizedStringFromTableInBundle(@"circlepad_add_instructions_enter", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
                     }];
}


#pragma mark - Button Methods
- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn])
    {
        _labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        CircleCodeViewControllerWidgetViewController  *child = (CircleCodeViewControllerWidgetViewController *)[self.childViewControllers objectAtIndex:0];
        child.verifyAlways = true;
    }
    else
    {
        _labelVerify.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        CircleCodeViewControllerWidgetViewController *child = (CircleCodeViewControllerWidgetViewController *)[self.childViewControllers objectAtIndex:0];
        child.verifyAlways = false;
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

#pragma mark - Prepare for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toSecurityCircleCodeViewController"])
    {
        CircleCodeViewControllerWidgetViewController *embed = segue.destinationViewController;
        embed.delegate = self;
        
        if(fromAdd)
        {
            embed.state = calledFromAdd;
        }
        else if(fromVerifySwitch)
        {
            embed.state = calledFromVerify;
        }
        else
        {
            embed.state = calledFromRemove;
        }
    }
}

@end
