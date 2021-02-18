//
//  AuthResponseFailureViewController.h
//  Authenticator
//
//  Created by ani on 12/1/18.
//  Copyright © 2018 LaunchKey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKCAuthenticator/LKCAuthRequestDetails.h>
#import <LKCAuthenticator/LKCAuthRequestTypeDefinitions.h>

@class AuthResponseFailureViewController;

@protocol AuthResponseFailureViewControllerDelegate <NSObject>

@end

@interface AuthResponseFailureViewController : UIViewController
@property (nonatomic, weak) id <AuthResponseFailureViewControllerDelegate> authResponseFailureDelegate;
@property (nonatomic, strong) LKCAuthRequestDetails *request;
@property (nonatomic, strong) NSString *failureTitle;
@property (nonatomic, strong) NSString *failureReason;
@property int numberOfMethods;
@property int viewCalledFrom;

@end
