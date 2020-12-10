//
//  LKCGeofenceManager.h
//  LKCAuthenticator
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCAuthenticatorManager.h"
#import "LKCAuthRequestDetails.h"

@interface LKCGeofenceManager : NSObject

typedef void (^geofencesCheckCompletion)(BOOL sucess, NSError *error);

/*!
 @brief Use this method to verify Geofences.
 @discussion This method checks the Geofences attached to a policy during an Auth Request.
 @param completion The completion block that will return success as true if Geofences check was valid. Otherwise, success will be false and an error will be returned.
*/
+(void)verifyGeofencesForAuthRequest:(LKCAuthRequestDetails*)request withCompletion:(geofencesCheckCompletion)completion;
/*!
 @brief Use this method stop the Geofences check.
 @discussion This method will stop any current Geofences check.
*/
+(void)stopGeofencesScanning;

@end
