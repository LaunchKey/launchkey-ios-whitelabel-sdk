//
//  LKCAuthRequestManager.h
//  WhiteLabel
//
//  Created by ani on 6/13/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCAuthRequestTypeDefinitions.h"
#import "LKCAuthRequestDetails.h"

typedef void (^authRequestCompletion)(NSString *requestMessage, NSError *error);

extern NSString *const requestApproved;
extern NSString *const requestDenied;

@interface LKCAuthRequestManager : NSObject

+(LKCAuthRequestManager*)sharedManager;

/*!
@brief Use this method to check for any pending Auth Requests
@discussion If there is an active auth request, LKAuthRequestDetails will be returned with details of the active request.
@param  completion The completion block called when this Async method is done executing.
 If there is an active auth request LKAuthRequestDetails object is returned otherwise NSError object.
*/
-(void)checkAuthRequestWithCompletion:(checkForPendingAuthRequestCompletion)completion;

/*!
@brief Use this get the details of the active pending auth request.
@discussion If there is an active auth request, LKAuthRequestDetails will be returned with details of the active request. Needs to be called after checkAuthRequestWithCompletion for an auth request to be pending.
@return Returns an object containing the details of the active auth request. Returns nil if there is no active request.
*/
-(LKCAuthRequestDetails*)getPendingAuthRequest;

/*!
@brief Use this get the required methods to verify on an active auth request. Should be called after checkAuthRequestWithCompletion and acceptAndSendIfFailed.
@discussion There needs to be a pending auth request, as well as an accept called on it for there to be any possible methodsToVerify.
@return Returns an array containing enums describing the methods that need to be verified. Otherwise returns nil.
*/
-(NSArray*)getMethodsToVerify;

/*!
@brief Use this method to approve a pending auth request. Must be called after checkAuthRequestWithCompletion.
@discussion If there is an active auth request, use this method to approve it. If there is a processing failure or configured policy quickfail, the request will be auto sent and the function will return YES as a BOOL.
@return Returns true or YES if the request failed and will be auto sent
*/
-(BOOL)acceptAndSendIfFailed;

/*!
@brief Use this method to deny a pending auth request. Must be called after checkForPendingAuthRequest.
@discussion If there is an active auth request, use this method to deny it.
@param  denialReasonID If LKAuthRequestDetails object returned from checkForPendingAuthRequestWithCompletion contains
 an array of denial reasons, you must respond with one of the denial reason ids to successfully deny the active request. If no denial reasons were given, pass in nil.
@param  completion The completion block called when this Async method is done executing. If an error occured, NSError object is returned.
*/
-(void)denyAndSendWithReasonID:(NSString*)denialReasonID WithCompletion:(denyAuthCompletion)completion;

/*!
@brief Use this method to send and complete an approved auth request that has no more methodsToVerify.
@discussion The expected flow for an approved auth request is checkAuthRequestWithCompletion -> acceptAndSendIfFailed -> getMethodsToVerify -> sendWithCompletion
@param  completion The completion block called when this Async method is done executing. If an error occured, NSError object is returned.
*/
-(void)sendWithCompletion:(sendAuthCompletion)completion;

@end
 
