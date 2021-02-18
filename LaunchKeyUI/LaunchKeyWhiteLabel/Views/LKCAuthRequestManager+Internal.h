//
//  LKCAuthRequestManager+Internal.h
//  AuthenticatorDynamicFramework
//
//  Created by Steven Gerhard on 2/13/20.
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <LKCAuthenticator/LKCAuthRequestManager.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import <LKCAuthenticator/LKCAuthRequestDetails.h>

// Use this interface to exposes methods on AuthRequestManager that we want to hide from implementors
@interface LKCAuthRequestManager()

-(void)denyFromAuthFailure:(AuthResponseReason)reason withCompletion:(denyAuthCompletion)completion;
-(void)postAuthenticationForAuthenticated:(BOOL)authenticated type:(AuthResponseType)type reason:(AuthResponseReason)reason denialReason:(NSString *)denialReason withCompletion:(void (^)(NSError *error))completion;

// Support for Legacy AuthRequestManager
-(void)checkForPendingAuthRequestWithCompletion:(authRequestCompletion)completion withBlockToCallSegueForUILibrary:(void (^)(void))doUISeque;
-(NSString *)getAuthRequestTitle;
-(NSString *)getAuthRequestContext;
-(int)getCreatedAtInMilliseconds;
-(int)getExpiresAtInMilliseconds;
-(LKCAuthRequestDetails*)getAuthRequestDetailsForCurrentRequest;
-(int)getNumberRequiredAuthMethodsForCurrentRequest;
-(NSArray*)getRequiredAuthMethodArrayForCurrentRequest;
-(BOOL)isCurrentRequestQuickfail;
-(NSString*)getCurrentRequestQuickFailReason;

@end
