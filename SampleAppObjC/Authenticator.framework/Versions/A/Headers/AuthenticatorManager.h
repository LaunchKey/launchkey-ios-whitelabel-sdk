//
//  AuthenticatorManager.h
//
//  Copyright (c) 2019 iovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOADevice.h"
#import "AuthenticatorConfig.h"

@class UIViewController;
@import UIKit;

static const int keypair_minimum = 2048;
static const int keypair_medium = 3072;
static const int keypair_maximum = 4096;

static const int activationDelayMin = 0;
static const int activationDelayDefault = 600;
static const int activationDelayMax = 86400;

static const int thresholdAuthFailureMin = 1;
static const int thresholdAuthFailureDefault = 5;
static const int thresholdAuthFailureMax = 10;

static const int thresholdAutoUnlinkMin = 2;
static const int thresholdAutoUnlinkDefault = 10;
static const int thresholdAutoUnlinkMax = 10;

static const int thresholdWarningUnlinkMin = 0;

typedef void (^linkedBlock)(void);
typedef void (^unlinkedBlock)(void);
typedef void (^failureBlock)(NSString *errorMessage, NSString *errorCode);
typedef void (^errorBlock)(NSError *error);
typedef void (^completion)(NSError *error);

extern NSString *const deviceUnlinked;
extern NSString *const requestReceived;

@interface AuthenticatorManager : NSObject

@property (nonatomic, copy) unlinkedBlock thisUnLinked;
@property (nonatomic, copy) failureBlock thisFailure;

+(AuthenticatorManager*)sharedClient;

#pragma mark - Initialization
-(void)initSDK:(NSString*)sdkKey __attribute((deprecated("Please use `-(void)initializeSDK:(AuthConfig*)config withSDKKey:(NSString*)key` instead")));

/*!
 @brief Use this method to initialize the Authenticator SDK
 @discussion This method accepts an AuthenticatorConfig object that you build with your Authenticator SDK Key, along with other
 builder properties you desire for the app.
 @param  config The input value representing the Authenticator SDK Key as well as some advanced integration options and color configurations.
*/
-(void)initialize:(AuthenticatorConfig*)config;
-(AuthenticatorConfig*)getAuthenticatorConfigInstance;

#pragma mark - Linking
/*!
 @brief Use this method if you want to use a custom view to link a user
 @discussion This method accepts the QR code, device name, and boolean representing if the device name can be overwritten. The completion block will
 be empty if linking is successful, otherwise there will be an NSError object returned.
 @param  qrCode The input value representing the QR Code (a 7 character string).
 @param  deviceName The input value representing the name of the device (if nil, the Authenticator SDK will use the OS level device name).
 @param  deviceNameOverride BOOL value representing if the device name should be overwritten if it already exists in our API.
 @param  completion The completion block of this method. If there is an error, an NSError object will be returned, otherwise it will be nil.
 */
-(void)linkUser:(NSString *)qrCode withDeviceName:(NSString *)deviceName deviceNameOverride:(BOOL)deviceNameOverride withCompletion:(completion)completion;

#pragma mark - Displaying Views
-(void)showSecurityViewWithNavController:(UINavigationController*)parentNavigationController withUnLinked:(unlinkedBlock)unlinked __attribute((deprecated("Please use `-(void)showSecurityViewWithNavController:(UINavigationController*)parentNavigationController` instead")));
/*!
 @brief Use this method to push the Security View Controller on to the stack in your mobile application
 @discussion This method accepts a UINavigationController in order to push the Security View Controller on to the stack. The Security View Controller
 is the View Controller where users can add and remove auth methods.
 @param  parentNavigationController The current Navigation Controller where you want the Security View Controller to be pushed on to.
 */
-(void)showSecurityViewWithNavController:(UINavigationController*)parentNavigationController;

-(void)showLinkingView:(UINavigationController*)parentNavigationController withCamera:(BOOL)camera withLinked:(linkedBlock)linked withFailure:(failureBlock)failure __attribute((deprecated("Please use `-(void)showLinkingView:(UINavigationController*)parentNavigationController withCamera:(BOOL)camera withCompletion:(completion)completion;")));
/*!
 @brief Use this method to push the Default Linking View Controller on to the stack in your mobile application
 @discussion This method accepts a UINavigationController in order to push the default Linking View Controller on to the stack.
 @param  parentNavigationController The current Navigation Controller where you want the default Linking View Controller to be pushed on to.
 @param  camera BOOL value representing if QR code scanning should ne enabled (YES) or if the ability to manually enter the linking code should be enabled (NO).
 @param  completion The completion block of this method. If there is an error, an NSError object will be returned, otherwise it will be nil.
 */
-(void)showLinkingView:(UINavigationController*)parentNavigationController withCamera:(BOOL)camera withCompletion:(completion)completion;

#pragma mark - Unlinking
/*!
 @brief Use this method to unlink a device
 @discussion This method accepts an IOADevice object to unlink (if nil, the current device will be unlinked)
 @param  device IOADevice object to be unlinked (pass nil to unlink the current device).
 @param  completion The completion block of this method. If there is an error, an NSError object will be returned, otherwise it will be nil.
 */
-(void)unlinkDevice:(IOADevice*)device withCompletion:(completion)completion;

#pragma mark - Metrics
/*!
 @brief Use this method to manually send the metrics queue to the API (if any are in the queue)
 @discussion This method sends the current queue of metrics stored in the Auth SDK (if any are in the queue).
 @param  completion The completion block of this method. If there is an error, an NSError object will be returned, otherwise it will be nil.
 */
-(void)sendMetricsWithCompletion:(completion)completion;

#pragma mark - Push Notifications
/*!
 @brief Use this method to register the device token with the Authenticator SDK
 @discussion This method accepts the device token given by the didRegisterForRemoteNotificationsWithDeviceToken function in the
 AppDelegate callback.
 @param  deviceToken The input value representing globally unique token that identifies the device to APNs.
 */
-(void)setNotificationToken:(NSData *)deviceToken;
/*!
 @brief Use this method to pass the encrypted payload given in the push package for the Authenticaor SDK to decrypt
 @discussion This method accepts the userinfo dictionary given by the didReceiveRemoteNotification function in the AppDelegate callback.
 @param  userInfo The input value representing the dictionary that contains information related to the remote notification.
 */
-(void)handleRemoteNotification:(NSDictionary*)userInfo;
/*!
 @brief Use this method to pass the push package string for the Authenticator SDK to handle
 @discussion This method accepts the push package string.
 @param  userInfo The input value representing the dictionary that contains information related to the remote notification.
 */
-(void)handlePushPackage:(NSString*)pushPackage;

#pragma mark - Miscellaneous Methods
/*!
 @brief Use this method to determine if the device has been successfully linked
 @discussion This method returns whether the device is linked or unlinked.
 @return BOOL The boolean value representing if the device is linked or unlinked.
 */
-(BOOL)isAccountActive;
/*!
 @brief Use this method to determine which auth methods are set and active, and what type each auth method is
 @discussion This method returns an NSArray that includes every auth method, the type each auth method is, and if the auth method is active or inactive.
 @return NSArray The NSArray that includes all the information relative to auth methods on the device.
 */
-(NSArray*)getSecurityInfo;
/*!
 @brief Use this method to know what Third Party Libraries are inlcuded within the Authenticator SDK
 @discussion This method returns an NSArray that lists out all Third Party Libraries included within the Authenticator SDK (name, version, license, and url).
 @return NSArray The NSArray that inclides all the information relative to Third Party Libraries inlcuded within the Authenticator SDK.
 */
-(NSArray*)getThirdPartyLibraryInfo;

@end
