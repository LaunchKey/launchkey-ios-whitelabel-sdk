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
    @IBOutlet weak var containerView: UIView!
 
    var authRequestView:AuthRequestViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Auth Request View"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ContainerViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavRefresh"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ContainerViewController.refresh))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        authRequestView = AuthRequestViewController.init(parentView: self)

        self.addChildViewController(authRequestView)
        containerView.addSubview(authRequestView.view)
        authRequestView.didMove(toParentViewController: self)

        authRequestView.check(forPendingAuthRequest: self.navigationController, withCompletion: { (message,error) in
            if((error) != nil)
            {
                print("\(error)")
            }
            else
            {
                print("\(message)")
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
    
    func requestIsApproved()
    {
        // This will be called when an auth request has been approved... Add any custom UI here
    }
    
    func requestIsDenied()
    {
        // This will be called when an auth request has been denied... Add any custom UI here
    }
    
    func requestIsReceived()
    {
        // This will be called when the device has received a pending Auth Request
        
        authRequestView.check(forPendingAuthRequest: self.navigationController, withCompletion: { (message,error) in
            if((error) != nil)
            {
                print("\(error)")
            }
            else
            {
                print("\(message)")
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
        authRequestView.check(forPendingAuthRequest: self.navigationController, withCompletion: { (message,error) in
            if((error) != nil)
            {
                print("\(error)")
            }
            else
            {
                print("\(message)")
            }
        })
    }
    
}
