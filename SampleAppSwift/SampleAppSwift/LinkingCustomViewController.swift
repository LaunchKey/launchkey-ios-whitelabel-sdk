//
//  LinkingCustomViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 7/31/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class LinkingCustomViewController: UIViewController
{
    @IBOutlet weak var tfLinkingCode: UITextField!
    @IBOutlet weak var tfDeviceName: UITextField!
    @IBOutlet weak var switchDeviceName: UISwitch!
    @IBOutlet weak var btnLink: UIButton!
    @IBOutlet weak var switchDeviceOverride: UISwitch!
    @IBOutlet weak var labelDeviceNameOverride: UILabel!
    
    var deviceNameOverride = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Linking View"
        
        switchDeviceName.addTarget(self, action: #selector(LinkingCustomViewController.stateChanged(_:)), for: UIControl.Event.valueChanged)
        switchDeviceOverride.addTarget(self, action: #selector(LinkingCustomViewController.stateChangedOverride(_:)), for: UIControl.Event.valueChanged)
        
        if #available(iOS 11.0, *) {
            tfLinkingCode.attributedPlaceholder = NSAttributedString(string: "Linking Code", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderTextColor")!])
            tfDeviceName.attributedPlaceholder = NSAttributedString(string: "Device Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderTextColor")!])
            labelDeviceNameOverride.textColor = UIColor(named:"viewTextColor")
        } else {
            tfLinkingCode.attributedPlaceholder = NSAttributedString(string: "Linking Code", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            tfDeviceName.attributedPlaceholder = NSAttributedString(string: "Device Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            labelDeviceNameOverride.textColor = UIColor.black
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnLinkPressed(_ sender: AnyObject)
    {
        
        let qrCode = tfLinkingCode.text ?? ""
        
        if(qrCode.count == 7)
        {
            if(switchDeviceName.isOn)
            {
                let deviceName = tfDeviceName.text ?? ""
                
                if(deviceName.count < 1)
                {
                    let alert = UIAlertView()
                    alert.title = "Device name should be at least 1 character"
                    alert.addButton(withTitle: "OK")
                    alert.show()
                }
                else if(deviceName.count == 0)
                {
                    let alert = UIAlertView()
                    alert.title = "Please enter a device name"
                    alert.addButton(withTitle: "OK")
                    alert.show()
                }
                else
                {
                    LKCAuthenticatorManager.sharedClient().linkDevice(qrCode, withSDKKey:UserDefaults.standard.string(forKey: "sdkKey"),  withDeviceName: deviceName, deviceNameOverride:deviceNameOverride, withCompletion: { (error) in
                        if((error) != nil)
                        {
                            print("\(error!)")
                            if(LKCErrorCode(rawValue: Int32(error!._code)) == DeviceAlreadyLinkedError)
                            {
                                let alert = UIAlertView()
                                alert.title = "Device Already Exists"
                                alert.message = "The device name you chose is already assigned to another device associated with your account.  Please choose an alternative name or unlink the conflicting device, and then try again."
                                alert.addButton(withTitle: "OK")
                                alert.show()
                            }
                        }
                        else
                        {
                            self.back()
                        }
                    })
                }
            }
            else
            {
                LKCAuthenticatorManager.sharedClient().linkDevice(qrCode, withSDKKey:UserDefaults.standard.string(forKey: "sdkKey"), withDeviceName:nil, deviceNameOverride:deviceNameOverride, withCompletion: { (error) in
                    if((error) != nil)
                    {
                        print("\(error!)")
                    }
                    else
                    {
                        self.back()
                    }
                })
            }
        }
        else
        {
            let alert = UIAlertView()
            alert.title = "QR Code should be 7 characters"
            alert.addButton(withTitle: "OK")
            alert.show()
        }
    }
    
    @objc func stateChanged(_ switchState: UISwitch)
    {
        if switchState.isOn
        {
            tfDeviceName.isEnabled = true
        }
        else
        {
            tfDeviceName.isEnabled = false
            tfDeviceName.resignFirstResponder()
        }
    }
    
    @objc func stateChangedOverride(_ switchState: UISwitch)
    {
        if switchState.isOn
        {
            deviceNameOverride = true
        }
        else
        {
            deviceNameOverride = false
        }
    }
    
    @IBAction func back()
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
}
