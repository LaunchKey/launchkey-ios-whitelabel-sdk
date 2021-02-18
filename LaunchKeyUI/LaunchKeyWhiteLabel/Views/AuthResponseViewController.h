//
//  AuthResponseViewController.h
//  Authenticator
//
//  Created by ani on 11/14/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKCAuthenticator/LKCAuthRequestDetails.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>
#import "AuthResponseInitialViewController.h"

@class AuthResponseViewController;

@protocol AuthResponseViewControllerDelegate <NSObject>

-(void)respondToRequest:(AuthResponseViewController *)controller authenticated:(BOOL)authenticated type:(AuthResponseType)type reason:(AuthResponseReason)reason denialReason:(NSString*)denialReason withCompletion:(authResponseComplete)completion;

@end

@interface AuthResponseViewController : UIViewController

@property (nonatomic, weak) id <AuthResponseViewControllerDelegate> authResponseDelegate;
@property (nonatomic, strong) NSArray *authMethods;
@property (nonatomic, strong) LKCAuthRequestDetails *request;
@property BOOL checkPIN, checkCircle, checkWearable, checkGeo, checkLocations, checkFingerprint;
@property int numberOfMethods;
@property int viewCalledFrom;

@end
