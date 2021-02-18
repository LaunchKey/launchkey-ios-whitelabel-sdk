//
//  WhiteLabelManager.m
//  iOS_SDK_Test_App
//
//  Created by Kristin Tomasik on 7/3/14.
//  Copyright (c) 2014 LaunchKey. All rights reserved.
//

#import "AuthenticatorManager.h"
#import "LKUIConstants.h"
#import "PairQRViewController.h"
#import "SecurityViewController.h"
#import <LKCAuthenticator/LKCPINCodeManager.h>
#import <LKCAuthenticator/LKCCircleCodeManager.h>
#import "LaunchKeyUIBundle.h"
#import <LKCAuthenticator/LKCErrorCode.h>
#import <LKCAuthenticator/LKCAuthenticatorManager.h>

#define kTwentyFourHours 24*60*60

@interface AuthenticatorManager()
@property(weak,nonatomic) UINavigationController *launcherParentNavViewController;
@end

@implementation AuthenticatorManager {
    
    completion _pairingSuccess;
    AuthenticatorConfig *configObject;
}

static NSString * const kBundle = @"Authenticator.bundle";
NSString *const deviceUnlinked = @"deviceUnlinked";
NSString *const requestReceived = @"requestReceived";

+(AuthenticatorManager *)sharedClient
{
    static AuthenticatorManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AuthenticatorManager alloc] init];
    });
    
    return _sharedClient;
}

#pragma mark - Initialize
-(void)initialize:(AuthenticatorConfig *)config {
    
    configObject = [[AuthenticatorConfig alloc] init];
    configObject = config;
    
    LKCAuthenticatorConfig *lkcConfig = [LKCAuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(LKCAuthenticatorConfigBuilder *builder) {
        builder.SSLPinningEnabled = configObject.SSLPinningEnabled;
        builder.keyPairSize = configObject.keyPairSize;
        builder.activationDelayWearable = configObject.activationDelayWearable;
        builder.activationDelayLocation = configObject.activationDelayLocation;
        builder.thresholdAuthFailure = configObject.thresholdAuthFailure;
        builder.thresholdAutoUnlink = configObject.thresholdAutoUnlink;
        builder.thresholdAutoUnlinkWarning = configObject.thresholdAutoUnlinkWarning;
        builder.enableSecurityChangesWhenUnlinked = configObject.enableSecurityChangesWhenUnlinked;
        builder.enablePINCode = configObject.enablePINCode;
        builder.enableCircleCode = configObject.enableCircleCode;
        builder.enableLocations = configObject.enableLocations;
        builder.enableWearable = configObject.enableWearable;
        builder.enableFingerprint = configObject.enableFingerprint;
        builder.enableFace = configObject.enableFace;
    }];
    [[LKCAuthenticatorManager sharedClient] initialize:lkcConfig];
    
    // Add Observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(devicePaired) name:kLKLaunchKeyDevicePaired object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeQRLaunchView) name:kLKLaunchKeyCloseQRView object:nil];
}

-(AuthenticatorConfig*)getAuthenticatorConfigInstance
{
    AuthenticatorConfig *config = [[AuthenticatorConfig alloc] init];
    if(configObject != nil)
    {
        config = [AuthenticatorConfig makeWithAuthenticatorConfigBuilder:^(AuthenticatorConfigBuilder *builder) {
            builder.SSLPinningEnabled = configObject.SSLPinningEnabled;
            builder.keyPairSize = configObject.keyPairSize;
            builder.activationDelayWearable = configObject.activationDelayWearable;
            builder.activationDelayLocation = configObject.activationDelayLocation;
            builder.thresholdAuthFailure = configObject.thresholdAuthFailure;
            builder.thresholdAutoUnlink = configObject.thresholdAutoUnlink;
            builder.thresholdAutoUnlinkWarning = configObject.thresholdAutoUnlinkWarning;
            builder.customFont = configObject.customFont;
            builder.enableInfoButtons = configObject.enableInfoButtons;
            builder.enableHeaderViews = configObject.enableHeaderViews;
            builder.enableSecurityFactorImages = configObject.enableSecurityFactorImages;
            builder.enableNotificationPrompt = configObject.enableNotificationPrompt;
            builder.enableViewControllerTransitionAnimation = configObject.enableViewControllerTransitionAnimation;
            builder.enableBackBarButtonItem = configObject.enableBackBarButtonItem;
            builder.enableSecurityChangesWhenUnlinked = configObject.enableSecurityChangesWhenUnlinked;
            builder.enablePINCode = configObject.enablePINCode;
            builder.enableCircleCode = configObject.enableCircleCode;
            builder.enableLocations = configObject.enableLocations;
            builder.enableWearable = configObject.enableWearable;
            builder.enableFingerprint = configObject.enableFingerprint;
            builder.enableFace = configObject.enableFace;
            builder.controlsBackgroundColor = configObject.controlsBackgroundColor;
            builder.tableViewHeaderBackgroundColor = configObject.tableViewHeaderBackgroundColor;;
            builder.tableViewHeaderTextColor = configObject.tableViewHeaderTextColor;
            builder.securityViewsTextColor = configObject.securityViewsTextColor;
            builder.geofenceCircleColor = configObject.geofenceCircleColor;
            builder.securityFactorImageTintColor = configObject.securityFactorImageTintColor;
            builder.authContentViewBackgroundColor = configObject.authContentViewBackgroundColor;
            builder.authTextColor = configObject.authTextColor;
            builder.authResponseAuthorizedColor = configObject.authResponseAuthorizedColor;
            builder.authResponseDeniedColor = configObject.authResponseDeniedColor;
            builder.authResponseFailedColor = configObject.authResponseFailedColor;
            builder.authResponseDenialReasonUnselectedColor = configObject.authResponseDenialReasonUnselectedColor;
            builder.authResponseDenialReasonSelectedColor = configObject.authResponseDenialReasonSelectedColor;
        }];
    }
    return config;
}

#pragma mark - Show Linking View
-(void)showLinkingView:(UINavigationController*)parentNavigationController withSDKKey:(NSString*)sdkKey withCamera:(BOOL)camera withCompletion:(completion)completion {
    if([[LKCAuthenticatorManager sharedClient] isDeviceLinked])
    {
        [self showAlertViewWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_Warning", @"Localizable", [NSBundle LaunchKeyUIBundle], nil) withMessage:NSLocalizedStringFromTableInBundle(@"Account_Already_Registered", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _pairingSuccess = completion;
        NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
        PairQRViewController *linkingVC = [[PairQRViewController alloc] initWithNibName:@"PairQRViewController" bundle:bundle];
        [linkingVC displayLinkingViewWithCamera:camera withSDKKey:sdkKey];
        self.launcherParentNavViewController = parentNavigationController;
        [self pushViewController:linkingVC fromNavController:self.launcherParentNavViewController];
    });
}

#pragma mark - Show Security View
-(void)showSecurityViewWithNavController:(UINavigationController *)parentNavigationController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.launcherParentNavViewController = parentNavigationController;
        
        NSBundle *bundle = [NSBundle LaunchKeyUIBundle];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Authenticator" bundle:bundle];
        SecurityViewController *securityView = [sb instantiateViewControllerWithIdentifier:@"SecurityViewController"];
        
        // Adding this configutation to allow for more customization for implementers
        securityView.navigationItem.hidesBackButton = ![self getAuthenticatorConfigInstance].enableBackBarButtonItem;
        
        [self pushViewController:securityView fromNavController:self.launcherParentNavViewController];
    });
}

#pragma mark - Push Animation
- (void)pushViewController:(UIViewController*)pushedViewController fromNavController:(UINavigationController*)navController
{    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    // Adding this configutation to allow for more customization for implementers
    if([self getAuthenticatorConfigInstance].enableViewControllerTransitionAnimation)
        [navController.view.layer addAnimation:transition forKey:kCATransition];
    
    [navController pushViewController:pushedViewController animated:NO];
}

#pragma mark - Show Alert
-(void)showAlertViewWithTitle:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Generic_OK", @"Localizable", [NSBundle LaunchKeyUIBundle], nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * action)
                               {
                               }];
    
    [alert addAction:okButton];
    UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(void)devicePaired {
    if(_pairingSuccess != NULL) {
        _pairingSuccess(NULL);
        _pairingSuccess = NULL;
    }
}

-(void)closeQRLaunchView
{
    [UIView animateWithDuration:.3 animations:^{
    } completion:^(BOOL finished)
    {
        [_launcherParentNavViewController popViewControllerAnimated:NO];
    }];
}
@end
