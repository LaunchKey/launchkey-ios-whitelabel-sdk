//
//  AuthenticatorConfig.m
//  Authenticator
//
//  Created by ani on 10/2/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import "AuthenticatorConfig.h"
#import "AuthenticatorManager.h"
#import "LKUIConstants.h"
#import <LKCAuthenticator/LKCAuthenticatorManager.h>
#import "LKUIConstants.h"

@implementation AuthenticatorConfigBuilder

-(instancetype)init
{
    if(self = [super init])
    {
        _SSLPinningEnabled = YES;
        _keyPairSize = keypair_maximum;
        _activationDelayWearable = activationDelayDefault;
        _activationDelayLocation = activationDelayDefault;
        _thresholdAuthFailure = thresholdAuthFailureDefault;
        _thresholdAutoUnlink = thresholdAutoUnlinkDefault;        
        _thresholdAutoUnlinkWarning = -1;
        _customFont = @"System";
        _enableInfoButtons = YES;
        _enableHeaderViews = YES;
        _enableSecurityFactorImages = YES;
        _enableNotificationPrompt = YES;
        _enableViewControllerTransitionAnimation = YES;
        _enableBackBarButtonItem = YES;
        _enableSecurityChangesWhenUnlinked = NO;
        _enablePINCode = YES;
        _enableCircleCode = YES;
        _enableLocations = YES;
        _enableWearable = YES;
        _enableFingerprint = YES;
        _enableFace = YES;
        _controlsBackgroundColor = [UIColor colorWithRed:(238.0/255.0) green:(238.0/255.0) blue:(238.0/255.0) alpha:1.0];
        _tableViewHeaderBackgroundColor = [UIColor colorWithRed:(239.0/255.0) green:(239.0/255.0) blue:(244.0/255.0) alpha:1.0];
        _tableViewHeaderTextColor = [UIColor colorWithRed:(109.0/255.0) green:(109.0/255.0) blue:(114.0/255.0) alpha:1.0];
        _securityViewsTextColor = [UIColor colorWithRed:(85.0/255.0) green:(85.0/255.0) blue:(85.0/255.0) alpha:1.0];
        _geofenceCircleColor = [UIColor colorWithRed:(45.0/255.0) green:(106.0/255.0) blue:(207.0/255.0) alpha:0.20];
        _securityFactorImageTintColor = [UIColor colorWithRed:(85.0/255.0) green:(85.0/255.0) blue:(85.0/255.0) alpha:1.0];
        _authContentViewBackgroundColor = defaultAuthContentViewBackgroundColor;
        _authTextColor = defaultAuthTextColor;
        _authResponseAuthorizedColor = defaultAuthResponseAuthorizedColor;
        _authResponseDeniedColor = defaultAuthResponseDeniedColor;
        _authResponseFailedColor = defaultAuthResponseFailedColor;
        _authResponseDenialReasonUnselectedColor = defaultAuthResponseDenialReasonUnselectedColor;
        _authResponseDenialReasonSelectedColor = defaultAuthResponseDenialReasonSelectedColor;
    }
    
    return self;
}

@end

@implementation AuthenticatorConfig

-(instancetype)initWithAuthenticatorConfigBuilder:(AuthenticatorConfigBuilder *)builder
{
    if(self = [super init])
    {
        _SSLPinningEnabled = builder.SSLPinningEnabled;
        _keyPairSize = [self setKeyPairSize:builder.keyPairSize];
        _activationDelayWearable = [self setActivationDelay:builder.activationDelayWearable];
        _activationDelayLocation = [self setActivationDelay:builder.activationDelayLocation];
        _thresholdAutoUnlink = [self setAutoUnlinkThreshold:builder.thresholdAutoUnlink];
        _thresholdAuthFailure = [self setAuthFailureThreshold:builder.thresholdAuthFailure];
        _thresholdAutoUnlinkWarning = [self setWarningUnlinkThreshold:builder.thresholdAutoUnlinkWarning];
        _customFont = [self setFont:builder.customFont];
        _enableInfoButtons = builder.enableInfoButtons;
        _enableHeaderViews = builder.enableHeaderViews;
        _enableSecurityFactorImages = builder.enableSecurityFactorImages;
        _enableNotificationPrompt = builder.enableNotificationPrompt;
        _enableViewControllerTransitionAnimation = builder.enableViewControllerTransitionAnimation;
        _enableBackBarButtonItem = builder.enableBackBarButtonItem;
        _enableSecurityChangesWhenUnlinked = [self setEnableSecurityChangesWhenUnlinked:builder.enableSecurityChangesWhenUnlinked];
        _enablePINCode = builder.enablePINCode;
        _enableCircleCode = builder.enableCircleCode;
        _enableLocations = builder.enableLocations;
        _enableWearable = builder.enableWearable;
        _enableFingerprint = builder.enableFingerprint;
        _enableFace = builder.enableFace;
        _controlsBackgroundColor = builder.controlsBackgroundColor;
        _tableViewHeaderBackgroundColor = builder.tableViewHeaderBackgroundColor;;
        _tableViewHeaderTextColor = builder.tableViewHeaderTextColor;
        _securityViewsTextColor = builder.securityViewsTextColor;
        _geofenceCircleColor = builder.geofenceCircleColor;
        _securityFactorImageTintColor = builder.securityFactorImageTintColor;
        _authContentViewBackgroundColor = builder.authContentViewBackgroundColor;
        _authTextColor = builder.authTextColor;
        _authResponseAuthorizedColor = builder.authResponseAuthorizedColor;
        _authResponseDeniedColor = builder.authResponseDeniedColor;
        _authResponseFailedColor = builder.authResponseFailedColor;
        _authResponseDenialReasonUnselectedColor = builder.authResponseDenialReasonUnselectedColor;
        _authResponseDenialReasonSelectedColor = builder.authResponseDenialReasonSelectedColor;
    }
    
    return self;
}

+(instancetype)makeWithAuthenticatorConfigBuilder:(void (^)(AuthenticatorConfigBuilder *))builder
{
    AuthenticatorConfigBuilder *configBuilder = [AuthenticatorConfigBuilder new];
    builder(configBuilder);
    return [[AuthenticatorConfig alloc] initWithAuthenticatorConfigBuilder:configBuilder];
}

#pragma mark - Set Key Pair Size
-(int)setKeyPairSize:(int)keyPairSize
{
    if(keyPairSize == keypair_minimum || keyPairSize == keypair_medium || keyPairSize == keypair_maximum)
    {
        keyPairSize = keyPairSize;
    }
    else if(keyPairSize <= 0)
    {
        keyPairSize = keypair_maximum;
    }
    else if(keyPairSize <= keypair_minimum)
    {
        keyPairSize = keypair_minimum;
    }
    else if(keyPairSize > keypair_minimum && keyPairSize <= keypair_medium)
    {
        keyPairSize = keypair_medium;
    }
    else if(keyPairSize > keypair_medium && keyPairSize <= keypair_maximum)
    {
        keyPairSize = keypair_maximum;
    }
    else
    {
        keyPairSize = keypair_maximum;
    }
    return keyPairSize;
}

#pragma mark - Set Activation Delay
-(int)setActivationDelay:(int)activationDelay
{
    if(activationDelay < activationDelayMin)
    {
        return activationDelayDefault;
    }
    else if(activationDelay > activationDelayMax)
    {
        return activationDelayDefault;
    }
    
    return activationDelay;
}

#pragma mark - Set Font
-(NSString*)setFont:(NSString*)customFont
{
    NSString* _customFont = @"System";

    NSRange whiteSpaceRange = [customFont rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location == NSNotFound && customFont != nil)
        _customFont = customFont;
    
    BOOL isFontFound = NO;
    
    // List all fonts on iPhone
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        //NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        
        if([[familyNames objectAtIndex:indFamily]isEqualToString:_customFont])
            isFontFound = YES;
        
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            //NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
            if([[fontNames objectAtIndex:indFont] isEqualToString:_customFont])
                isFontFound = YES;
        }
        
    }
    
    if(!isFontFound)
        _customFont = @"System";
    
    return _customFont;
}

#pragma mark - Set EnableSecurityChangesWhenUnlinked
-(BOOL)setEnableSecurityChangesWhenUnlinked:(BOOL)shouldEnable
{
    if([[LKCAuthenticatorManager sharedClient] isDeviceLinked])
        return true;
    return shouldEnable;
}

#pragma mark - Set Auto Unlink Threshold
-(int)setAutoUnlinkThreshold:(int)autoUnlinkThreshold
{
    if(autoUnlinkThreshold < thresholdAutoUnlinkMin)
    {
        [NSException raise:@"Invalid auto unlink threshold value" format:@"%d is invalid, minimum acceptable value is %d", autoUnlinkThreshold, thresholdAutoUnlinkMin];
    }
    if(autoUnlinkThreshold > thresholdAutoUnlinkMax)
    {
        [NSException raise:@"Invalid auto unlink threshold value" format:@"%d is invalid, maximum acceptable value is %d", autoUnlinkThreshold, thresholdAutoUnlinkMax];
    }
    
    return autoUnlinkThreshold;
}

#pragma mark - Set Auth Failure Threshold
-(int)setAuthFailureThreshold:(int)authFailureThreshold
{
    if(authFailureThreshold < thresholdAuthFailureMin)
    {
        [NSException raise:@"Invalid auth failure threshold value" format:@"%d is invalid, minimum acceptable value is %d", authFailureThreshold, thresholdAuthFailureMin];
    }
    else if(authFailureThreshold > thresholdAuthFailureMax)
    {
        [NSException raise:@"Invalid auth failure threshold value" format:@"%d is invalid, maximum acceptable value is %d", authFailureThreshold, thresholdAuthFailureMax];
    }
    
    if(authFailureThreshold > _thresholdAutoUnlink)
    {
        [NSException raise:@"Invalid auth failure threshold value" format:@"auth failure threshold cannot be greater than auto unlink threshold"];
    }
    
    return authFailureThreshold;
}

#pragma mark - Set Warning Unlink Threshold
-(int)setWarningUnlinkThreshold:(int)warningUnlinkThreshold
{
    if(warningUnlinkThreshold == -1)
    {
        warningUnlinkThreshold = _thresholdAutoUnlink - 2;
    }
    
    if(warningUnlinkThreshold > _thresholdAutoUnlink - 1)
    {
        [NSException raise:@"Invalid auto unlink warning threshold value" format:@"auto unlink warning threshold cannot be greater than auto unlink threshold"];
    }
    
    if(warningUnlinkThreshold < thresholdWarningUnlinkMin)
    {
        [NSException raise:@"Invalid auto unlink warning threshold value" format:@"%d is invalid, minimum acceptable value is %d", warningUnlinkThreshold, thresholdWarningUnlinkMin];
    }
    
    return warningUnlinkThreshold;
}

@end
