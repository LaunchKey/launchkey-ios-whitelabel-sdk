//
//  AuthRequestManager.m
//  WhiteLabel
//
//  Created by ani on 6/13/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "AuthRequestManager.h"
#import "LKCAuthRequestManager+Internal.h"
#import "LKUIConstants.h"
#import "AuthenticatorManager.h"
#import "AuthResponseInitialViewController.h"
#import "AuthResponseFailureViewController.h"
#import "LaunchKeyUIBundle.h"
#import <LKCAuthenticator/LKCErrorCode.h>
#import <LKCAuthenticator/LKCAuthRequestDetails.h>

@interface AuthRequestManager () <AuthResponseInitialViewControllerDelegate, AuthResponseFailureViewControllerDelegate>

@end

@implementation AuthRequestManager

+(AuthRequestManager *)sharedManager
{
    static AuthRequestManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AuthRequestManager alloc] init];
    });
    return _sharedClient;
}

-(instancetype)init {
    if (self = [super init]) {
        // init any instance variables in here
    }
    return self;
}

-(void)checkForPendingAuthRequest:(UINavigationController *)parentNavigationController withCompletion:(authRequestCompletion)completion {
    [[LKCAuthRequestManager sharedManager] checkForPendingAuthRequestWithCompletion:completion withBlockToCallSegueForUILibrary:^(void) {
        NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Authenticator" bundle:bundle];
        AuthResponseInitialViewController *authRequestView = [sb instantiateViewControllerWithIdentifier:@"AuthResponseInitialViewController"];
        
        LKCAuthRequestDetails *authRequestDetails = [[LKCAuthRequestManager sharedManager] getAuthRequestDetailsForCurrentRequest];
        int numberRequiredMethods = [[LKCAuthRequestManager sharedManager] getNumberRequiredAuthMethodsForCurrentRequest];
        NSArray *requiredMethods = [[LKCAuthRequestManager sharedManager] getRequiredAuthMethodArrayForCurrentRequest];
        BOOL isQuickFail = [[LKCAuthRequestManager sharedManager] isCurrentRequestQuickfail];
        NSString *quickFailReason = [[LKCAuthRequestManager sharedManager] getCurrentRequestQuickFailReason];
        [authRequestView displayAuthResponseWithAuthRequestDetails:authRequestDetails withRequiredAuthMethodArray:requiredMethods withNumOfMethods:numberRequiredMethods withQuickFail:isQuickFail withQuickFailReason:quickFailReason];
        authRequestView.hidesBottomBarWhenPushed = YES;
        authRequestView.authResponseInitialDelegate = self;
        [parentNavigationController pushViewController:authRequestView animated:NO];
    }];
}

#pragma mark - Request Response (DELEGATE METHOD)
-(void)respondToRequest:(AuthResponseInitialViewController *)controller authenticated:(BOOL)authenticated type:(AuthResponseType)type reason:(AuthResponseReason)reason denialReason:(NSString *)denialReason withCompletion:(authResponseComplete)completion {
    return [[LKCAuthRequestManager sharedManager] postAuthenticationForAuthenticated:authenticated type:type reason:reason denialReason:denialReason withCompletion:completion];
}

#pragma mark - Public Getter Methods
-(NSString *)getAuthRequestTitle {
    return [[LKCAuthRequestManager sharedManager] getAuthRequestTitle];
}

-(NSString *)getAuthRequestContext {
    return [[LKCAuthRequestManager sharedManager] getAuthRequestContext];
}

-(int)getCreatedAtInMilliseconds {
    return [[LKCAuthRequestManager sharedManager] getCreatedAtInMilliseconds];
}

-(int)getExpiresAtInMilliseconds {
    return [[LKCAuthRequestManager sharedManager] getExpiresAtInMilliseconds];
}

@end
