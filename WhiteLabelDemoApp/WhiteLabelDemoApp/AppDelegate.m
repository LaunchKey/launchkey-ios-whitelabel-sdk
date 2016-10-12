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
    
        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    
    //Set Key Pair Size
    [[WhiteLabelConfigurator sharedConfig] setKeyPairSize:keypair_maximum];
    
    // Initialize the SDK Manager
    [[WhiteLabelManager sharedClient] initSDK:@"<WhiteLabel_key>"];
    
    // Set Font
    NSString *customFont = @"Roboto";
    [[WhiteLabelConfigurator sharedConfig] setFont:customFont];
    
    // Set Colors
    [[WhiteLabelConfigurator sharedConfig] setPrimaryColor:[UIColor colorWithRed:(0.0/255.0) green:(150.0/255.0) blue:(136.0/255.0) alpha:1.0]];
    [[WhiteLabelConfigurator sharedConfig] setSecondaryColor:[UIColor colorWithRed:(255.0/255.0) green:(64.0/255.0) blue:(129.0/255.0) alpha:1.0]];
    [[WhiteLabelConfigurator sharedConfig] setPrimaryTextAndIcons:[UIColor whiteColor]];
    [[WhiteLabelConfigurator sharedConfig] setBackgroundColor:[UIColor colorWithRed:(0.0/255.0) green:(121.0/255.0) blue:(107.0/255.0) alpha:1.0]];
    
    if(launchOptions != NULL)
    {
        // For Push Notifications
        [[self.window rootViewController] view];
    }
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[WhiteLabelManager sharedClient] setNotificationToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[WhiteLabelManager sharedClient] handleRemoteNotification:userInfo];
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
