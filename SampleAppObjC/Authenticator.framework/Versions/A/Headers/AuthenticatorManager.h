//
//  WhiteLabelManager.h
//  iOS_SDK_Test_App
//
//  Created by Kristin Tomasik on 7/3/14.
//  Copyright (c) 2014 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOADevice.h"

@class UIViewController;
@import UIKit;

typedef void (^registerSuccessBlock)();
typedef void (^successBlock)();
typedef void (^completionBlock) (BOOL activeSession);
typedef void (^linkedBlock)();
typedef void (^unlinkedBlock)();
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
-(void)initSDK:(NSString*)sdkKey;

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
