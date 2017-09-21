//
//  AppDelegate.swift
//  SwiftWhiteLabelSDK
//
//  Created by ani on 6/20/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
    // Set Endpoint
    AuthenticatorConfigurator.sharedConfig().setEndpoint("api.yourservice.com")
        
    // Set Activation Delay Times
    AuthenticatorConfigurator.sharedConfig().setActivationDelayProximity(activationDelayDefault)
        
    AuthenticatorConfigurator.sharedConfig().setActivationDelayGeofence(activationDelayDefault)
        
    // Include Info Button
    AuthenticatorConfigurator.sharedConfig().enableInfo(false)
    
    // Include Table Headers
    AuthenticatorConfigurator.sharedConfig().enableHeaderViews(true)
    
    //Enable Notification Prompt If Disabled
    AuthenticatorConfigurator.sharedConfig().enableNotificationPrompt(true)

    // Initialize the SDK Manager
    AuthenticatorManager.sharedClient().initSDK("<mobile_sdk_key>")
    
    //---------------------------------------- SET COLORS VIA APPEARANCE PROXY ----------------------------------------
    
    UINavigationBar.appearance().barTintColor = UIColor(red: 0.0/255, green: 150.0/255, blue: 136.0/255, alpha: 1.0)
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    
    // To set tint color of UISwitch
    UISwitch.appearance().onTintColor = UIColor(red: 255.0/255, green: 64.0/255, blue: 129.0/255, alpha: 1.0)
    
    // To set tint color of bar button items
    UIBarButtonItem.appearance().tintColor = UIColor.white
    
    // To set tint color of Navigation Bar
    UINavigationBar.appearance().tintColor = UIColor.white
    
    // Set UIAppearance colors for PIN Code
    PinCodeButton.appearance().setTitleColor(UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0), for: .normal)
    PinCodeButton.appearance().highlihgtedStateColor = UIColor.white
    PinCodeButton.appearance().backgroundColor = UIColor(red: 232.0/255, green: 232.0/255, blue: 232.0/255, alpha: 1.0)
    PinCodeButton.appearance().setPinCodeButtonAsCircle(true)
    
    // Set UIAppearance colors for AuthenticatorButton
    AuthenticatorButton.appearance().setTitleColor(UIColor.white, for: .normal)
    AuthenticatorButton.appearance().backgroundColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0)
    
    // Set UIAppearance colors for Circle Code
    CircleCodeImageView.appearance().defaultColor = UIColor.gray
    CircleCodeImageView.appearance().highlightColor = UIColor(red: 255.0/255, green: 64.0/255, blue: 129.0/255, alpha: 1.0)
    
    // Set UIAppearance colors for the Authorization Slider
    AuthorizationSliderButton.appearance().backgroundColor = UIColor.gray
    AuthorizationSliderButton.appearance().highlihgtedStateColor = UIColor.lightGray
    AuthorizationSliderButton.appearance().tintColor = UIColor.white
    AuthorizationSlider.appearance().topColor = UIColor.white
    AuthorizationSlider.appearance().bottomColor = UIColor.darkGray
    
    // Set backgrund of controls
    AuthenticatorConfigurator.sharedConfig().setControlsBackgroundColor(UIColor.clear)
    
    // Set visibility of images for security factors
    AuthenticatorConfigurator.sharedConfig().enableSecurityFactorImages(true)
    
    // Set color of UITableView separator color
    UITableView.appearance().separatorColor = UIColor.clear
    
    // Set custom images for security factors
    SecurityFactorTableViewCell.appearance().imagePINCodeFactor = UIImage(named:"Image1")
    SecurityFactorTableViewCell.appearance().imageCircleCodeFactor = UIImage(named:"Image2")
    SecurityFactorTableViewCell.appearance().imageBluetoothFactor = UIImage(named:"Image3")
    SecurityFactorTableViewCell.appearance().imageGeofencingFactor = UIImage(named:"Image4")
    SecurityFactorTableViewCell.appearance().imageFingerprintFactor = UIImage(named:"Image5")
    
    // Set custom images for images in Auth Request flow
    AuthRequestContainer.appearance().imageAuthRequestGeofence = UIImage(named:"Image1")
    AuthRequestContainer.appearance().imageAuthRequestBluetooth = UIImage(named:"Image2")
    AuthRequestContainer.appearance().imageAuthRequestFingerprint = UIImage(named:"Image3")
    
    self.window?.backgroundColor = UIColor(red: 0/255, green: 121/255, blue: 107/255, alpha: 1.0)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AuthenticatorManager.sharedClient().setNotificationToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        AuthenticatorManager.sharedClient().handleRemoteNotification(userInfo)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        // Added obsever so that app will check for auth requests in Auth Request View
        let noficationName = Notification.Name(requestReceived)
        NotificationCenter.default.post(name:noficationName, object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
}

