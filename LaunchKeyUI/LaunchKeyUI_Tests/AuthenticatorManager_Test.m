//
//  AuthenticatorManager_Test.m
//  Authenticator
//
//  Created by ani on 3/29/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Authenticator.h"

@interface AuthenticatorManager_Test : XCTestCase

@end

@interface AuthenticatorManager (Tests)
-(void)devicePaired;
-(void)closeQRLaunchView;
@end

@implementation AuthenticatorManager_Test

- (void)setUp
{
    [super setUp];

    // Setting it to min for simulator testing purposes
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.keyPairSize = keypair_minimum;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
}

-(void)testShowLinkingView
{
    UINavigationController *parentNavView = [[UINavigationController alloc] init];
    [[AuthenticatorManager sharedClient] showLinkingView:parentNavView withSDKKey:@"" withCamera:NO withCompletion:nil];
}

-(void)testDevicePaired
{
    [[AuthenticatorManager sharedClient] devicePaired];
}

-(void)testCloseQRLaunchView
{
    [[AuthenticatorManager sharedClient] closeQRLaunchView];
}

-(void)testInitilizationMethod
{
    AuthenticatorConfig *config = [AuthenticatorConfig new];
    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.SSLPinningEnabled = YES;
        builder.keyPairSize = 348;
        builder.activationDelayWearable = activationDelayDefault;
        builder.activationDelayLocation = activationDelayDefault;
        builder.enableInfoButtons = YES;
        builder.enableHeaderViews = YES;
        builder.enableNotificationPrompt = YES;
        builder.enableSecurityChangesWhenUnlinked = NO;
        builder.enablePINCode = NO;
        builder.enableCircleCode = NO;
        builder.enableLocations = YES;
        builder.enableWearable = YES;
        builder.enableFingerprint = YES;
        builder.enableFace = YES;
        builder.controlsBackgroundColor = [UIColor colorWithRed:(238.0/255.0) green:(238.0/255.0) blue:(238.0/255.0) alpha:1.0];
        builder.tableViewHeaderBackgroundColor = [UIColor colorWithRed:(239.0/255.0) green:(239.0/255.0) blue:(244.0/255.0) alpha:1.0];
        builder.tableViewHeaderTextColor = [UIColor colorWithRed:(109.0/255.0) green:(109.0/255.0) blue:(114.0/255.0) alpha:1.0];
        builder.securityViewsTextColor = [UIColor colorWithRed:(85.0/255.0) green:(85.0/255.0) blue:(85.0/255.0) alpha:1.0];
        builder.geofenceCircleColor = [UIColor colorWithRed:(45.0/255.0) green:(106.0/255.0) blue:(207.0/255.0) alpha:0.20];
        builder.securityFactorImageTintColor = [UIColor colorWithRed:(85.0/255.0) green:(85.0/255.0) blue:(85.0/255.0) alpha:1.0];
    }];

    [[AuthenticatorManager sharedClient] initialize:config];
}

-(void)testGetAuthConfigInstance
{
    AuthenticatorConfig *config = [AuthenticatorConfig new];
    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.SSLPinningEnabled = YES;
        builder.keyPairSize = 348;
        builder.activationDelayWearable = activationDelayDefault;
        builder.activationDelayLocation = activationDelayDefault;
        builder.enableInfoButtons = YES;
        builder.enableHeaderViews = YES;
        builder.enableNotificationPrompt = YES;
        builder.enableSecurityChangesWhenUnlinked = NO;
        builder.enablePINCode = NO;
        builder.enableCircleCode = NO;
        builder.enableLocations = YES;
        builder.enableWearable = YES;
        builder.enableFingerprint = YES;
        builder.enableFace = YES;
    }];

    [[AuthenticatorManager sharedClient] initialize:config];

    AuthenticatorConfig *configToCheck = [[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance];

    if(configToCheck.keyPairSize != keypair_minimum)XCTFail(@"Key Pair Size should be set to a minimum of 2048");
    if(!configToCheck.SSLPinningEnabled)XCTFail(@"SSL Pinning should be enabled");
    if(configToCheck.activationDelayWearable != activationDelayDefault)XCTFail(@"Activation delay should be at default value");
    if(configToCheck.activationDelayLocation != activationDelayDefault)XCTFail(@"Activation delay should be at default value");
    if(!configToCheck.enableInfoButtons)XCTFail(@"Info buttons should be enabled");
    if(!configToCheck.enableHeaderViews)XCTFail(@"Header views should be enabled");
    if(!configToCheck.enableNotificationPrompt)XCTFail(@"Notification prompt should be enabled");
    if(configToCheck.enablePINCode)XCTFail(@"PIN Code should be disabled");
    if(configToCheck.enableCircleCode)XCTFail(@"Circle Code should be disabled");
    if(!configToCheck.enableLocations)XCTFail(@"Locations should be enabled");
    if(!configToCheck.enableWearable)XCTFail(@"Wearable should be enabled");
    if(!configToCheck.enableFingerprint)XCTFail(@"Fingerprint should be enabled");
}

@end
