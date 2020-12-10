//
//  LKCFingerprintScanManager.h
//  Authenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCAuthenticatorManager.h"
#import "LKCAuthRequestDetails.h"
#import "LKCVerificationFlag.h"

typedef void (^fingerprintScanCompletion)(BOOL success, NSError *error);
typedef void (^fingerprintScanCheckCompletion)(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining);

@interface LKCFingerprintScanManager : NSObject

/*!
 @brief Use this method to set Fingerprint Scan within the SDK.
 @discussion This method will bring up the OS-level prompt to set up Fingerprint Scan and will accept the state of the Verification Flag (always/when required). If there is an error setting up Fingerprint Scan, an error will be returned in the completion block and success will be false. Otherwise, success will be true.
 @param state The input value representing the state of the Verification Flag (ALWAYS/WHENREQUIRED).
*/
+(void)setFingerprintScanWithVerificationFlag:(FlagState)state withCompletion:(fingerprintScanCompletion)completion;
/*!
 @brief Use this method to determine if FingerprintScan is set up and ready to be used to verify auth requests.
*/
+(BOOL)isFingerprintScanSet;
/*!
 @brief Use this method to remove Fingerprint Scan set within the SDK.
 @discussion This method will bring up the OS-level prompt to remove Fingerprint Scan within the SDK. If successful, Fingerprint Scan will be removed and success will be true. If they do not match, an error will be returned in the completion block.
*/
+(void)removeFingerprintScanWithCompletion:(fingerprintScanCheckCompletion)completion;
/*!
 @brief Use this method to verify Fingerprint Scan within the SDK.
 @param request The Auth Request that requires verification.
 @param completion The completion block that will return if verification was successful and if there was an error.
 @discussion This method will bring up the OS-level prompt to verify Fingerprint Scan within the SDK. If they match, success will be true. If they do not match, an error will be returned in the completion block.
*/
+(void)verifyFingerprintScanForAuthRequest:(LKCAuthRequestDetails*)request withCompletion:(fingerprintScanCheckCompletion)completion;
/*!
 @brief Use this method to change the Verification Flag.
 @discussion This method will bring up the OS-level prompt to verify Fingerprint Scan within the SDK. If they match,  success will be true and the Verification Flag state will change. If they do not match, an error will be returned in the completion block.
*/
+(void)changeVerificationFlagWithCompletion:(fingerprintScanCheckCompletion)completion;
/*!
 @brief Use this method to retrieve the Verification Flag.
 @discussion This method returns the Verification Flag.
*/
+(LKCVerificationFlag*)getVerificationFlag;
/*!
 @brief Use this method to see if Touch ID is available on the device.
 @discussion This method returns TRUE if Touch ID is set and available on the device. It returns FALSE otherwise.
*/
+(BOOL)isTouchIDAvailable;
/*!
 @brief Use this method invalidate the Touch ID request and remove the Touch ID prompt.
 @discussion This method will invalidate the Touch ID request and remove the Touch ID prompt.
*/
+(void)invalidateTouchIDRequest;

@end
