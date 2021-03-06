//
//  LKErrorCode.h
//  AuthenticatorDynamicFramework
//
//  Created by Steven Gerhard on 1/27/20.
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BaseError = -1,
    AuthRequestDoesNotMatchError,
    MethodNotSetError,
    MethodAlreadySetError,
    CircleCodeTooLongError,
    CircleCodeTooShortError,
    CircleCodeWrongError,
    CircleCodeWrongFailureError,
    CircleCodeWrongFailureUnlinkError ,
    CircleCodeWrongFailureUnlinkWarningError,
    PINCodeTooLongError,
    PINCodeTooShortError,
    PINCodeWrongError,
    PINCodeWrongFailureError,
    PINCodeWrongFailureUnlinkError,
    PINCodeWrongFailureUnlinkWarningError,
    FaceScanError,
    FaceScanWrongError,
    FaceScanWrongFailureUnlinkError,
    FaceScanWrongFailureUnlinkWarningError,
    FingerprintScanError,
    FingerprintScanWrongError,
    FingerprintScanWrongFailureUnlinkError,
    FingerprintScanWrongFailureUnlinkWarningError,
    GeofenceCheckError,
    LocationAlreadyAddedError,
    LocationNameTooShortError,
    LocationError,
    LocationInvalidError,
    LocationFailureUnlinkError,
    LocationFailureUnlinkWarningError,
    WearableAlreadyAddedError,
    WearableNameTooShortError,
    WearableDoesNotMatchConnectedError,
    WearableError,
    WearableInvalidError,
    WearableFailureUnlinkError,
    WearableFailureUnlinkWarningError,
    MalformedJwtError = 101,
    UnsupportedJweRequirementsError = 102,
    ExpiredAuthRequestError = 103,
    UnexpectedPolicyTypeError = 104,
    MalformedLinkingCodeError = 105,
    DeviceNotLinkedError = 106,
    NetworkRequestCancelledOrSSLError = 107,
    RequestArguementError = 108,
    AuthRequestCanceled = 109,
    NoInternetConnectivityError = 110,
    ApiError = 111,
    DeviceAlreadyLinkedError = 112,
    BadDenialReasonID = 113,
    NoPendingAuthRequest = 114,
    AuthRequestAleadyRespondedToError = 115,
} LKCErrorCode;
