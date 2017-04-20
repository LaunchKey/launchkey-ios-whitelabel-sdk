//
//  AppDelegate.m
//  WhiteLabelDemoApp
//
//  Created by ani on 7/8/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    
    // Set Activation Delay Times
    [[AuthenticatorConfigurator sharedConfig] setActivationDelayProximity:activationDelayDefault];
    
    [[AuthenticatorConfigurator sharedConfig] setActivationDelayGeofence:activationDelayDefault];
    
    //Include Info Button
    [[AuthenticatorConfigurator sharedConfig] enableInfo:YES];
    
    //Include Table Headers
    [[AuthenticatorConfigurator sharedConfig] enableHeaderViews:YES];
    
    //Enable Notification Prompt If Disabled
    [[AuthenticatorConfigurator sharedConfig] enableNotificationPrompt:YES];
    
    // Initialize the SDK Manager
    [[AuthenticatorManager sharedClient] initSDK:@"<mobile_sdk_key>"];
    
    
    //---------------------------------------- SET COLORS VIA APPEARANCE PROXY ----------------------------------------
    
     UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
     
     // To set bar tint color of navigation bar
     [navigationBarAppearance setBarTintColor:[UIColor colorWithRed:(0.0/255.0) green:(150.0/255.0) blue:(136.0/255.0) alpha:1.0]];
     
     // To set title text color of navigation bar
     NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
     [navigationBarAppearance setTitleTextAttributes:textAttributes];
     
     // To set appearance for normal bar button items
     NSDictionary *textAttributes2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
     [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
      setTitleTextAttributes:textAttributes2
      forState:UIControlStateNormal];
     
     // To set tint color of UISwitch
     [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:(255.0/255.0) green:(64.0/255.0) blue:(129.0/255.0) alpha:1.0]];
     
     // To set tint color of bar button items
     [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
     
     // To set tint color of Navigation Bar
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     
     // To set text color labels contained in table views
     [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setTextColor:[UIColor blackColor]];
     
     // Set UIAppearance colors for PIN Code
     [[PinCodeButton appearance] setTitleColor:[UIColor colorWithRed:(61.0/255.0) green:(188.0/255.0) blue:(212.0/255.0) alpha:1.0] forState:UIControlStateNormal];
     [PinCodeButton appearance].highlihgtedStateColor = [UIColor whiteColor];
     [PinCodeButton appearance].backgroundColor = [UIColor colorWithRed:(245.0/255.0) green:(245.0/255.0) blue:(245.0/255.0) alpha:1.0];
     [[PinCodeButton appearance] setPinCodeButtonAsCircle:YES];
     
     // Set UIAppearance colors for the AuthenticatorButton
     [[AuthenticatorButton appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [AuthenticatorButton appearance].backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(64.0/255.0) blue:(129.0/255.0) alpha:1.0];
     
     // Set UIAppearnce colors for Circle Code
     [CircleCodeImageView appearance].defaultColor = [UIColor darkGrayColor];
     [CircleCodeImageView appearance].highlightColor = [UIColor colorWithRed:(255.0/255.0) green:(64.0/255.0) blue:(129.0/255.0) alpha:1.0];
     
     // Set UIAppearance colors for the Authorization Slider
     [AuthorizationSliderButton appearance].backgroundColor = [UIColor grayColor];
     [AuthorizationSliderButton appearance].highlihgtedStateColor = [UIColor lightGrayColor];
     [[AuthorizationSliderButton appearance] setTintColor:[UIColor whiteColor]];
     [AuthorizationSlider appearance].topColor = [UIColor whiteColor];
     [AuthorizationSlider appearance].bottomColor = [UIColor darkGrayColor];
     
     // Set background color of controls
     [[AuthenticatorConfigurator sharedConfig] setControlsBackgroundColor:[UIColor clearColor]];
     
     // Set visibility of images for security factors
     [[AuthenticatorConfigurator sharedConfig] enableSecurityFactorImages:YES];
     
     // Set color of UITableView separator color
     [[UITableView appearance] setSeparatorColor:[UIColor clearColor]];
    
    // Set custom images for security factors
    [SecurityFactorTableViewCell appearance].imagePINCodeFactor = [UIImage imageNamed:@"Image1"];
    [SecurityFactorTableViewCell appearance].imageCircleCodeFactor = [UIImage imageNamed:@"Image2"];
    [SecurityFactorTableViewCell appearance].imageBluetoothFactor = [UIImage imageNamed:@"Image3"];
    [SecurityFactorTableViewCell appearance].imageGeofencingFactor = [UIImage imageNamed:@"Image4"];
    [SecurityFactorTableViewCell appearance].imageFingerprintFactor = [UIImage imageNamed:@"Image5"];
    
    // Set custom images for images in Auth Request Flow
    [AuthRequestContainer appearance].imageAuthRequestGeofence = [UIImage imageNamed:@"Image1"];
    [AuthRequestContainer appearance].imageAuthRequestBluetooth = [UIImage imageNamed:@"Image2"];
    [AuthRequestContainer appearance].imageAuthRequestFingerprint = [UIImage imageNamed:@"Image3"];
    
    self.window.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(121.0/255.0) blue:(107.0/255.0) alpha:1.0];
    
    if(launchOptions != NULL)
    {
        // For Push Notifications
        [[self.window rootViewController] view];
    }
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[AuthenticatorManager sharedClient] setNotificationToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[AuthenticatorManager sharedClient] handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // Added obsever so that app will check for auth requests in Auth Request View
    [[NSNotificationCenter defaultCenter] postNotificationName:requestReceived object:self];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
