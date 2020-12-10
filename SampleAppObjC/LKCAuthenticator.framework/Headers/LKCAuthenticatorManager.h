//
//  LKCAuthenticatorManager.h
//
//  Copyright © 2020 TransUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCDevice.h"
#import "LKCSession.h"
#import "LKCAuthenticatorConfig.h"

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

typedef void (^completion)(NSError *error);
typedef void (^endLKCSessionCompletion)(NSError *error);
typedef void (^getLKCSessionsCompletion)(NSArray<LKCSession*> *array, NSError *error);
typedef void (^getDevicesCompletionLKC)(NSArray<LKCDevice*> *array, NSError *error);

extern NSString *const deviceUnlinked;
extern NSString *const requestReceived;

@interface LKCAuthenticatorManager : NSObject

+(LKCAuthenticatorManager*)sharedClient;

/*!
 @brief Use this method to initialize the Authenticator SDK
 @discussion This method accepts an AuthenticatorConfig object that you build with your Authenticator SDK Key, along with other
 builder properties you desire for the app.
 @param  config The input value representing the Authenticator SDK Key as well as some advanced integration options and color configurations.
*/
-(void)initialize:(LKCAuthenticatorConfig*)config;
-(LKCAuthenticatorConfig*)getAuthenticatorConfigInstance;

#pragma mark - Linking
/*!
 @brief Use this method if you want to use a custom view to link a user
 @discussion This method accepts the QR code, device name, and boolean representing if the device name can be overwritten. The completion block will
 be empty if linking is successful, otherwise there will be an NSError object returned.
 @param  qrCode The input value representing the QR Code (a 7 character string).
 @param  sdkKey The input value representing the Mobile Authenticator Key.
 @param  deviceName The input value representing the name of the device (if nil, the Authenticator SDK will use the OS level device name).
 @param  deviceNameOverride BOOL value representing if the device name should be overwritten if it already exists in our API.
 @param  completion The completion block of this method. If there is an error, an NSError object will be returned, otherwise it will be nil.
 */
-(void)linkDevice:(NSString *)qrCode withSDKKey:(NSString*)sdkKey withDeviceName:(NSString *)deviceName deviceNameOverride:(BOOL)deviceNameOverride withCompletion:(completion)completion;

#pragma mark - Devices
/*!
 @brief Use this method to retrieve the list of currently linked devices
 @discussion This method will return an NSArray in the getDevicesCompletion block that represents the list of LKCDevice Objects which are the currently linked devices.
 @param block The getDevicesCompletion block that will return an NSArray in the getDevicesCompletion block that represents the list of LKCDevice Objects which are currently linked devices. If there is an error retrieving the list, an NSError object will be returned.
 */
-(void)getDevices:(getDevicesCompletionLKC)block;
/*!
 @brief Use this method to retrieve the current device
 @discussion This method will return the LKCDevice object representing the current device.
 @return LKCDevice The current LKCDevice object representing the current device.
 */
-(LKCDevice*)currentDevice;
/*!
 @brief Use this method to unlink a device
 @discussion This method accepts an LKCDevice object to unlink (if nil, the current device will be unlinked)
 @param  device LKCDevice object to be unlinked (pass nil to unlink the current device).
 @param  completion The completion block of this method. If there is an error, an NSError object will be returned, otherwise it will be nil.
 */
-(void)unlinkDevice:(LKCDevice*)device withCompletion:(completion)completion;

#pragma mark - Sessions
/*!
 @brief Use this method to retrieve the list of active sessions
 @discussion This method will return an NSArray in the getSessionsCompletion block that represents the list of IOASessions Objects which are the active sessions.
 @param block The getSessionsCompletion block that will return an NSArray in the getSessionsCompletion block that represents the list of IOASessions which are active sessions. If there is an error retrieving the list, an NSError object will be returned. Completion passed in will always be executed.
 */
-(void)getSessions:(getLKCSessionsCompletion)block;
/*!
 @brief Use this method to end a single session.
 @discussion This method will end the passed in session.
 @param session The session to end
 @param  completion The completion block of this method. Completion passed in will always be executed.
 */
-(void)endSession:(LKCSession*)session completion:(endLKCSessionCompletion)completion;
/*!
 @brief Use this method to end all active sessions
 @discussion This method will end all active sessions.
 @param  completion The completion block of this method. Completion passed in will always be executed.
 */
-(void)endAllSessions:(endLKCSessionCompletion)completion;

#pragma mark - Push Notifications
/*!
 @brief Use this method to register the device token with the Authenticator SDK
 @discussion This method accepts the device token given by the didRegisterForRemoteNotificationsWithDeviceToken function in the
 AppDelegate callback.
 @param  deviceToken The input value representing globally unique token that identifies the device to APNs.
 */
-(void)setPushDeviceToken:(NSData *)deviceToken;
/*!
 @brief Use this method to pass the encrypted payload given in the push package for the Authenticaor SDK to decrypt
 @discussion This method accepts the userinfo dictionary given by the didReceiveRemoteNotification function in the AppDelegate callback.
 @param  userInfo The input value representing the dictionary that contains information related to the remote notification.
 */
-(void)handlePushPayload:(NSDictionary*)userInfo;
/*!
 @brief Use this method to pass the push package string for the Authenticator SDK to handle
 @discussion This method accepts the push package string.
 @param  pushPackage The input value representing the dictionary that contains information related to the remote notification.
 */
-(void)handleThirdPartyPushPackage:(NSString*)pushPackage;

#pragma mark - Miscellaneous Methods
/*!
 @brief Use this method to determine if the device has been successfully linked
 @discussion This method returns whether the device is linked or unlinked.
 @return BOOL The boolean value representing if the device is linked or unlinked.
 */
-(BOOL)isDeviceLinked;

@end
