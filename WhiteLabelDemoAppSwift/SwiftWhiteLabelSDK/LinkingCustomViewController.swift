//
//  LinkingCustomViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 7/31/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

class LinkingCustomViewController: UIViewController
{
    @IBOutlet weak var tfLinkingCode: UITextField!
    @IBOutlet weak var tfDeviceName: UITextField!
    @IBOutlet weak var switchDeviceName: UISwitch!
    @IBOutlet weak var btnLink: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Linking View"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ContainerViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = WhiteLabelConfigurator.sharedConfig().getPrimaryTextAndIconsColor()
        
        switchDeviceName.addTarget(self, action: #selector(LinkingCustomViewController.stateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        switchDeviceName.onTintColor = WhiteLabelConfigurator.sharedConfig().getSecondaryColor()
        
        btnLink.setTitleColor(WhiteLabelConfigurator.sharedConfig().getSecondaryColor(), forState: .Normal)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnLinkPressed(sender: AnyObject)
    {
        
        let qrCode = tfLinkingCode.text
        
        if(qrCode?.characters.count == 7)
        {
            if(switchDeviceName.on)
            {
                let deviceName = tfDeviceName.text
                
                if(deviceName?.characters.count < 3)
                {
                    let alert = UIAlertView()
                    alert.title = "Device name should be at least 3 characters"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
                else if(deviceName?.characters.count == 0)
                {
                    let alert = UIAlertView()
                    alert.title = "Please enter a device name"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
                else
                {
                    WhiteLabelManager.sharedClient().linkUser(qrCode, withDeviceName: deviceName, withCompletion: { (error) in
                        if((error) != nil)
                        {
                            print("\(error)")
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
                WhiteLabelManager.sharedClient().linkUser(qrCode, withDeviceName:nil, withCompletion: { (error) in
                    if((error) != nil)
                    {
                        print("\(error)")
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
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func stateChanged(switchState: UISwitch)
    {
        if switchState.on
        {
            tfDeviceName.enabled = true
        }
        else
        {
            tfDeviceName.enabled = false
            tfDeviceName.resignFirstResponder()
        }
    }
    
    @IBAction func back()
    {
        if let navController = self.navigationController
        {
            navController.popViewControllerAnimated(true)
        }
    }
}

