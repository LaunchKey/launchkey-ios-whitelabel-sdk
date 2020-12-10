//
//  LKCPINCodeManager.h
//  Authenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCAuthenticatorManager.h"
#import "LKCAuthRequestDetails.h"
#import "LKCVerificationFlag.h"

typedef void (^pinCodeCheckCompletion)(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining);

@interface LKCPINCodeManager : NSObject

/*!
 @brief Use this method to set a PIN Code within the SDK.
 @discussion This method accepts a string representing the PIN Code to save to SDK as well as the state of the Verification Flag (always/when required). If the PIN Code length does not meet the requirements, an error will be raised.
 @param PINCode The input value representing the PIN Code string. Length must be 1-1024 alphanumeric string.
 @param state The input value representing the state of the Verification Flag (ALWAYS/WHENREQUIRED).
*/
+(NSError*)setPINCode:(NSString *)PINCode withVerificationFlag:(FlagState)state;
/*!
 @brief Use this method to determine if PINCode is set up and ready to be used to verify auth requests.
*/
+(BOOL)isPINCodeSet;
/*!
 @brief Use this method to remove the PIN Code set within the SDK.
 @discussion This method accepts a string representing the PIN Code to compare to the stored PIN Code within the SDK. If they match, the completion block will be called with success as TRUE. If they do not match, FALSE will be returned in the completion block along with an error.
 @param PINCode The input value representing the PIN Code string for verification.
 @param completion The completion block that will return success as true if PIN Code was valid. Otherwise, success will be false and an error will be returned.
*/
+(void)removePINCode:(NSString *)PINCode withCompletion:(pinCodeCheckCompletion)completion;
/*!
 @brief Use this method to verify the PIN Code set within the SDK.
 @discussion This method accepts a string representing the PIN Code to compare to the stored PIN Code within the SDK. If they match, the completion block will be called with success as TRUE. If they do not match, FALSE will be returned in the completion block along with an error.
 @param PINCode The input value representing the PIN Code string for verification.
 @param request The Auth Request that requires verification.
 @param completion The completion block that will return success as true if PIN Code was valid. Otherwise, success will be false and an error will be returned.
*/
+(void)verifyPINCode:(NSString *)PINCode forAuthRequest:(LKCAuthRequestDetails*)request withCompletion:(pinCodeCheckCompletion)completion;
/*!
 @brief Use this method to change the Verification Flag.
 @discussion This method accepts a string representing the PIN Code to compare to the stored PIN Code within the SDK. If they match, the completion block will be called with success as TRUE and the Verification Flag state will change. If they do not match, FALSE will be returned in the completion block along with an error.
 @param PINCode The input value representing the PIN Code string for verification.
 @param completion The completion block that will return success as true if PIN Code was valid. Otherwise, success will be false and an error will be returned.
*/
+(void)changeVerificationFlag:(NSString *)PINCode withCompletion:(pinCodeCheckCompletion)completion;
/*!
 @brief Use this method to retrieve the Verification Flag.
 @discussion This method returns the Verification Flag.
*/
+(LKCVerificationFlag*)getVerificationFlag;

@end
