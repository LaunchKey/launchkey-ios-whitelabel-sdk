//
//  ViewController.swift
//  SwiftWhiteLabelSDK
//
//  Created by ani on 6/20/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import UIKit

var status : String!
var tableItems : [String] = ["Linking (Default Manual)", "Linking (Default Scanner)", "Linking (Custom Manual)", "Security", "Security Information", "Logout", "Unlink", "Check For Requests", "Authorizations (Default UI)", "Authorizations (Custom UI)", "Devices (Default UI)", "Devices (Custom UI)", "Logs (Default UI)", "Logs (Custom UI)", "OTP"]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblFeatures: UITableView!
    
    var deviceName: String?
    var notificationString: String?
    var activeSession: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblFeatures.registerClass(UITableViewCell.self, forCellReuseIdentifier: "FeatureCell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.checkActiveSessions), name: activeSessionComplete, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.checkActiveSession), name: activeSessionComplete, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.deviceNowUnlinked), name: deviceUnlinked, object: nil)
        
        self.refreshView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.refreshView()
    }
    
    func refreshView ()
    {
        
        if(WhiteLabelManager.sharedClient().isAccountActive())
        {
            status = "Linked"
            
            WhiteLabelManager.sharedClient().checkActiveSessions()
        }
        else
        {
            status = "Unlinked"
        }
        
        self.title = String(format: "WhiteLabel Demo App (%@)", status)
    }
    
    func checkActiveSessions(notification:NSNotification)
    {
        // This will be called checkActiveSessions has completed
        
        notificationString = notification.object as? String
        
        if(notificationString == "YES")
        {
            activeSession = "YES"
        }
        else
        {
            activeSession = "NO"
        }
    }
    
    func checkActiveSession()
    {
        // This will be called checkActiveSessions has completed
        
    }
    
    func deviceNowUnlinked()
    {
        // This will be called once the device is successfully unlinked or when the API returns an error indicating the device is unlinked
        
        self.refreshView()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeatureCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = tableItems[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if(indexPath.row == 0)
        {
            //Linking (Default Manual)
            
            dispatch_async(dispatch_get_main_queue())
            {
                if(!WhiteLabelManager.sharedClient().isAccountActive())
                {
                    WhiteLabelManager.sharedClient().showLinkingView(self, withCamera: false, withLinked: {() in
                        
                        self.refreshView()
                        
                        }, withFailure:{(errorMessage, errorCode) in
                            
                            print("\(errorMessage), \(errorCode)")
                    })
                }
                else
                {
                    let alert = UIAlertView()
                    alert.title = "Device is linked"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
            }
        }
        else if(indexPath.row == 1)
        {
            //Linking (Default Scanner)
            
            if(!WhiteLabelManager.sharedClient().isAccountActive())
            {
                WhiteLabelManager.sharedClient().showLinkingView(self, withCamera: true, withLinked: {() in
                    
                    self.refreshView()
                    
                    }, withFailure:{(errorMessage, errorCode) in
                        
                        print("\(errorMessage), \(errorCode)")
                })
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 2)
        {
            //Linking (Custom Manual)
            
            if(!WhiteLabelManager.sharedClient().isAccountActive())
            {
                self.performSegueWithIdentifier("toLinkingCustomViewController", sender: self)
                
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 3)
        {
            //Security
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                WhiteLabelManager.sharedClient().showSecurityView(self, withUnLinked: {() in
                    
                })
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 4)
        {
            //Security Information
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                let securityFactorArray = WhiteLabelManager.sharedClient().getSecurityInfo()
                
                var enabledFactor = ""
                
                for item in securityFactorArray
                {
                    let obj = item as! NSDictionary
                    let factorString = obj["factor"] as! String
                    let typeString = obj["type"] as! String
                    let activeString = obj["active"] as! String
                    
                    enabledFactor = enabledFactor.stringByAppendingString("Factor: \(factorString) \n Type: \(typeString) \n Active: \(activeString) \n\n")
                }
                
                if(enabledFactor == "")
                {
                    enabledFactor = "There are no set factors"
                }
                
                let alert = UIAlertView()
                alert.title = "Set Factors:"
                alert.message = enabledFactor
                alert.addButtonWithTitle("OK")
                alert.show()
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 5)
        {
            // Logout
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                if (activeSession == "YES")
                {
                    WhiteLabelManager.sharedClient().logOutWithViewController(self, withCompletion: { (error) in
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
                    let alert = UIAlertView()
                    alert.title = "No active sessions"
                    alert.addButtonWithTitle("OK")
                    alert.show()
                }
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 6)
        {
            //Unlink
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                WhiteLabelManager.sharedClient().unlinkDevice(nil, withController:self, withCompletion: { (error) in
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
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
            
        }
        else if(indexPath.row == 7)
        {
            //Check for Requests
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                self.performSegueWithIdentifier("toContainerViewController", sender: self)
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 8)
        {
            //Authorizations (Default UI)
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                self.performSegueWithIdentifier("toAuthorizationsDefaultViewController", sender: self)
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 9)
        {
            //Authorizations (Custom UI)
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                self.performSegueWithIdentifier("toAuthorizationsCustomViewController", sender: self)
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 10)
        {
            //Devices (Default UI)
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                self.performSegueWithIdentifier("toDevicesDefaultViewController", sender: self)
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 11)
        {
            //Devices (Custom UI)
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                self.performSegueWithIdentifier("toDevicesCustomViewController", sender: self)
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 12)
        {
            //Logs (Default UI)
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                self.performSegueWithIdentifier("toLogsDefaultViewController", sender: self)
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 13)
        {
            //Logs (Custom UI)
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                self.performSegueWithIdentifier("toLogsCustomViewController", sender: self)
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
        else if(indexPath.row == 14)
        {
            //OTP
            
            if(WhiteLabelManager.sharedClient().isAccountActive())
            {
                WhiteLabelManager.sharedClient().showTokensView(self, withUnLinked: {() in
                    
                })
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Device is not linked"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
    }
}