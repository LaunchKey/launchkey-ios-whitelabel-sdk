//
//  LKCCircleCodeManager.h
//  Authenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCAuthenticatorManager.h"
#import "LKCAuthRequestDetails.h"
#import "LKCVerificationFlag.h"

typedef enum {
    UP = 0,
    UPRIGHT = 1,
    RIGHT = 2,
    DOWNRIGHT = 3,
    DOWN = 4,
    DOWNLEFT = 5,
    LEFT = 6,
    UPLEFT = 7,
} LKCCircleCodeTick;

typedef void (^circleCodeCheckCompletion)(BOOL success, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining);

@interface LKCCircleCodeManager : NSObject

/*!
 @brief Use this method to set a Circle Code within the SDK.
 @discussion This method accepts a string representing the Circle Code to save to SDK as well as the state of the Verification Flag (always/when required). If the Circle Code length does not meet the requirements, an error will be returned.
 @param circleCode The input value representing the Circle Code array. The array must be of LKCCircleCodeTick enum values. Length must be 2-120 "clicks" (hash mark hits).
 @param state The input value representing the state of the Verification Flag (ALWAYS/WHENREQUIRED).
*/
+(NSError*)setCircleCode:(NSArray *)circleCode withVerificationFlag:(FlagState)state;
/*!
 @brief Use this method to determine if CircleCode is set up and ready to be used to verify auth requests.
 @discussion This method will return TRUE if Circle Code has been set up, otherwise it will return FALSE.
*/
+(BOOL)isCircleCodeSet;
/*!
 @brief Use this method to remove the Circle Code set within the SDK.
 @discussion This method accepts a string representing the Circle Code to compare to the stored Circle Code within the SDK. If they match, the Circle Code set will be removed and the method will return TRUE. If they do not match, FALSE will be returned.
 @param circleCode The input value representing the Circle Code array for verification.
 @param completion The completion block that will return success as true if Circle Code was valid. Otherwise, success will be false and an error will be returned.
*/
+(void)removeCircleCode:(NSArray *)circleCode withCompletion:(circleCodeCheckCompletion)completion;
/*!
 @brief Use this method to verify the Circle Code set within the SDK.
 @discussion This method accepts an array representing the Circle Code to compare to the stored Circle Code within the SDK. If they match, the completion block will be called with success as TRUE. If they do not match, FALSE will be returned in the completion block along with an error.
 @param circleCode The input value representing the Circle Code array for verification.
 @param request The Auth Request that requires verification.
 @param completion The completion block that will return success as true if Circle Code was valid. Otherwise, success will be false and an error will be returned.
*/
+(void)verifyCircleCode:(NSArray *)circleCode forAuthRequest:(LKCAuthRequestDetails*)request withCompletion:(circleCodeCheckCompletion)completion;
/*!
 @brief Use this method to change the Verification Flag.
 @discussion This method accepts a string representing the Circle Code to compare to the stored Circle Code within the SDK. If they match, the completion block will be called with success as TRUE and the Verification Flag state will change. If they do not match, FALSE will be returned in the completion block along with an error.
 @param circleCode The input value representing the Circle Code array for verification.
 @param completion The completion block that will return success as true if Circle Code was valid. Otherwise, success will be false and an error will be returned.
*/
+(void)changeVerificationFlag:(NSArray *)circleCode withCompletion:(circleCodeCheckCompletion)completion;
/*!
 @brief Use this method to retrieve the Verification Flag.
 @discussion This method returns the Verification Flag.
*/
+(LKCVerificationFlag*)getVerificationFlag;

@end

