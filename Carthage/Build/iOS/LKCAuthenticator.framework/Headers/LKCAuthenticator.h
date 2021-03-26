//
//  LKCAuthenticator.h
//  LaunchKey Core Authenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//! Project version number for Authenticator.
FOUNDATION_EXPORT double AuthenticatorVersionNumber;

//! Project version string for Authenticator.
FOUNDATION_EXPORT const unsigned char AuthenticatorVersionString[];

#import <LKCAuthenticator/LKCAPIRequestSpecs.h>
#import <LKCAuthenticator/LKCAPISessionMetrics.h>
#import <LKCAuthenticator/LKCAuthenticatorConfig.h>
#import <LKCAuthenticator/LKCAuthenticatorManager.h>
#import <LKCAuthenticator/LKCAuthRequestDetails.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import <LKCAuthenticator/LKCCircleCodeManager.h>
#import <LKCAuthenticator/LKCErrorCode.h>
#import <LKCAuthenticator/LKCFaceScanManager.h>
#import <LKCAuthenticator/LKCFingerprintScanManager.h>
#import <LKCAuthenticator/LKCHTTPSessionManager.h>
#import <LKCAuthenticator/LKCLocation.h>
#import <LKCAuthenticator/LKCLocationsManager.h>
#import <LKCAuthenticator/LKCPINCodeManager.h>
#import <LKCAuthenticator/LKCWearable.h>
#import <LKCAuthenticator/LKCWearablesManager.h>
#import <LKCAuthenticator/LKCDevice.h>
#import <LKCAuthenticator/LKCSession.h>
#import <LKCAuthenticator/LKCAuthRequestManager.h>
#import <LKCAuthenticator/LKCGeofenceManager.h>
