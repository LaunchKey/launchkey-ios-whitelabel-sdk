//
//  ViewController.swift
//  SwiftWhiteLabelSDK
//
//  Created by ani on 6/20/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import UIKit

var status : String!
let tableItems = ["Linking (Default Manual)", "Linking (Default Scanner)", "Linking (Custom Manual)", "Security", "Security Information", "Logout", "Unlink", "Check For Requests", "Sessions (Default UI)", "Sessions (Custom UI)", "Devices (Default UI)", "Devices (Custom UI)", "Send Metrics", "Local Auth"]

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
        
        if(AuthenticatorManager.sharedClient().isAccountActive())
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == 0)
        {
            //Linking (Default Manual)
            
            DispatchQueue.main.async
                {
                    if(!AuthenticatorManager.sharedClient().isAccountActive())
                    {
                        AuthenticatorManager.sharedClient().showLinkingView(self.navigationController, withCamera: false, withLinked: {() in
                            
                            self.refreshView()
                            
                        }, withFailure:{(errorMessage, errorCode) in
                            
                            print("\(errorMessage), \(errorCode)")
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
            
            if(!AuthenticatorManager.sharedClient().isAccountActive())
            {
                AuthenticatorManager.sharedClient().showLinkingView(self.navigationController, withCamera: true, withLinked: {() in
                    
                    self.refreshView()
                    
                }, withFailure:{(errorMessage, errorCode) in
                    
                    print("\(errorMessage), \(errorCode)")
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
            
            if(!AuthenticatorManager.sharedClient().isAccountActive())
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
            
            AuthenticatorManager.sharedClient().showSecurityView(withNavController: self.navigationController, withUnLinked: {() in
                
            })
        }
        else if(indexPath.row == 4)
        {
            //Security Information
            
            if(AuthenticatorManager.sharedClient().isAccountActive())
            {
                let securityFactorArray = AuthenticatorManager.sharedClient().getSecurityInfo()
                
                var enabledFactor = ""
                
                for item in securityFactorArray!
                {
                    let obj = item as! NSDictionary
                    let factorString = obj["factor"] as! String
                    let typeString = obj["type"] as! String
                    let activeString = obj["active"] as! String
                    
                    enabledFactor = enabledFactor + "Factor: \(factorString) \n Type: \(typeString) \n Active: \(activeString) \n\n"
                }
                
                if(enabledFactor == "")
                {
                    enabledFactor = "There are no set factors"
                }
                
                let alert = UIAlertView()
                alert.title = "Set Factors:"
                alert.message = enabledFactor
                alert.addButton(withTitle: "OK")
                alert.show()
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 5)
        {
            // Logout
            
            if(AuthenticatorManager.sharedClient().isAccountActive())
            {
                // End All Sessions
                let sessions:SessionsViewController! = SessionsViewController.init(parentView:self)
                sessions.endAllSessions{(error) in
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
        else if(indexPath.row == 6)
        {
            //Unlink
            
            if(AuthenticatorManager.sharedClient().isAccountActive())
            {
                AuthenticatorManager.sharedClient().unlinkDevice(nil, withCompletion: { (error) in
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
        else if(indexPath.row == 7)
        {
            //Check for Requests
            
            if(AuthenticatorManager.sharedClient().isAccountActive())
            {
                self.performSegue(withIdentifier: "toContainerViewController", sender: self)
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 8)
        {
            //Authorizations (Default UI)
            
            if(AuthenticatorManager.sharedClient().isAccountActive())
            {
                self.performSegue(withIdentifier: "toSessionsDefaultViewController", sender: self)
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 9)
        {
            //Authorizations (Custom UI)
            
            if(AuthenticatorManager.sharedClient().isAccountActive())
            {
                self.performSegue(withIdentifier: "toSessionsCustomViewController", sender: self)
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 10)
        {
            //Devices (Default UI)
            
            if(AuthenticatorManager.sharedClient().isAccountActive())
            {
                self.performSegue(withIdentifier: "toDevicesDefaultViewController", sender: self)
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 11)
        {
            //Devices (Custom UI)
            
            if(AuthenticatorManager.sharedClient().isAccountActive())
            {
                self.performSegue(withIdentifier: "toDevicesCustomViewController", sender: self)
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 12)
        {
            if(AuthenticatorManager.sharedClient().isAccountActive())
            {
                AuthenticatorManager.sharedClient().sendMetrics(completion: { (error) in
                    if(error == nil)
                    {
                        DispatchQueue.main.async {
                            let alert = UIAlertView()
                            alert.title = "Metrics successfully sent!"
                            alert.addButton(withTitle: "OK")
                            alert.show()
                        }
                    }
                    else
                    {
                        print("\(error)")
                    }
                })
            }
            else
            {
                self.showDeviceNotLinkedError()
            }
        }
        else if(indexPath.row == 13)
        {
            self.performSegue(withIdentifier: "toLocalAuthViewController", sender: self)
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
