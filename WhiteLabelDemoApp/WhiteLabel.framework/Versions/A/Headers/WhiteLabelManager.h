//
//  WhiteLabelManager.h
//  iOS_SDK_Test_App
//
//  Created by Kristin Tomasik on 7/3/14.
//  Copyright (c) 2014 LaunchKey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

typedef void (^registerSuccessBlock)();
typedef void (^successBlock)();
typedef void (^linkedBlock)();
typedef void (^unlinkedBlock)();
typedef void (^failureBlock)(NSString *errorMessage, NSString *errorCode);

extern NSString *const activeSessionComplete;

@interface WhiteLabelManager : NSObject

@property (nonatomic, copy) registerSuccessBlock thisRegisterSuccess;
@property (nonatomic, copy) successBlock thisSuccess;
@property (nonatomic, copy) linkedBlock thisLinked;
@property (nonatomic, copy) unlinkedBlock thisUnLinked;
@property (nonatomic, copy) failureBlock thisFailure;

+(WhiteLabelManager*)sharedClient;

-(void)initSDK:(NSString*)sdkKey;

-(void)setNotificationToken:(NSData *)deviceToken;
- (void)registerUser:(NSString*)qrCode
         withSuccess:(registerSuccessBlock)success
         withFailure:(failureBlock)failure;
- (void)registerUser:(NSString*)qrCode withDevice:(NSString*)deviceName
         withSuccess:(registerSuccessBlock)success
         withFailure:(failureBlock)failure;
-(BOOL)isAccountActive;
-(void)showSecurityView:(UIViewController*)parentViewController withUnLinked:(unlinkedBlock)unlinked;
-(void)showLinkingView:(UIViewController*)parentViewController withCamera:(BOOL)camera withLinked:(linkedBlock)linked withFailure:(failureBlock)failure;
-(void)unlinkDevice:(UIViewController*)parentViewController withSuccess:(successBlock)success withFailure:(failureBlock)failure;
-(void)unlinkDevice:(UIViewController*)parentViewController withDeviceName:(NSString*)deviceName withSuccess:(successBlock)success withFailure:(failureBlock)failure;
-(void)logOut:(UIViewController*)parentViewController withSuccess:(successBlock)success withFailure:(failureBlock)failure;
-(BOOL)checkActiveSessions;
-(void)showTokensView:(UIViewController*)parentViewController withUnLinked:(unlinkedBlock)unlinked;
-(NSArray*)getSecurityInfo;

@end