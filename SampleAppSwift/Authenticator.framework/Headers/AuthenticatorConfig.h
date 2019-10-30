//
//  AuthenticatorConfig.h
//  Authenticator
//
//  Created by ani on 10/2/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AuthenticatorConfig;
@class UIColor;

@interface AuthenticatorConfigBuilder : NSObject

/// This NSString property is the Mobile Authenticaor Key. */
@property (nonatomic, strong) NSString *sdkKey;
/// This BOOL property determines if SSL Pinning should be enabled (pass YES) or disabled (pass NO). */
@property (nonatomic, assign) BOOL SSLPinningEnabled;
/// This int property sets the key pair size. This size can be between 2048-4096 bits. By default, the key pair size is 4096. */
@property (nonatomic, assign) int keyPairSize;
/// This int property sets activation delay for Wearbles which is the time it takes for the SDK to add or remove this auth method. This delay can be between 0 seconds to 24 hours. By default, the activation delay is 600 seconds (10 minutes). */
@property (nonatomic, assign) int activationDelayWearable;
/// This int property sets activation delay for Locations which is the time it takes for the SDK to add or remove this auth method. This delay can be between 0 seconds to 24 hours. By default, the activation delay is 600 seconds (10 minutes). */
@property (nonatomic, assign) int activationDelayGeofence;
/// This int property sets the threshold at which failed authentication attempts result in a "Failure:Authentication" response (limited to PIN Code and Circle Code). The default value is 5 attempts. */
@property (nonatomic, assign) int thresholdAuthFailure;
/// This int property sets the threshold after which successive failed authentication attempts displays a warning to the End User and applies to every single authentication method. The default value is 2 attempts less than the auto-unlink threshold. */
@property (nonatomic, assign) int thresholdAutoUnlinkWarning;
/// This int property sets the threshold at which failed authentication attempts result in the unlinking of the authenticaor and applies to every single authentication method. The default value is 10 attempts. */
@property (nonatomic, assign) int thresholdAutoUnlink;
/// This NSString property is the name of the custom font that you want to set all the font in the Auth SDK views to. */
@property (nonatomic, strong) NSString *customFont;
/// This BOOL property enables (pass YES) or disables (pass NO) the info buttons in the nav bar of the Security Views. */
@property (nonatomic, assign) BOOL enableInfoButtons;
/// This BOOL property enables (pass YES) or disables (pass NO) the TableView Headers. */
@property (nonatomic, assign) BOOL enableHeaderViews;
/// This BOOL property enables (pass YES) or disables (pass NO) the Security Factor Images in the Security View. */
@property (nonatomic, assign) BOOL enableSecurityFactorImages;
/// This BOOL property enables (pass YES) or disables (pass NO) the push notification alert that is displayed after 24 hours if push notifications are not enabled. */
@property (nonatomic, assign) BOOL enableNotificationPrompt;
/// This BOOL property enables (pass YES) or disables (pass NO) the view controller animation when transitioning. */
@property (nonatomic, assign) BOOL enableViewControllerTransitionAnimation;
/// This BOOL property enables (pass YES) or disables (pass NO) the back bar button item in the nav bar. */
@property (nonatomic, assign) BOOL enableBackBarButtonItem;
/// This BOOL property enables (pass YES) or disables (pass NO) access to the Security View when the device is unlinked. */
@property (nonatomic, assign) BOOL enableSecurityChangesWhenUnlinked;
/// This BOOL property enables (pass YES) or disables (pass NO) PIN Code (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enablePINCode;
/// This BOOL property enables (pass YES) or disables (pass NO) Circle Code (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enableCircleCode;
/// This BOOL property enables (pass YES) or disables (pass NO) Geofencing (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enableGeofencing;
/// This BOOL property enables (pass YES) or disables (pass NO) Wearables (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enableWearable;
/// This BOOL property enables (pass YES) or disables (pass NO) Fingerprint (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enableFingerprint;
/// This BOOL property enables (pass YES) or disables (pass NO) Face Scan (End Users will not be able to add this method if disabled). */
@property (nonatomic, assign) BOOL enableFace;
/// This UIColor property sets the background color of the controls view (within the Settings View of each auth method). */
@property (nonatomic, strong) UIColor *controlsBackgroundColor;
/// This UIColor property sets the background color of the TableView Headers. */
@property (nonatomic, strong) UIColor *tableViewHeaderBackgroundColor;
/// This UIColor property sets the text color of the TableView Headers. */
@property (nonatomic, strong) UIColor *tableViewHeaderTextColor;
/// This UIColor property sets the text color for all the text throughout the Security Views. */
@property (nonatomic, strong) UIColor *securityViewsTextColor;
/// This UIColor property sets the background color of the geofence circle. */
@property (nonatomic, strong) UIColor *geofenceCircleColor;
/// This UIColor property sets the color for the factor images in the TableView of the Security View. */
@property (nonatomic, strong) UIColor *securityFactorImageTintColor;
/// This UIColor property sets the background color of the content view within the Auth Request Views. */
@property (nonatomic, strong) UIColor *authContentViewBackgroundColor;
/// This UIColor property sets the text color within the Auth Request Views. */
@property (nonatomic, strong) UIColor *authTextColor;
/// This UIColor property sets the background color of the final confirmation view when an Auth Request has been authorized successfully. */
@property (nonatomic, strong) UIColor *authResponseAuthorizedColor;
/// This UIColor property sets the background color of the final confirmation view when an Auth Request has been denied successfully. */
@property (nonatomic, strong) UIColor *authResponseDeniedColor;
/// This UIColor property sets the text color of the title in the Failure view during an Auth Request. */
@property (nonatomic, strong) UIColor *authResponseFailedColor;
/// This UIColor property sets the text color within the TableView of all the denial context reasons. */
@property (nonatomic, strong) UIColor *authResponseDenialReasonUnselectedColor;
/// This UIColor property sets the text color within the TableView once an End User selects a denial context reason. */
@property (nonatomic, strong) UIColor *authResponseDenialReasonSelectedColor;

@end

@interface AuthenticatorConfig : NSObject

@property (nonatomic, strong, readonly) NSString *sdkKey;
@property (nonatomic, assign, readonly) BOOL SSLPinningEnabled;
@property (nonatomic, assign, readonly) int keyPairSize;
@property (nonatomic, assign, readonly) int activationDelayWearable;
@property (nonatomic, assign, readonly) int activationDelayGeofence;
@property (nonatomic, assign, readonly) int thresholdAuthFailure;
@property (nonatomic, assign, readonly) int thresholdAutoUnlinkWarning;
@property (nonatomic, assign, readonly) int thresholdAutoUnlink;
@property (nonatomic, strong, readonly) NSString *customFont;
@property (nonatomic, assign, readonly) BOOL enableInfoButtons;
@property (nonatomic, assign, readonly) BOOL enableHeaderViews;
@property (nonatomic, assign, readonly) BOOL enableSecurityFactorImages;
@property (nonatomic, assign, readonly) BOOL enableNotificationPrompt;
@property (nonatomic, assign, readonly) BOOL enableViewControllerTransitionAnimation;
@property (nonatomic, assign, readonly) BOOL enableBackBarButtonItem;
@property (nonatomic, assign, readonly) BOOL enableSecurityChangesWhenUnlinked;
@property (nonatomic, assign, readonly) BOOL enablePINCode;
@property (nonatomic, assign, readonly) BOOL enableCircleCode;
@property (nonatomic, assign, readonly) BOOL enableGeofencing;
@property (nonatomic, assign, readonly) BOOL enableWearable;
@property (nonatomic, assign, readonly) BOOL enableFingerprint;
@property (nonatomic, assign, readonly) BOOL enableFace;
@property (nonatomic, strong, readonly) UIColor *controlsBackgroundColor;
@property (nonatomic, strong, readonly) UIColor *tableViewHeaderBackgroundColor;
@property (nonatomic, strong, readonly) UIColor *tableViewHeaderTextColor;
@property (nonatomic, strong, readonly) UIColor *securityViewsTextColor;
@property (nonatomic, strong, readonly) UIColor *geofenceCircleColor;
@property (nonatomic, strong, readonly) UIColor *securityFactorImageTintColor;
@property (nonatomic, strong, readonly) UIColor *authContentViewBackgroundColor;
@property (nonatomic, strong, readonly) UIColor *authTextColor;
@property (nonatomic, strong, readonly) UIColor *authResponseAuthorizedColor;
@property (nonatomic, strong, readonly) UIColor *authResponseDeniedColor;
@property (nonatomic, strong, readonly) UIColor *authResponseFailedColor;
@property (nonatomic, strong, readonly) UIColor *authResponseDenialReasonUnselectedColor;
@property (nonatomic, strong, readonly) UIColor *authResponseDenialReasonSelectedColor;


-(instancetype)initWithAuthenticatorConfigBuilder:(AuthenticatorConfigBuilder *)builder;
+(instancetype)makeWithAuthenticatorConfigBuilder:(void (^)(AuthenticatorConfigBuilder *))builder;

@end
