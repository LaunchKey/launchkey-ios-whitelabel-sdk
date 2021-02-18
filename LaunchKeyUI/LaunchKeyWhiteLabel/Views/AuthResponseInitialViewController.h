//
//  AuthResponseInitialViewController.h
//  Authenticator
//
//  Created by ani on 11/14/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKCAuthenticator/LKCAuthRequestDetails.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>

typedef void (^authResponseComplete)(NSError *error);

@class AuthResponseInitialViewController;

@protocol AuthResponseInitialViewControllerDelegate <NSObject>

-(void)respondToRequest:(AuthResponseInitialViewController *)controller authenticated:(BOOL)authenticated type:(AuthResponseType)type reason:(AuthResponseReason)reason denialReason:(NSString*)denialReason withCompletion:(authResponseComplete)completion;

@end

@interface AuthResponseInitialViewController : UIViewController

@property (nonatomic, weak) id <AuthResponseInitialViewControllerDelegate> authResponseInitialDelegate;

-(void)displayAuthResponseWithAuthRequestDetails:(LKCAuthRequestDetails*)authRequestDetails withRequiredAuthMethodArray:(NSArray*)authMethodsArray withNumOfMethods:(int)num withQuickFail:(BOOL)quickFail withQuickFailReason:(NSString*)quickFailReaseon;

@end
