//
//  AuthResponseDenialContextViewController.h
//  Authenticator
//
//  Created by ani on 11/14/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKCAuthenticator/LKCAuthRequestDetails.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import "AuthResponseInitialViewController.h"

@class AuthResponseDenialContextViewController;

@protocol AuthResponseDenialContextViewControllerDelegate <NSObject>

-(void)respondToRequestFromDenial:(AuthResponseDenialContextViewController *)controller authenticated:(BOOL)authenticated type:(AuthResponseType)type reason:(AuthResponseReason)reason denialReason:(NSString*)denialReason withCompletion:(authResponseComplete)completion;

@end

@interface AuthResponseDenialContextViewController : UIViewController

@property (nonatomic, weak) id <AuthResponseDenialContextViewControllerDelegate> authResponseDenyDelegate;
@property (nonatomic, strong) LKCAuthRequestDetails *request;
@property int viewCalledFrom;

@end
