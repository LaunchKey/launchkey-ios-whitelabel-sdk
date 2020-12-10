//
//  LKCAuthRequestTypeDefinitions.h
//  AuthenticatorDynamicFramework
//
//  Created by Steven Gerhard on 2/11/20.
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCAuthRequestDetails.h"

typedef void (^sendAuthCompletion)(NSError *error);

typedef void (^denyAuthCompletion)(NSError *error);

typedef void (^checkForPendingAuthRequestCompletion)(LKCAuthRequestDetails *requestDetails, NSError *error);

typedef enum {
    
    PINCODE = 1,
    CIRCLECODE = 2,
    GEOFENCING = 3,
    WEARABLES = 4,
    FINGERPRINTSCAN = 5,
    FACESCAN = 6,
    LOCATIONS = 7,
    
} AuthMethodType;

typedef enum {
    
    APPROVED,
    DISAPPROVED,
    FRAUDULENT,
    POLICY,
    PERMISSION,
    AUTHENTICATION,
    CONFIGURATION,
    BUSY_LOCAL,
    SENSOR,
    
} AuthResponseReason;

typedef enum {
    
    AUTHORIZED,
    DENIED,
    FAILED,
    
} AuthResponseType;

