//
//  ViewController.swift
//  SwiftWhiteLabelSDK
//
//  Created by ani on 6/20/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import UIKit

var status : String!
let tableItems = ["Linking (Default Manual)", "Linking (Default Scanner)", "Linking (Custom Manual)", "Auth Methods", "Logout", "Unlink", "Check For Requests", "Sessions (Default UI)", "Sessions (Custom UI)", "Devices (Default UI)", "Devices (Custom UI)", "Config Testing", "Push Package Testing"]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblFeatures: UITableView!
    
    var deviceName: String?
    var notificationString: String?
    var activeSession: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblFeatures.register(UITableViewCell.self, forCellReuseIdentifier: "FeatureCell")

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.deviceNowUnlinked), name: NSNotification.Name(rawValue: deviceUnlinked), object: nil)

        self.refreshView()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.refreshView()
    }

    func refreshView ()
    {
        
        if(LKCAuthenticatorManager.sharedClient().isDeviceLinked())
        {
            status = "Linked"
        }
        else
        {
            status = "Unlinked"
        }
        
        self.title = String(format: "Sample App Swift (%@)", status)
    }
    
    @objc func deviceNowUnlinked()
    {
        // This will be called once the device is successfully unlinked or when the API returns an error indicating the device is unlinked
        
        self.refreshView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = tableItems[indexPath.row]
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if #available(iOS 11.0, *) {
            cell.textLabel?.textColor = UIColor(named: "viewTextColor")
        } else {
            cell.textLabel?.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == 0)
        {
            //Linking (Default Manual)
            
            DispatchQueue.main.async
            {
                if(!LKCAuthenticatorManager.sharedClient().isDeviceLinked())
                {
                    AuthenticatorManager.sharedClient().showLinkingView(self.navigationController, withSDKKey:UserDefaults.standard.string(forKey: "sdkKey"), withCamera: false, withCompletion: { error in
                        if let error = error {
                            print("\(error.localizedDescription)")
                        }
                        self.refreshView()
                            
                    })
                }
                else
                {
                    let alert = UIAlertView()
                    alert.title = "Device is linked"
                    alert.addButton(withTitle: "OK")
                    alert.show()
                }
            }
        }
        else if(indexPath.row == 1)
        {
            //Linking (Default Scanner)
            
            if(!LKCAuthenticatorManager.sharedClient().isDeviceLinked())
            {
                AuthenticatorManager.sharedClient().showLinkingView(self.navigationController, withSDKKey:UserDefaults.standard.string(forKey: "sdkKey"), withCamera: true, withCompletion: { error in
                    if let error = error {
                        print("\(error.localizedDescription)")
                    }
                    self.refreshView()

                })
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is linked"
                alert.addButton(withTitle: "OK")
                alert.show()
            }
        }
        else if(indexPath.row == 2)
        {
            //Linking (Custom Manual)
            
            if(!LKCAuthenticatorManager.sharedClient().isDeviceLinked())
            {
                self.performSegue(withIdentifier: "toLinkingCustomViewController", sender: self)

            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is linked"
                alert.addButton(withTitle: "OK")
                alert.show()
            }
        }
        else if(indexPath.row == 3)
        {
            //Security

            AuthenticatorManager.sharedClient().showSecurityView(withNavController: self.navigationController)
        }
        else if(indexPath.row == 4)
        {
            // Logout
            
            if(LKCAuthenticatorManager.sharedClient().isDeviceLinked())
            {
                // End All Sessions
                LKCAuthenticatorManager.sharedClient().endAllSessions{(error) in
                    if((error) != nil)
                    {
                        print("\(error)")
                    }
                    else
                    {
                        self.refreshView()
                    }
                }
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 5)
        {
            //Unlink

            if(LKCAuthenticatorManager.sharedClient().isDeviceLinked())
            {
                LKCAuthenticatorManager.sharedClient().unlinkDevice(nil, withCompletion: { (error) in
                    if((error) != nil)
                    {
                        print("\(error)")
                    }
                    else
                    {
                        self.refreshView()
                    }
                })
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        
        }
        else if(indexPath.row == 6)
        {
            //Check for Requests

            if(LKCAuthenticatorManager.sharedClient().isDeviceLinked())
            {
                self.performSegue(withIdentifier: "toContainerViewController", sender: self)
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 7)
        {
            //Authorizations (Default UI)
            
            if(LKCAuthenticatorManager.sharedClient().isDeviceLinked())
            {
                self.performSegue(withIdentifier: "toSessionsDefaultViewController", sender: self)
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 8)
        {
            //Authorizations (Custom UI)

            if(LKCAuthenticatorManager.sharedClient().isDeviceLinked())
            {
                self.performSegue(withIdentifier: "toSessionsCustomViewController", sender: self)
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 9)
        {
            //Devices (Default UI)

            if(LKCAuthenticatorManager.sharedClient().isDeviceLinked())
            {
                self.performSegue(withIdentifier: "toDevicesDefaultViewController", sender: self)
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 10)
        {
            //Devices (Custom UI)

            if(LKCAuthenticatorManager.sharedClient().isDeviceLinked())
            {
                self.performSegue(withIdentifier: "toDevicesCustomViewController", sender: self)
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 11)
        {
            self.performSegue(withIdentifier: "toConfigTestingViewController", sender: self)
        }
        else if(indexPath.row == 12)
        {
            self.performSegue(withIdentifier: "toPushPackageTesting", sender: self)
        }
    }
    
    func showDeviceNotLinkedError ()
    {
        let alert = UIAlertView()
        alert.title = "Device is not linked"
        alert.addButton(withTitle: "OK")
        alert.show()
    }
}

