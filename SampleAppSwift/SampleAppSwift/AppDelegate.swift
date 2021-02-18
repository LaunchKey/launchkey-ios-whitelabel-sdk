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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        registerForNotifications()
        
        // Set Default SDKKey
        var sdkKey = "053680cf-b3e4-4aef-9d23-803eb6ee2634"
        if let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
            // Grab SDK Key if Provided at Launch
            if let sdkKeyString: String = remoteNotif["sdkKey"] as? String {
                sdkKey = sdkKeyString
            }
        }
        
        // Store SDK Key to NSUserDefaults
        UserDefaults.standard.set(sdkKey, forKey:"sdkKey")
        
        let mainColor = UIColor(red: 0.0/255, green: 150.0/255, blue: 136.0/255, alpha: 1.0)
        let accentColor = UIColor(red: 61.0/255, green: 188.0/255, blue: 212.0/255, alpha: 1.0)
        let redColor = UIColor(red: 255.0/255, green: 64.0/255, blue: 129.0/255, alpha: 1.0)
        
        let config = AuthenticatorConfig.make {builder in
            builder?.sslPinningEnabled = true
            builder?.keyPairSize = keypair_maximum
            builder?.activationDelayLocation = activationDelayDefault
            builder?.activationDelayWearable = activationDelayDefault
            builder?.thresholdAuthFailure = thresholdAuthFailureDefault
            builder?.thresholdAutoUnlink = thresholdAutoUnlinkDefault
            builder?.thresholdAutoUnlinkWarning = thresholdWarningUnlinkMin
            builder?.enableInfoButtons = true
            builder?.enableHeaderViews = true
            builder?.enableNotificationPrompt = true
            builder?.enableSecurityChangesWhenUnlinked = false
            builder?.controlsBackgroundColor = UIColor.clear
            builder?.enableSecurityFactorImages = true
            builder?.geofenceCircleColor = accentColor
            builder?.tableViewHeaderBackgroundColor = UIColor.clear
            builder?.tableViewHeaderTextColor = accentColor
            builder?.securityViewsTextColor = UIColor.black
            builder?.securityFactorImageTintColor = UIColor.black
            builder?.enablePINCode = true
            builder?.enableCircleCode = true
            builder?.enableLocations = true
            builder?.enableWearable = true
            builder?.enableFingerprint = true
            builder?.enableFace = true
            builder?.authContentViewBackgroundColor = UIColor.white
            builder?.authTextColor = UIColor.purple
            builder?.authResponseAuthorizedColor = UIColor.green
            builder?.authResponseDeniedColor = UIColor.red
            builder?.authResponseFailedColor = UIColor.orange
            builder?.authResponseDenialReasonSelectedColor = accentColor;
            builder?.authResponseDenialReasonUnselectedColor = UIColor.brown
        }

        AuthenticatorManager.sharedClient().initialize(config)
        
        //---------------------------------------- SET COLORS VIA APPEARANCE PROXY ----------------------------------------
        
        // To set bar tint color of navigation bar
        UINavigationBar.appearance().barTintColor = mainColor
        
        // To set title text color of navigation bar
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        // To set tint color of UISwitch
        UISwitch.appearance().onTintColor = accentColor
        
        // To set tint color of bar button items
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        // To set tint color of Navigation Bar
        UINavigationBar.appearance().tintColor = UIColor.white
        
        // Set UIAppearance colors for PIN Code
        PinCodeButton.appearance().setTitleColor(accentColor, for: .normal)
        PinCodeButton.appearance().lettersColor = UIColor.black
        PinCodeButton.appearance().highlihgtedStateColor = UIColor.white
        PinCodeButton.appearance().backgroundColor = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1.0)
        PinCodeButton.appearance().setPinCodeButtonAsCircle(true)
        PinCodeButton.appearance().setBorderColor(accentColor)
        PinCodeButton.appearance().setBorderWidth(1.0)
        PinCodeButton.appearance().bulletColor = accentColor
        
        // Set UIAppearance colors for AuthenticatorButton
        AuthenticatorButton.appearance().setTitleColor(UIColor.white, for: .normal)
        AuthenticatorButton.appearance().backgroundColor = accentColor
        AuthenticatorButton.appearance().negativeActionTextColor = UIColor.white
        AuthenticatorButton.appearance().negativeActionBackgroundColor = redColor
        
        // Set UIAppearance colors for Circle Code
        CircleCodeImageView.appearance().defaultColor = UIColor.gray
        CircleCodeImageView.appearance().highlightColor = UIColor.darkGray
        
        // Set UIAppearance colors for UIButtons inside TableViewCells
        if #available(iOS 9.0, *)
        {
            UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).tintColor = redColor
        }
        
        // Set color of UITableView separator color
        UITableView.appearance().separatorColor = UIColor.clear
        
        // Set custom images for security factors
        SecurityFactorTableViewCell.appearance().imagePINCodeFactor = UIImage(named:"Image1")
        SecurityFactorTableViewCell.appearance().imageCircleCodeFactor = UIImage(named:"Image2")
        SecurityFactorTableViewCell.appearance().imageWearablesFactor = UIImage(named:"Image3")
        SecurityFactorTableViewCell.appearance().imageLocationsFactor = UIImage(named:"Image4")
        SecurityFactorTableViewCell.appearance().imageFingerprintFactor = UIImage(named:"Image5")
        
        // Set custom images for images in Auth Request flow
        AuthRequestContainer.appearance().imageAuthRequestGeofence = UIImage(named:"Image1")
        AuthRequestContainer.appearance().imageAuthRequestBluetooth = UIImage(named:"Image2")
        
        // Set color of IOATextField (in manual linking view) placeholder text color
        IOATextField.appearance().placeholderTextColor = UIColor.purple
        
        // Set color of Auth Response Expiration Timer in Auth Request Flow
        AuthResponseExpirationTimerView.appearance().backgroundColor = UIColor.blue
        AuthResponseExpirationTimerView.appearance().fillColor = UIColor.purple
        AuthResponseExpirationTimerView.appearance().warningColor = UIColor.orange
        
        // Set background and fill colors of Auth Response Buttons in Auth Request Flow
        AuthResponseButton.appearance().backgroundColor = UIColor(red: 245.0/255, green: 0.0/255, blue: 249.0/255, alpha: 1.0)
        AuthResponseButton.appearance().fillColor = UIColor(red: 154.0/255, green: 0.0/255, blue: 168.0/255, alpha: 1.0)
        AuthResponseNegativeButton.appearance().backgroundColor = UIColor(red: 0.0/255, green: 175.0/255, blue: 234.0/255, alpha: 1.0)
        AuthResponseNegativeButton.appearance().fillColor = UIColor(red: 0.0/255, green: 161.0/255, blue: 245.0/255, alpha: 1.0)
        
        // Set colors for Dark Mode
        if #available(iOS 11.0, *) {
            self.window?.backgroundColor = UIColor(named: "backgroundViewColor")
            UITableView.appearance().backgroundColor = UIColor(named: "backgroundViewColor")
            UITableViewCell.appearance().backgroundColor = UIColor(named: "cellBackgroundColor")
            UITextField.appearance().backgroundColor = UIColor(named:"whiteColor")
            UITextField.appearance().textColor = UIColor(named:"viewTextColor")
            IOATextField.appearance().backgroundColor = UIColor(named: "backgroundViewColor")
            IOATextField.appearance().textColor = UIColor(named: "viewTextColor")
            UILabel.appearance(whenContainedInInstancesOf: [UITableView.self]).textColor = UIColor(named:"viewTextColor")
        } else {
            self.window?.backgroundColor = UIColor(red: 239.0/256, green: 239.0/256.0, blue: 244.0/256.0, alpha: 1.0)
            UITableView.appearance().backgroundColor = UIColor(red: 239.0/256, green: 239.0/256.0, blue: 244.0/256.0, alpha: 1.0)
            UITableViewCell.appearance().backgroundColor = UIColor(red: 239.0/256, green: 239.0/256.0, blue: 244.0/256.0, alpha: 1.0)
            UITextField.appearance().backgroundColor = UIColor.white
            UITextField.appearance().textColor = UIColor.black
            IOATextField.appearance().backgroundColor = UIColor(red: 239.0/256, green: 239.0/256.0, blue: 244.0/256.0, alpha: 1.0)
            IOATextField.appearance().textColor = UIColor.black
            UILabel.appearance(whenContainedInInstancesOf: [UITableView.self]).textColor = UIColor.black
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    LKCAuthenticatorManager.sharedClient().setPushDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        LKCAuthenticatorManager.sharedClient().handlePushPayload(userInfo)
    }
    
    func registerForNotifications() {
        let userNotifications = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        // Next line calls method application(application, didRegister: notificationSettings) implemented below when finished
        UIApplication.shared.registerUserNotificationSettings(userNotifications)
        // Register NotificationCenter to listen for auth request notifications posted by LaunchKey SDK
        NotificationCenter.default.addObserver(forName: NSNotification.Name(requestReceived), object: nil, queue: nil) { (notificiation: Notification) in
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        // If user has allowed notifications
        if !notificationSettings.types.isEmpty {
            // Register device with APNS
            application.registerForRemoteNotifications()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if(UserDefaults.standard.bool(forKey: "dismissAuthRequest"))
        {
            let navigationController = window?.rootViewController as! UINavigationController
            navigationController.popViewController(animated: true)?.dismiss(animated: true, completion: nil)
        }
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

