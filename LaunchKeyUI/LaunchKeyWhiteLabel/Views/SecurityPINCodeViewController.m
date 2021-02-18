//
//  SecurityPINCodeViewController.m
//  LaunchKey
//
//  Created by ani on 12/2/15.
//  Copyright © 2015 LaunchKey, Inc. All rights reserved.
//

#import "SecurityPINCodeViewController.h"
#import <QuartzCore/CALayer.h>
#import "AuthenticatorManager.h"
#import "LaunchKeyUIBundle.h"

@interface SecurityPINCodeViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *minimum8Digits;
@property (strong, nonatomic) IBOutlet UILabel *nonSequential;
@property (strong, nonatomic) IBOutlet UILabel *allRepeating;

@property (weak, nonatomic) IBOutlet UILabel *labelPINCode;
@property (weak, nonatomic) IBOutlet UIView *containerPINCodeViewController;
@property (weak, nonatomic) PINCodeViewController *pinCodeViewController;
@property (weak, nonatomic) NSString *wrongPINLocalizedString;
@property BOOL isFirstUserInputAfterBadPIN;

@end

@implementation SecurityPINCodeViewController

@synthesize PINCodeString, PINisValid, fromAdd, fromRemove, fromVerifySwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UIButton *rightHelp = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [rightHelp addTarget:self action:@selector(helpPressed:) forControlEvents:UIControlEventTouchDown];

    if(fromAdd && [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableInfoButtons)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightHelp];
    
#ifdef FIPS_140
    if(fromAdd) {
        [[self minimum8Digits] setHidden:NO];
        [[self nonSequential] setHidden:NO];
        [[self allRepeating] setHidden:NO];
    }
#endif
    _viewHeader.backgroundColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].controlsBackgroundColor;
    
    PINisValid = false;
    
    if(_switchVerify.on)
    {
        PINCodeViewController *child = (PINCodeViewController *)[self.childViewControllers objectAtIndex:0];
        child.verifyAlways = true;
    }
    else
    {
        PINCodeViewController *child = (PINCodeViewController *)[self.childViewControllers objectAtIndex:0];
        child.verifyAlways = false;
    }
    
    if(fromAdd)
        self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"pincode_add", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    else if(fromVerifySwitch)
        self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"lk_activity_pincode_check_verify_title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    else
        self.navigationItem.title =  NSLocalizedStringFromTableInBundle(@"pincode_check", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    
    if(fromAdd)
    {
        _labelEnterPINCode.hidden = NO;
        _labelEnterPINCode.text = NSLocalizedStringFromTableInBundle(@"security_pincode_enter", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        _labelVerifyPINCode.hidden = NO;
        _labelVerifyPINCode.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        _switchVerify.hidden = NO;
    }
    else if(fromVerifySwitch)
    {
        _labelVerifyPINCode.hidden = YES;
        _labelEnterPINCode.hidden = NO;
        _labelEnterPINCode.text = NSLocalizedStringFromTableInBundle(@"lk_activity_pincode_check_verify_subtitle", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        _switchVerify.hidden = YES;
    }
    else if(fromRemove)
    {
        _labelVerifyPINCode.hidden = YES;
        _labelEnterPINCode.hidden = NO;
        _labelEnterPINCode.text = NSLocalizedStringFromTableInBundle(@"security_pincode_enter", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        _switchVerify.hidden = YES;
    }
    
    [self.switchVerify addTarget:self
                      action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];

    _labelPINCode.adjustsFontSizeToFitWidth = YES;
    
    // Set Color Configurations
    _labelVerifyPINCode.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
    _labelEnterPINCode.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
    _labelPINCode.textColor = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].securityViewsTextColor;
    
    // Set this here so it does not have to be initalized on every button press
    [self setWrongPINLocalizedString:NSLocalizedStringFromTableInBundle(@"label_Wrong_PIN", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
    [self setIsFirstUserInputAfterBadPIN:NO];
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
        _labelHeightConstraint.priority = 999;
        _labelMarginConstraint.constant = 12;
    }
}

-(void)updatePinCode:(PINCodeViewController *)controller updateString:(NSMutableString *)PINString
{
    if ([self isFirstUserInputAfterBadPIN]) {
        [self setIsFirstUserInputAfterBadPIN:NO];
        _labelEnterPINCode.text = NSLocalizedStringFromTableInBundle(@"security_pincode_enter", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
    }
    if ([self labelEnterPINCode].text == [self wrongPINLocalizedString]) {
        [self setIsFirstUserInputAfterBadPIN:YES];
    }
    
    PINCodeString = PINString;
    
    _labelPINCode.text = PINString;
    
    if(fromRemove || fromVerifySwitch)
    {
        NSMutableString *dottedPassword = [NSMutableString new];
        
        for (int i = 0; i < [PINString length]; i++)
        {
            [dottedPassword appendString:@"●"]; // BLACK CIRCLE Unicode: U+25CF, UTF-8: E2 97 8F
        }
        
        _labelPINCode.text = dottedPassword;
        if([PinCodeButton appearance].bulletColor != nil)
            _labelPINCode.textColor = [PinCodeButton appearance].bulletColor;
    }
    // FIPS password minimums
#ifdef FIPS_140
    if (fromAdd) {
        if (PINString.length < 8) {
            [[self minimum8Digits] setTextColor:[UIColor blackColor]];
        }
        else {
            [[self minimum8Digits] setTextColor:[UIColor greenColor]];
        }
        if ([self meetsSequenceRequirements:PINString] && PINString.length > 0) {
            [[self nonSequential] setTextColor:[UIColor greenColor]];
        }
        else {
            [[self nonSequential] setTextColor:[UIColor blackColor]];
        }
        if ([self meetsRepeatedCharactersRequirements:PINString]) {
            [[self allRepeating] setTextColor:[UIColor greenColor]];
        }
        else {
            [[self allRepeating] setTextColor:[UIColor blackColor]];
        }
        BOOL pinIsAcceptable = PINString.length >= 8 && PINString.length <= 25 && [self meetsSequenceRequirements:PINString] && [self meetsRepeatedCharactersRequirements:PINString];
        [self.pinCodeViewController setDoneButtonEnabled:pinIsAcceptable];
    }
#endif
}

-(void)updateLabel:(PINCodeViewController *)controller updateString:(NSString *)labelMessage
{
    _labelEnterPINCode.text = labelMessage;
    
}

#pragma mark - Menu Methods
-(void)helpPressed:(id)sender
{
    [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"About_PIN_Title", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"help_security_add_pin", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
}

#pragma mark - Button Methods
- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn])
    {
        _labelVerifyPINCode.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_always", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        PINCodeViewController *child = (PINCodeViewController *)[self.childViewControllers objectAtIndex:0];
        child.verifyAlways = true;
    }
    else
    {
        _labelVerifyPINCode.text = NSLocalizedStringFromTableInBundle(@"lk_security_settingspanel_verify_required", @"Localizable", [NSBundle LaunchKeyUIBundle], nil);
        PINCodeViewController *child = (PINCodeViewController *)[self.childViewControllers objectAtIndex:0];
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

#pragma mark - Prepare For Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toPINCodeViewController"])
    {
        PINCodeViewController *embed = segue.destinationViewController;
        embed.delegate = self;
        self.pinCodeViewController = embed;
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
        
        if(PINisValid)
            embed.validPin = true;
    }
}

#pragma mark - FIPS pincode requirements
-(BOOL)meetsSequenceRequirements:(NSString *)PINCode
{
    // Convert PIN Code string to array
    NSMutableArray *pinArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < PINCode.length; i ++) {
        [pinArray addObject:[NSString stringWithFormat:@"%c", [PINCode characterAtIndex:i]]];
    }
    
    // Sequence requirement is simply that the entire secret may not be a sequence of numbers in
    // increasing or decreasing order
    // i.e.
    // 12345679 is allowed
    // 123456789, 012345678, 34567890 is not allowed

    // A sequence of length 1 would meet the requirements of this method (though not the AAL2
    // requirement, we expect this to be handled elsewhere)
    int pinCount = (int)[pinArray count];
    BOOL sequenceBreakDetected = pinCount < 2;
    // If there's at least two elements continue
    if (!sequenceBreakDetected) {
       // Determine whether the sequence is increasing, decreasing, or neither
       int sequenceDirection = [[pinArray objectAtIndex:1] intValue] - [[pinArray objectAtIndex:0] intValue];
       for (int i = 2; i < pinCount; i++)
       {
           int currentVal = [[pinArray objectAtIndex:i] intValue];
           int previousVal = [[pinArray objectAtIndex:i - 1] intValue];
           int newSequenceDirection = currentVal - previousVal;
           if((newSequenceDirection > 1 || newSequenceDirection < -1) && newSequenceDirection != -9)
           {
               // The two numbers are more than one apart
               return YES;
           }
           else if(((sequenceDirection > 0) && (newSequenceDirection < 0) && newSequenceDirection != -9) || ((sequenceDirection < 0) && (newSequenceDirection > 0)))
           {
               sequenceBreakDetected = YES;
               break;
           }
           else if (newSequenceDirection != 0)
           {
               // Prevents 123321 from not counting as a sequence break
               sequenceDirection = newSequenceDirection;
           }
       }
    }

    return sequenceBreakDetected;
}

-(BOOL)meetsRepeatedCharactersRequirements:(NSString *)PINCode
{
    // Convert PIN Code string to array
    NSMutableArray *pinArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < PINCode.length; i ++) {
        [pinArray addObject:[NSString stringWithFormat:@"%c", [PINCode characterAtIndex:i]]];
    }
    
    // Repeated characters will not break a sequence
    // i.e.
    // 11335578 is allowed
    // 11223344, 11112222, 11335577 is not allowed
    int pinCount = (int)[pinArray count];
    for (int i = 0; i < pinCount; i++)
    {
        int prevChar = (i > 0) ? [[pinArray objectAtIndex:i - 1] intValue] : 0;
        int currentChar = [[pinArray objectAtIndex:i] intValue];
        int nextChar = (i < pinCount - 1) ? [[pinArray objectAtIndex:i + 1] intValue] : 0;
        if(currentChar != prevChar && currentChar != nextChar)
        {
            return YES;
        }
    }
    
    return NO;
}
@end
