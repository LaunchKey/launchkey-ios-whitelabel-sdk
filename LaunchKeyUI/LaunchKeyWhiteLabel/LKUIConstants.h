//
//  LKUIConstants.h
//  LaunchKeyUI
//
//  Created by Steven Gerhard on 2/27/20.
//  Copyright © 2020 TransUnion. All rights reserved.
//

// Colors
#define defaultAuthContentViewBackgroundColor                  [UIColor clearColor]
#define defaultAuthTextColor                                   [UIColor colorWithRed:(136.0/255.0) green:(136.0/255.0) blue:(136.0/255.0) alpha:1.0]
#define defaultExpirationTimerBackgroundColor                  [UIColor colorWithRed:(217.0/255.0) green:(217.0/255.0) blue:(217.0/255.0) alpha:1.0]
#define defaultExpirationTimerFillColor                        [UIColor colorWithRed:(119.0/255.0) green:(119.0/255.0) blue:(119.0/255.0) alpha:1.0]
#define defaultExpirationTimerWarningColor                     [UIColor colorWithRed:(219.0/255.0) green:(65.0/255.0) blue:(106.0/255.0) alpha:1.0]
#define defaultAuthResponseButtonBackgroundColor               [UIColor colorWithRed:(38.0/255.0) green:(153.0/255.0) blue:(251.0/255.0) alpha:1.0]
#define defaultAuthResponseNegativeButtonBackgroundColor       [UIColor colorWithRed:(219.0/255.0) green:(65.0/255.0) blue:(106.0/255.0) alpha:1.0]
#define defaultAuthResponseFillColor                           [UIColor colorWithRed:(9.0/255.0) green:(127.0/255.0) blue:(227.0/255.0) alpha:1.0]
#define defaultAuthResponseNegativeFillColor                   [UIColor colorWithRed:(163.0/255.0) green:(47.0/255.0) blue:(92.0/255.0) alpha:1.0]
#define defaultAuthResponseButtonTextColor                     [UIColor whiteColor]
#define defaultAuthResponseAuthorizedColor                     [UIColor colorWithRed:(67.0/255.0) green:(183.0/255.0) blue:(125.0/255.0) alpha:1.0]
#define defaultAuthResponseDeniedColor                         [UIColor colorWithRed:(219.0/255.0) green:(65.0/255.0) blue:(106.0/255.0) alpha:1.0]
#define defaultAuthResponseFailedColor                         [UIColor colorWithRed:(219.0/255.0) green:(65.0/255.0) blue:(106.0/255.0) alpha:1.0]
#define defaultAuthResponseDenialReasonUnselectedColor         [UIColor colorWithRed:(136.0/255.0) green:(136.0/255.0) blue:(136.0/255.0) alpha:1.0]
#define defaultAuthResponseDenialReasonSelectedColor           [UIColor colorWithRed:(219.0/255.0) green:(65.0/255.0) blue:(106.0/255.0) alpha:1.0]


// Duplicates to LKConstants below
#define kLKAuthRequestExpiresAt @"AuthRequestExpiresAt"
#define durationForProgress 0.27
#define progressIncrement 0.015
#define kLKUnlinkDevicePINFailed @"UnlinkDevicePINFailed"
#define kLKUnlinkDeviceCircleFailed @"UnlinkDeviceCircleFailed"
#define kLKUnlinkDeviceWearablesFailed @"UnlinkDeviceWearablesFailed"
#define kLKUnlinkDeviceLocationsFailed @"UnlinkDeviceLocationsFailed"
#define kLKUnlinkDeviceFaceFailed @"UnlinkDeviceFaceFailed"
#define kLKUnlinkDeviceFingerprintFailed @"UnlinkDeviceFingerprintFailed"
#define kLKLaunchKeyDevicePaired @"LaunchKeyDevicePaired"
#define kLKLaunchKeyCloseQRView @"LaunchKeyCloseQRView"

#define kLKAuthFailureThresholdAttempts @"sk@kj0EnkSjd"
#define kLKPINCodeAttemptsCount @"PINCodeAttemptsCount"
#define kLKCircleCodeAttemptsCount @"CircleCodeAttemptsCount"
#define kLKWearables @"Wearables"
#define kLKLocations @"Locations"
#define kLKGeofences @"Geofences"
#define kLKPINCode @"PINCode"
#define kLKCircleCode @"CircleCode"
#define kLKFingerprintScan @"FingerprintScan"
#define kLKFaceScan @"FaceScan"
#define kLKDeviceName @"vkZ8ZJGYsUL5"

#define methodNameMinimum 4
#define kLKGeoFenceMiniumuRadius 10
#define kLKLaunchKeyToken @"dLNY4ctubE57"
#define kLkCircleCodeInvalidCount @"s#DF!nkSTd"
#define circleCodeMinimum 2
#define circleCodeMaximum 120
#define kLKPINCodeInvalidCount @"qk@kj0EnjlNd"

// Functions
#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI )
#define SQR(x)            ( (x) * (x) )
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
