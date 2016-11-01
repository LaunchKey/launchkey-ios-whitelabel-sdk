//
//  WhiteLabelManager.h
//  iOS_SDK_Test_App
//
//  Created by Kristin Tomasik on 7/3/14.
//  Copyright (c) 2014 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKWDevice.h"

@class UIViewController;

typedef void (^registerSuccessBlock)();
typedef void (^successBlock)();
typedef void (^completionBlock) (BOOL activeSession);
typedef void (^linkedBlock)();
typedef void (^unlinkedBlock)();
typedef void (^failureBlock)(NSString *errorMessage, NSString *errorCode);
typedef void (^errorBlock)(NSError *error);
typedef void (^completion)(NSError *error);

extern NSString *const activeSessionComplete;
extern NSString *const deviceUnlinked;
extern NSString *const requestReceived;

@interface WhiteLabelManager : NSObject

@property (nonatomic, copy) registerSuccessBlock thisRegisterSuccess;
@property (nonatomic, copy) successBlock thisSuccess;
@property (nonatomic, copy) completionBlock thisCompleted;
@property (nonatomic, copy) linkedBlock thisLinked;
@property (nonatomic, copy) unlinkedBlock thisUnLinked;
@property (nonatomic, copy) failureBlock thisFailure;
@property (nonatomic, copy) completion completionBlock;

+(WhiteLabelManager*)sharedClient;

//Init
-(void)initSDK:(NSString*)sdkKey;

//Link
-(void)setNotificationToken:(NSData *)deviceToken;
-(void)registerUser:(NSString*)qrCode
         withSuccess:(registerSuccessBlock)success
         withFailure:(failureBlock)failure __attribute((deprecated("Use -linkUser:withDeviceName:withCompletion")));
- (void)registerUser:(NSString*)qrCode withDevice:(NSString*)deviceName
         withSuccess:(registerSuccessBlock)success
         withFailure:(failureBlock)failure __attribute((deprecated("Use -linkUser:withDeviceName:withCompletion:")));
-(void)linkUser:(NSString*)qrCode
    withDeviceName:(NSString*)deviceName
    withCompletion:(completion)completion;

//Display Views
-(void)showSecurityView:(UIViewController*)parentViewController withUnLinked:(unlinkedBlock)unlinked;
-(void)showLinkingView:(UIViewController*)parentViewController withCamera:(BOOL)camera withLinked:(linkedBlock)linked withFailure:(failureBlock)failure;
-(void)showTokensView:(UIViewController*)parentViewController withUnLinked:(unlinkedBlock)unlinked;

//Log Out
-(void)logOut:(UIViewController*)parentViewController withSuccess:(successBlock)success withFailure:(failureBlock)failure __attribute((deprecated("Use -logOutWithViewController:withCompletion:")));
-(void)logOutWithViewController:(UIViewController*)parentViewController withCompletion:(completion)completion;

//Unlink
-(void)unlinkDevice:(UIViewController*)parentViewController withSuccess:(successBlock)success withFailure:(failureBlock)failure __attribute((deprecated("Use -unlinkDevice:withDevice:withCompletion:")));
-(void)unlinkDevice:(UIViewController*)parentViewController withDeviceName:(NSString*)deviceName withSuccess:(successBlock)success withFailure:(failureBlock)failure __attribute((deprecated("Use -unlinkDevice:fromController:withCompletion:")));
-(void)unlinkDevice:(LKWDevice*)device withController:(UIViewController*)parentViewController withCompletion:(completion)completion;

//Misc
-(BOOL)isAccountActive;
-(BOOL)checkActiveSessions;
-(NSArray*)getSecurityInfo;
-(void)handleRemoteNotification:(NSDictionary*)userInfo;

@end