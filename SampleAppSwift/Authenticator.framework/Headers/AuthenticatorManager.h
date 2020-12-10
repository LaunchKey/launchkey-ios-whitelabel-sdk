//
//  AuthenticatorManager.h
//
//  Copyright (c) 2019 iovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthenticatorConfig.h"
#import <LKCAuthenticator/LKCDevice.h>

@class UIViewController;
@import UIKit;

typedef void (^completion)(NSError *error);

extern NSString *const deviceUnlinked;
extern NSString *const requestReceived;

@interface AuthenticatorManager : NSObject

+(AuthenticatorManager*)sharedClient;

#pragma mark - Initialization
/*!
 @brief Use this method to initialize the Authenticator SDK
 @discussion This method accepts an AuthenticatorConfig object that you build with your Authenticator SDK Key, along with other
 builder properties you desire for the app.
 @param  config The input value representing advanced integration options and color configurations.
*/
-(void)initialize:(AuthenticatorConfig*)config;
-(AuthenticatorConfig*)getAuthenticatorConfigInstance;

#pragma mark - Displaying Views
/*!
 @brief Use this method to push the Security View Controller on to the stack in your mobile application
 @discussion This method accepts a UINavigationController in order to push the Security View Controller on to the stack. The Security View Controller
 is the View Controller where users can add and remove auth methods.
 @param  parentNavigationController The current Navigation Controller where you want the Security View Controller to be pushed on to.
 */
-(void)showSecurityViewWithNavController:(UINavigationController*)parentNavigationController;

/*!
 @brief Use this method to push the Default Linking View Controller on to the stack in your mobile application
 @discussion This method accepts a UINavigationController in order to push the default Linking View Controller on to the stack.
 @param  parentNavigationController The current Navigation Controller where you want the default Linking View Controller to be pushed on to.
 @param  sdkKey The input value representing the Mobile Authenticator Key.
 @param  camera BOOL value representing if QR code scanning should ne enabled (YES) or if the ability to manually enter the linking code should be enabled (NO).
 @param  completion The completion block of this method. If there is an error, an NSError object will be returned, otherwise it will be nil.
 */
-(void)showLinkingView:(UINavigationController*)parentNavigationController withSDKKey:(NSString*)sdkKey withCamera:(BOOL)camera withCompletion:(completion)completion;

@end
