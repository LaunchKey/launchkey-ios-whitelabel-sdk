//
//  AuthenticatorManager.h
//  iOS_SDK_Test_App
//
//  Created by Kristin Tomasik on 7/3/14.
//  Copyright (c) 2014 LaunchKey. All rights reserved.
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

//Init
-(void)initSDK:(NSString*)sdkKey __attribute((deprecated("Please use `-(void)initializeSDK:(AuthConfig*)config withSDKKey:(NSString*)key` instead")));
-(void)initialize:(AuthenticatorConfig*)config;
-(AuthenticatorConfig*)getAuthenticatorConfigInstance;

//Link
-(void)setNotificationToken:(NSData *)deviceToken;
-(void)linkUser:(NSString *)qrCode withDeviceName:(NSString *)deviceName deviceNameOverride:(BOOL)deviceNameOverride withCompletion:(completion)completion;

//Display Views
-(void)showSecurityViewWithNavController:(UINavigationController*)parentNavigationController withUnLinked:(unlinkedBlock)unlinked;
-(void)showLinkingView:(UINavigationController*)parentNavigationController withCamera:(BOOL)camera withLinked:(linkedBlock)linked withFailure:(failureBlock)failure;

//Unlink
-(void)unlinkDevice:(IOADevice*)device withCompletion:(completion)completion;

//Metrics
-(void)sendMetricsWithCompletion:(completion)completion;

//Misc
-(BOOL)isAccountActive;
-(NSArray*)getSecurityInfo;
-(void)handleRemoteNotification:(NSDictionary*)userInfo;
-(void)handlePushPackage:(NSString*)pushPackage;
-(NSArray*)getThirdPartyLibraryInfo;

@end
