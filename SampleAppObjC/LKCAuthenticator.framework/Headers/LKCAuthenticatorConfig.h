//
//  LKCAuthenticatorConfig.h
//  Authenticator
//
//  Created by ani on 10/2/18.
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKCAuthenticatorConfig;
@class UIColor;

@interface LKCAuthenticatorConfigBuilder : NSObject

/// This BOOL property determines if SSL Pinning should be enabled (pass YES) or disabled (pass NO). */
@property (nonatomic, assign) BOOL SSLPinningEnabled;
/// This int property sets the key pair size. This size can be between 2048-4096 bits. By default, the key pair size is 4096. */
@property (nonatomic, assign) int keyPairSize;
/// This int property sets activation delay for Wearbles which is the time it takes for the SDK to add or remove this auth method. This delay can be between 0 seconds to 24 hours. By default, the activation delay is 600 seconds (10 minutes). */
@property (nonatomic, assign) int activationDelayWearable;
/// This int property sets activation delay for Locations which is the time it takes for the SDK to add or remove this auth method. This delay can be between 0 seconds to 24 hours. By default, the activation delay is 600 seconds (10 minutes). */
@property (nonatomic, assign) int activationDelayLocation;
/// This int property sets the threshold at which failed authentication attempts result in a "Failure:Authentication" response (limited to PIN Code and Circle Code). The default value is 5 attempts. */
@property (nonatomic, assign) int thresholdAuthFailure;
/// This int property sets the threshold after which successive failed authentication attempts displays a warning to the End User and applies to every single authentication method. The default value is 2 attempts less than the auto-unlink threshold. */
@property (nonatomic, assign) int thresholdAutoUnlinkWarning;
/// This int property sets the threshold at which failed authentication attempts result in the unlinking of the authenticaor and applies to every single authentication method. The default value is 10 attempts. */
@property (nonatomic, assign) int thresholdAutoUnlink;
@property (nonatomic, assign) BOOL enableSecurityChangesWhenUnlinked;
/// This BOOL property enables (pass YES) or disables (pass NO) PIN Code (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enablePINCode;
/// This BOOL property enables (pass YES) or disables (pass NO) Circle Code (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enableCircleCode;
/// This BOOL property enables (pass YES) or disables (pass NO) Locations (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enableLocations;
/// This BOOL property enables (pass YES) or disables (pass NO) Wearables (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enableWearable;
/// This BOOL property enables (pass YES) or disables (pass NO) Fingerprint (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enableFingerprint;
/// This BOOL property enables (pass YES) or disables (pass NO) Face Scan (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enableFace;

@end

@interface LKCAuthenticatorConfig : NSObject

@property (nonatomic, assign, readonly) BOOL SSLPinningEnabled;
@property (nonatomic, assign, readonly) int keyPairSize;
@property (nonatomic, assign, readonly) int activationDelayWearable;
@property (nonatomic, assign, readonly) int activationDelayLocation;
@property (nonatomic, assign, readonly) int thresholdAuthFailure;
@property (nonatomic, assign, readonly) int thresholdAutoUnlinkWarning;
@property (nonatomic, assign, readonly) int thresholdAutoUnlink;
@property (nonatomic, assign, readonly) BOOL enableSecurityChangesWhenUnlinked;
@property (nonatomic, assign, readonly) BOOL enablePINCode;
@property (nonatomic, assign, readonly) BOOL enableCircleCode;
@property (nonatomic, assign, readonly) BOOL enableLocations;
@property (nonatomic, assign, readonly) BOOL enableWearable;
@property (nonatomic, assign, readonly) BOOL enableFingerprint;
@property (nonatomic, assign, readonly) BOOL enableFace;

-(instancetype)initWithAuthenticatorConfigBuilder:(LKCAuthenticatorConfigBuilder *)builder;
+(instancetype)makeWithAuthenticatorConfigBuilder:(void (^)(LKCAuthenticatorConfigBuilder *))builder;

@end
