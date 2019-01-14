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

@property (nonatomic, strong) NSString *sdkKey;
@property (nonatomic, assign) BOOL SSLPinningEnabled;
@property (nonatomic, assign) int keyPairSize;
@property (nonatomic, assign) int activationDelayWearable;
@property (nonatomic, assign) int activationDelayGeofence;
@property (nonatomic, strong) NSString *customFont;
@property (nonatomic, assign) BOOL enableInfoButtons;
@property (nonatomic, assign) BOOL enableHeaderViews;
@property (nonatomic, assign) BOOL enableSecurityFactorImages;
@property (nonatomic, assign) BOOL enableNotificationPrompt;
@property (nonatomic, assign) BOOL enableViewControllerTransitionAnimation;
@property (nonatomic, assign) BOOL enableBackBarButtonItem;
@property (nonatomic, assign) BOOL enableSecurityChangesWhenUnlinked;
@property (nonatomic, assign) BOOL enablePINCode;
@property (nonatomic, assign) BOOL enableCircleCode;
@property (nonatomic, assign) BOOL enableGeofencing;
@property (nonatomic, assign) BOOL enableWearable;
@property (nonatomic, assign) BOOL enableFingerprint;
@property (nonatomic, assign) BOOL enableFace;
@property (nonatomic, strong) UIColor *controlsBackgroundColor;
@property (nonatomic, strong) UIColor *tableViewHeaderBackgroundColor;
@property (nonatomic, strong) UIColor *tableViewHeaderTextColor;
@property (nonatomic, strong) UIColor *securityViewsTextColor;
@property (nonatomic, strong) UIColor *geofenceCircleColor;
@property (nonatomic, strong) UIColor *securityFactorImageTintColor;
@property (nonatomic, strong) UIColor *authContentViewBackgroundColor;
@property (nonatomic, strong) UIColor *authTextColor;
@property (nonatomic, strong) UIColor *authResponseAuthorizedColor;
@property (nonatomic, strong) UIColor *authResponseDeniedColor;
@property (nonatomic, strong) UIColor *authResponseFailedColor;
@property (nonatomic, strong) UIColor *authResponseDenialReasonUnselectedColor;
@property (nonatomic, strong) UIColor *authResponseDenialReasonSelectedColor;

@end

@interface AuthenticatorConfig : NSObject

@property (nonatomic, strong, readonly) NSString *sdkKey;
@property (nonatomic, assign, readonly) BOOL SSLPinningEnabled;
@property (nonatomic, assign, readonly) int keyPairSize;
@property (nonatomic, assign, readonly) int activationDelayWearable;
@property (nonatomic, assign, readonly) int activationDelayGeofence;
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
