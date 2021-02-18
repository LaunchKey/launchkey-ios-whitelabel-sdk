//
//  AuthenticatorConfigurator_Test.m
//  Authenticator
//
//  Created by ani on 3/28/17.
//  Copyright © 2017 LaunchKey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Authenticator.h"

@interface AuthenticatorConfig_Test : XCTestCase

@end

@interface AuthenticatorConfig (Tests)
-(int)setKeyPairSize:(int)keyPairSize;
@end

@implementation AuthenticatorConfig_Test

- (void)setUp
{
    [super setUp];
}

-(void)testSetAndGetKeyPairSize
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.keyPairSize = keypair_minimum;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].keyPairSize != keypair_minimum)XCTFail(@"Key pair size not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.keyPairSize = keypair_medium;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].keyPairSize != keypair_medium)XCTFail(@"Key pair size not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.keyPairSize = keypair_maximum;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].keyPairSize != keypair_maximum)XCTFail(@"Key pair size not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.keyPairSize = -1;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].keyPairSize != keypair_maximum)XCTFail(@"Key pair size not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.keyPairSize = 0;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].keyPairSize != keypair_maximum)XCTFail(@"Key pair size not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.keyPairSize = 1;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].keyPairSize != keypair_minimum)XCTFail(@"Key pair size not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.keyPairSize = 3000;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].keyPairSize != keypair_medium)XCTFail(@"Key pair size not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.keyPairSize = 3500;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].keyPairSize != keypair_maximum)XCTFail(@"Key pair size not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.keyPairSize = 5000;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].keyPairSize != keypair_maximum)XCTFail(@"Key pair size not set correctly");
}

-(void)testSetAndGetActivationDelayWearables
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.activationDelayWearable = -10;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayWearable != activationDelayDefault)XCTFail(@"Activation delay for Wearables was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.activationDelayWearable = 0;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayWearable != activationDelayMin)XCTFail(@"Activation delay for Wearables was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.activationDelayWearable = 500;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayWearable != 500)XCTFail(@"Activation delay for Wearables was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.activationDelayWearable = 86400;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayWearable != activationDelayMax)XCTFail(@"Activation delay for Wearables was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.activationDelayWearable = 86401;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayWearable != activationDelayDefault)XCTFail(@"Activation delay for Wearables was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.activationDelayWearable = activationDelayMin;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayWearable != activationDelayMin)XCTFail(@"Activation delay for Wearables was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
    builder.activationDelayWearable = activationDelayMax;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayWearable != activationDelayMax)XCTFail(@"Activation delay for Wearables was not set correctly");
}

-(void)testSetAndGetactivationDelayLocation
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.activationDelayLocation = -10;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayLocation != activationDelayDefault)XCTFail(@"Activation delay for Locations was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.activationDelayLocation = 0;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayLocation != activationDelayMin)XCTFail(@"Activation delay for Locations was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.activationDelayLocation = 500;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayLocation != 500)XCTFail(@"Activation delay for Locations was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.activationDelayLocation = 86400;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayLocation != activationDelayMax)XCTFail(@"Activation delay for Locations was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.activationDelayLocation = 86401;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayLocation != activationDelayDefault)XCTFail(@"Activation delay for Locations was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.activationDelayLocation = activationDelayMin;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayLocation != activationDelayMin)XCTFail(@"Activation delay for Locations was not set correctly");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.activationDelayLocation = activationDelayMax;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].activationDelayLocation != activationDelayMax)XCTFail(@"Activation delay for Locations was not set correctly");
}

-(void)testSetAndGetFont
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.customFont = @"BlahBlahFont";
    }];
    [[AuthenticatorManager sharedClient] initialize:config];

    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"System"])XCTFail(@"Font should be default Font");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.customFont = @"Verdana";
    }];
    [[AuthenticatorManager sharedClient] initialize:config];

    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].customFont isEqualToString:@"Verdana"])XCTFail(@"Font is not set properly");
}

-(void)testSSLPinning
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.SSLPinningEnabled = YES;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if(![[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].SSLPinningEnabled)XCTFail(@"SSL Pinning should be enabled");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.SSLPinningEnabled = NO;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].SSLPinningEnabled)XCTFail(@"SSL Pinning should be disabled");
}

-(void)testEnablingInfo
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableInfoButtons = YES;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if(![[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableInfoButtons)XCTFail(@"Info should be enabled");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableInfoButtons = NO;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];

    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableInfoButtons)XCTFail(@"Info should be disabled");
}

-(void)testEnableHeaderViews
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableHeaderViews = YES;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if(![[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableHeaderViews)XCTFail(@"Header Views should be enabled");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableHeaderViews = NO;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableHeaderViews)XCTFail(@"Header Views should be disabled");
}

-(void)testEnableSecurityFactorImages
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableSecurityFactorImages = YES;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if(![[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableSecurityFactorImages)XCTFail(@"Security factor images should be enabled");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableSecurityFactorImages = NO;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];

    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableSecurityFactorImages)XCTFail(@"Security factor images should be disabled");
}

-(void)testEnableNotificationPrompt
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableNotificationPrompt = YES;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if(![[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableNotificationPrompt)XCTFail(@"Notification prompt should be enabled");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableNotificationPrompt = NO;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableNotificationPrompt)XCTFail(@"Notification prompt should be disabled");
}

-(void)testControlsBackgroundColor
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.controlsBackgroundColor = [UIColor whiteColor];
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if(![[[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].controlsBackgroundColor isEqual:[UIColor whiteColor]])XCTFail(@"Controls background color not set correctly");
}

-(void)testEnableAnimation
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableViewControllerTransitionAnimation = YES;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if(![[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableViewControllerTransitionAnimation)XCTFail(@"Animations should be enabled");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableViewControllerTransitionAnimation = NO;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableViewControllerTransitionAnimation)XCTFail(@"Animations should be disabled");
}

-(void)testEnableBackBarButtonItem
{
    AuthenticatorConfig *config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableBackBarButtonItem = YES;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if(![[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableBackBarButtonItem)XCTFail(@"Back bar button item should be enabled");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.enableBackBarButtonItem = NO;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];
    
    if([[AuthenticatorManager sharedClient] getAuthenticatorConfigInstance].enableBackBarButtonItem)XCTFail(@"Back bar button item should be disabled");
}

-(void)testSetAuthFailureThreshold
{
    AuthenticatorConfig *config = [AuthenticatorConfig new];

    XCTAssertThrowsSpecific(config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAuthFailure = thresholdAuthFailureMin - 1;
    }], NSException, @"Should throw an exception");

    XCTAssertThrowsSpecific(config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAuthFailure = thresholdAuthFailureMax+ 1;
    }], NSException, @"Should throw an exception");

    XCTAssertNoThrow(config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAuthFailure = thresholdAuthFailureDefault;
    }], @"Should not throw an exception");

    XCTAssertNoThrow(config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAuthFailure = thresholdAuthFailureMin;
    }], @"Should not throw an exception");

    XCTAssertNoThrow(config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAuthFailure = thresholdAuthFailureMax;
    }], @"Should not throw an exception");

    XCTAssertThrowsSpecific(config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAutoUnlinkWarning = 0;
        builder.thresholdAutoUnlink = 2;
    }], NSException, @"Should throw an exception");
}

-(void)testSetAutoUnlinkThreshold
{
    AuthenticatorConfig *config = [AuthenticatorConfig new];

    XCTAssertThrowsSpecific(config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAutoUnlink = thresholdAutoUnlinkMin;
    }], NSException, @"Should throw an exception");

    config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAutoUnlink = thresholdAutoUnlinkMin;
        builder.thresholdAuthFailure = thresholdAuthFailureMin;
    }];
    [[AuthenticatorManager sharedClient] initialize:config];

    XCTAssertNoThrow(config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAutoUnlink = thresholdAutoUnlinkMin;
        builder.thresholdAuthFailure = thresholdAuthFailureMin;
    }], @"Should not throw an exception");

    XCTAssertNoThrow([AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAutoUnlink = thresholdAutoUnlinkDefault;
    }], @"Should not throw an exception");

    XCTAssertThrowsSpecific([AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAutoUnlink = thresholdAutoUnlinkMin - 1;
    }], NSException, @"Should throw an exception");

    XCTAssertThrowsSpecific([AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAutoUnlink = thresholdAutoUnlinkMax + 1;
    }], NSException, @"Should throw an exception");

    XCTAssertNoThrow([AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
        builder.thresholdAutoUnlink = thresholdAutoUnlinkMax;
    }], @"Should not throw an exception");
}

@end
