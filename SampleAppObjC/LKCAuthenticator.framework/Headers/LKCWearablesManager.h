//
//  LKCWearablesManager.h
//  Authenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCWearable.h"
#import "LKCAuthenticatorManager.h"
#import "LKCAuthRequestDetails.h"
#import "LKCVerificationFlag.h"

typedef void (^wearablesCompletion)(NSArray *connectedWearables, NSString *error);
typedef void (^addWearableCompletion)(NSError *error);
typedef void (^removeWearableCompletion)(LKCWearable *wearable);
typedef void (^cancelRemoveWearableCompletion)(LKCWearable *wearable, NSString *error);
typedef void (^wearablesCheckCompletion)(BOOL sucess, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining);
typedef void (^getWearablesCompletion)(NSArray *wearables);
typedef void (^verificationFlagCompletion)(NSString *timeRemaining);

@interface LKCWearablesManager : NSObject

/*!
 @brief Use this method retrieve the list of connected wearables.
 @discussion This method will return an array of LKCWearable objects which represent the connected wearables on the OS. If there is an error retrieving the list (i.e. Bluetooth permissions are disabled), an error will be returned.
 @param completion The completion block that will return either an array of LKCWearable objects, or an error (if any).
*/
+(void)getAvailableWearablesWithCompletion:(wearablesCompletion)completion;
/*!
 @brief Use this method to set a wearable object.
 @discussion This method accepts a wearable object to be set. If the wearbale is one of the connected wearables returned in `getAvailableWearablesWithCompletion` then the wearbale will be set within the SDK. If it does not match one of the wearables returned, an exception will be raised. If the wearable name is already taken, an exception will be raised. If the wearable has already been set within the SDK, an error will be returned in the completion block.
 @param wearable The input value representing the wearable object to be set.
 @param completion The completion block that will return an error object, if any
*/
+(void)addWearable:(LKCWearable*)wearable withCompletion:(addWearableCompletion)completion;
/*!
 @brief Use this method to remove a wearable object.
 @discussion This method accepts a wearable object to be removed. If the wearable was successfully removed, the completion block will return nil. Otherwise, the wearable will be set to be removed after the activation delay completes and the completion block will return the wearable object with updated properties for timeRemoved. If the wearable was already set to be removed, the wearable will be set back to active and the completion block will return the wearable object with no timeRemoved property.
 @param wearable The input value representing the wearable object to be removed.
 @param completion The completion block that will return the updated wearable object or nil, depending on the activation delay.
*/
+(void)removeWearable:(LKCWearable*)wearable withCompletion:(removeWearableCompletion)completion;
/*!
 @brief Use this method to cancel the removal of a wearable object.
 @discussion This method accepts a wearable object that is set to be removed. The wearable will be set back to active and the completion block will return the wearable object with no timeRemoved property. If the wearable is not set to be removed or invalid, the completion block with return an error.
 @param wearable The input value representing the wearable object to cancel the removal.
 @param completion The completion block that will return the updated wearable object or an error, if any.
*/
+(void)cancelRemove:(LKCWearable*)wearable withCompletion:(cancelRemoveWearableCompletion)completion;
/*!
 @brief Use this method to verify Wearables.
 @discussion This method checks the Wearables set on the device against list of connected Wearables
 @param request The Auth Request that requires verification.
 @param completion The completion block that will return success as true if Wearables check was valid. Otherwise, success will be false and an error will be returned.
*/
+(void)verifyWearablesForAuthRequest:(LKCAuthRequestDetails*)request withCompletion:(wearablesCheckCompletion)completion;
/*!
 @brief Use this method to retrieve an array of LKCWearable objects representing the wearables set within the SDK.
 @discussion This method returns an array of LKCWearable objects that are currently set within the SDK in the completion block,.
 @param completion The completion black that will return an array of LKCWearable objects.
*/
+(void)getStoredWearablesWithCompletion:(getWearablesCompletion)completion;
/*!
 @brief Use this method to change the Verification Flag.
 @discussion This method will change the verification flag once the activation delay is honored.
 @param completion The completion block that will return the activation delay remaining for the change of the verification flag to be completion. If there is no time remaining, nil will be returned.
*/
+(void)changeVerificationFlagWithCompletion:(verificationFlagCompletion)completion;
/*!
 @brief Use this method to retrieve the Verification Flag.
 @discussion This method returns the Verification Flag.
*/
+(LKCVerificationFlag*)getVerificationFlag;

@end
