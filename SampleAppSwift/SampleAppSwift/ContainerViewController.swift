//
//  ContainerViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 7/22/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

class ContainerViewController: UIViewController
{
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Auth Request View"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(ContainerViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "NavRefresh"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(ContainerViewController.refresh))
        rightBarItem.accessibilityIdentifier = "checkForRequests_refresh"
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        AuthRequestManager.shared().check(forPendingAuthRequest: self.navigationController, withCompletion: { (message,error) in
            if let requestError = error
            {
                print("Auth-request error: \(requestError)")
                if let reason = (requestError as NSError).localizedFailureReason, reason == "Authorization already has response!"
                {
                    let alert = UIAlertView()
                    alert.title = "Authorization already has a response"
                    alert.addButton(withTitle: "OK")
                    alert.show()
                }
            }
            else if let requestMessage = message
            {
                print("Auth-request message: \(requestMessage)")
            }
        })
        
        NotificationCenter.default.addObserver(self, selector:#selector(requestIsApproved), name: NSNotification.Name(rawValue: requestApproved), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(requestIsDenied), name: NSNotification.Name(rawValue: requestDenied), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(requestIsReceived), name: NSNotification.Name(rawValue: requestReceived), object: nil)

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let noficationName = Notification.Name(requestReceived)
        NotificationCenter.default.removeObserver(self, name: noficationName, object: nil)
    }
    
    @objc func requestIsApproved()
    {
        // This will be called when an auth request has been approved... Add any custom UI here
    }
    
    @objc func requestIsDenied()
    {
        // This will be called when an auth request has been denied... Add any custom UI here
    }
    
    @objc func requestIsReceived()
    {
        // This will be called when the device has received a pending Auth Request
        
        AuthRequestManager.shared().check(forPendingAuthRequest: self.navigationController, withCompletion: { (message,error) in
            if let requestError = error
            {
                print("Auth-request error: \(requestError)")
                if let reason = (requestError as NSError).localizedFailureReason, reason == "Authorization already has response!"
                {
                    let alert = UIAlertView()
                    alert.title = "Authorization already has a response"
                    alert.addButton(withTitle: "OK")
                    alert.show()
                }
            }
            else if let requestMessage = message
            {
                print("Auth-request message: \(requestMessage)")
            }
        })
    }
    
    @IBAction func back()
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func refresh()
    {
        AuthRequestManager.shared().check(forPendingAuthRequest: self.navigationController, withCompletion: { (message,error) in
            if let requestError = error
            {
                print("Auth-request error: \(requestError)")
                if let reason = (requestError as NSError).localizedFailureReason, reason == "Authorization already has response!"
                {
                    let alert = UIAlertView()
                    alert.title = "Authorization already has a response"
                    alert.addButton(withTitle: "OK")
                    alert.show()
                }
            }
            else if let requestMessage = message
            {
                print("Auth-request message: \(requestMessage)")
            }
        })
    }
}
