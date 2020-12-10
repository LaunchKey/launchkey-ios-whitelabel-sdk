//
//  LKCFaceScanManager.h
//  Authenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCAuthenticatorManager.h"
#import "LKCAuthRequestDetails.h"
#import "LKCVerificationFlag.h"

typedef void (^faceScanCompletion)(BOOL success, NSError *error);
typedef void (^faceScanCheckCompletion)(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining);

@interface LKCFaceScanManager : NSObject

/*!
 @brief Use this method to set Face Scan within the SDK.
 @discussion This method will bring up the OS-level prompt to set up Face Scan and will accept the state of the Verification Flag (always/when required). If there is an error setting up Face Scan, an error will be returned in the completion block and success will be false. Otherwise, success will be true.
 @param state The input value representing the state of the Verification Flag (ALWAYS/WHENREQUIRED).
*/
+(void)setFaceScanWithVerificationFlag:(FlagState)state withCompletion:(faceScanCompletion)completion;
/*!
 @brief Use this method to determine if FaceScan is set up and ready to be used to verify auth requests.
*/
+(BOOL)isFaceScanSet;
/*!
 @brief Use this method to remove Face Scan set within the SDK.
 @discussion This method will bring up the OS-level prompt to remove Face Scan within the SDK. If successful, Face Scan will be removed and success will be true. If they do not match, an error will be returned in the completion block.
*/
+(void)removeFaceScanWithCompletion:(faceScanCheckCompletion)completion;
/*!
 @brief Use this method to verify Face Scan within the SDK.
 @param request The Auth Request that requires verification.
 @param completion The completion block that will return if verification was successful and if there was an error.
 @discussion This method will bring up the OS-level prompt to verify Face Scan within the SDK. If they match, success will be true. If they do not match, an error will be returned in the completion block.
*/
+(void)verifyFaceScanForAuthRequest:(LKCAuthRequestDetails*)request withCompletion:(faceScanCheckCompletion)completion;
/*!
 @brief Use this method to change the Verification Flag.
 @discussion This method will bring up the OS-level prompt to verify Face Scan within the SDK. If they match,  success will be true and the Verification Flag state will change. If they do not match, an error will be returned in the completion block.
*/
+(void)changeVerificationFlagWithCompletion:(faceScanCheckCompletion)completion;
/*!
 @brief Use this method to retrieve the Verification Flag.
 @discussion This method returns the Verification Flag.
*/
+(LKCVerificationFlag*)getVerificationFlag;
/*!
 @brief Use this method to see if Face ID is available on the device.
 @discussion This method returns TRUE if Face ID is set and available on the device. It returns FALSE otherwise.
*/
+(BOOL)isFaceIDAvailable;
/*!
 @brief Use this method invalidate the Face ID request and remove the Face ID prompt.
 @discussion This method will invalidate the Face ID request and remove the Face ID prompt.
*/
+(void)invalidateFaceIDRequest;

@end
