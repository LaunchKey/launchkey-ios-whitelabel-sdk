//
//  LKCLocationsManager.h
//  Authenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCLocation.h"
#import "LKCAuthenticatorManager.h"
#import "LKCAuthRequestDetails.h"
#import "LKCVerificationFlag.h"

@interface LKCLocationsManager : NSObject

typedef void (^removeLocationCompletion)(LKCLocation *location);
typedef void (^cancelRemoveLocationCompletion)(LKCLocation *location, NSString *error);
typedef void (^locationsCheckCompletion)(BOOL sucess, NSError *error, BOOL autoUnlinkWarningThresholdMet, int attemptsRemaining);
typedef void (^getLocationsCompletion)(NSArray *locations);
typedef void (^verificationFlagCompletion)(NSString *timeRemaining);

/*!
 @brief Use this method to set a location object.
 @discussion This method accepts a location object to be set. The location must include a latitude value, longitude value, radius value, and name that is at least 4 characters long. If the location name has already been taken or is invalid, an error will be returned.
 @param location The input value representing the location object to be set.
*/
+(NSError*)addLocation:(LKCLocation*)location;
/*!
 @brief Use this method to remove a location object.
 @discussion This method accepts a location object to be removed. If the location was successfully removed, the completion block will return nil. Otherwise, the location will be set to be removed after the activation delay completes and the completion block will return the location object with updated properties for timeRemoved.
 @param location The input value representing the location object to be removed.
 @param completion The completion block that will return the updated location object or nil, depending on the activation delay.
*/
+(void)removeLocation:(LKCLocation*)location withCompletion:(removeLocationCompletion)completion;
/*!
 @brief Use this method to cancel the removal of a location object.
 @discussion This method accepts a location object that is set to be removed. The location will be set back to active and the completion block will return the location object with no timeRemoved property. If the location is not set to be removed or invalid, the completion block with return an error.
 @param location The input value representing the location object to cancel the removal.
 @param completion The completion block that will return the updated location object or an error, if any.
*/
+(void)cancelRemove:(LKCLocation*)location withCompletion:(cancelRemoveLocationCompletion)completion;
/*!
 @brief Use this method to verify Locations.
 @discussion This method checks the Locations set on the device against the device's current location.
 @param request The Auth Request that requires verification.
 @param completion The completion block that will return success as true if Locations check was valid. Otherwise, success will be false and an error will be returned.
*/
+(void)verifyLocationsForAuthRequest:(LKCAuthRequestDetails*)request withCompletion:(locationsCheckCompletion)completion;
/*!
 @brief Use this method to retrieve an array of LKCLocation objects representing the locations set within the SDK.
 @discussion This method returns an array of LKCLocation objects that are currently set within the SDK in the completion block.
 @param completion The completion black that will return an array of LKCLocation objects
*/
+(void)getLocationsWithCompletion:(getLocationsCompletion)completion;
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
/*!
 @brief Use this method stop the Locations check.
 @discussion This method will stop any current locations check.
*/
+(void)stopLocationsScanning;

@end
