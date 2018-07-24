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
    
    // Set SSL Pinning
    [[AuthenticatorConfigurator sharedConfig] turnOnSSLPinning];
    
    //Set Key Pair Size
    [[AuthenticatorConfigurator sharedConfig] setKeyPairSize:keypair_maximum];
    
    // Set Activation Delay Times
    [[AuthenticatorConfigurator sharedConfig] setActivationDelayProximity:activationDelayDefault];
    
    [[AuthenticatorConfigurator sharedConfig] setActivationDelayGeofence:activationDelayDefault];
    
    //Include Info Button
    [[AuthenticatorConfigurator sharedConfig] enableInfo:YES];
    
    //Include Table Headers
    [[AuthenticatorConfigurator sharedConfig] enableHeaderViews:YES];
    
    //Enable Notification Prompt If Disabled
    [[AuthenticatorConfigurator sharedConfig] enableNotificationPrompt:YES];
    
    //Enable Changes to Security When Unlinked
    [[AuthenticatorConfigurator sharedConfig] enableSecurityChangesWhenUnlinked:NO];
    
    // Initialize the SDK Manager
    [[AuthenticatorManager sharedClient] initSDK:@"<mobile_sdk_key>"];
    
    
    //---------------------------------------- SET COLORS VIA APPEARANCE PROXY ----------------------------------------
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    UIColor *mainColor = [UIColor colorWithRed:(0.0/255.0) green:(150.0/255.0) blue:(136.0/255.0) alpha:1.0];
    UIColor *accentColor = [UIColor colorWithRed:(61.0/255.0) green:(188.0/255.0) blue:(212.0/255.0) alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:(255.0/255.0) green:(64.0/255.0) blue:(129.0/255.0) alpha:1.0];
    
    // To set bar tint color of navigation bar
    [navigationBarAppearance setBarTintColor:mainColor];
    
    // To set title text color of navigation bar
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
    // To set appearance for normal bar button items
    NSDictionary *textAttributes2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:textAttributes2
     forState:UIControlStateNormal];
    
    // To set tint color of UISwitch
    [[UISwitch appearance] setOnTintColor:redColor];
    
    // To set tint color of bar button items
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
    
    // To set tint color of Navigation Bar
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Set text color of labels in Security View and Add Bluetooth Proximity View
    [IOALabel appearance].textColor = [UIColor blackColor];
    
    // Set UIAppearance colors for PIN Code
    [[PinCodeButton appearance] setTitleColor:accentColor forState:UIControlStateNormal];
    [PinCodeButton appearance].lettersColor = [UIColor blackColor];
    [PinCodeButton appearance].highlihgtedStateColor = [UIColor whiteColor];
    [PinCodeButton appearance].backgroundColor = [UIColor colorWithRed:(245.0/255.0) green:(245.0/255.0) blue:(245.0/255.0) alpha:1.0];
    [[PinCodeButton appearance] setPinCodeButtonAsCircle:YES];
    [[PinCodeButton appearance] setBorderColor:accentColor];
    [[PinCodeButton appearance] setBorderWidth:1.0f];
    [PinCodeButton appearance].bulletColor = accentColor;
    
    // Set UIAppearance colors for the AuthenticatorButton
    [[AuthenticatorButton appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AuthenticatorButton appearance].backgroundColor = redColor;
    [AuthenticatorButton appearance].negativeActionTextColor = [UIColor whiteColor];
    [AuthenticatorButton appearance].negativeActionBackgroundColor = redColor;
    
    // Set UIAppearnce colors for Circle Code
    [CircleCodeImageView appearance].defaultColor = [UIColor darkGrayColor];
    [CircleCodeImageView appearance].highlightColor = redColor;
    
    // Set UIAppearance colors for UIButtons inside TableViewCells
    [[UIButton appearanceWhenContainedIn:[UITableViewCell class], nil] setTintColor:redColor];
    
    // Set UIAppearance colors for the Authorization Slider
    [AuthorizationSliderButton appearance].backgroundColor = [UIColor grayColor];
    [AuthorizationSliderButton appearance].highlihgtedStateColor = [UIColor lightGrayColor];
    [[AuthorizationSliderButton appearance] setTintColor:[UIColor whiteColor]];
    [AuthorizationSlider appearance].topColor = [UIColor grayColor];
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
    
    // Set color of IOATextField (in manual linking view) placeholder text color
    [IOATextField appearance].placeholderTextColor = [UIColor lightGrayColor];
    
    // Set color of geofence cirlce
    [[AuthenticatorConfigurator sharedConfig] setGeofenceCircleColor:accentColor];
    
    // Set colors of TableView Header background and text
    [[AuthenticatorConfigurator sharedConfig] setTableViewHeaderBackgroundColor:[UIColor clearColor]];
    [[AuthenticatorConfigurator sharedConfig] setTableViewHeaderTextColor:accentColor];
    
    // Set colors of text throughout Security Views
    [[AuthenticatorConfigurator sharedConfig] setSecurityViewsTextColor:[UIColor blackColor]];
    
    // Set tint color of factor images in Security View
    [[AuthenticatorConfigurator sharedConfig] setSecurityFactorImageTintColor:[UIColor blackColor]];
    
    // To set background color of all views
    self.window.backgroundColor = [UIColor whiteColor];
    
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
