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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ContainerViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = WhiteLabelConfigurator.sharedConfig().getPrimaryTextAndIconsColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavRefresh"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ContainerViewController.refresh))
        self.navigationItem.rightBarButtonItem?.tintColor = WhiteLabelConfigurator.sharedConfig().getPrimaryTextAndIconsColor()
        
        authRequestView = AuthRequestViewController.init(parentView: self)
        
        self.addChildViewController(authRequestView)
        containerView.addSubview(authRequestView.view)
        authRequestView.didMoveToParentViewController(self)
        
        authRequestView.checkForPendingAuthRequest(self, withCompletion: { (error) in
            if((error) != nil)
            {
                print("\(error)")
            }
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(requestIsApproved), name: requestApproved, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(requestIsDenied), name: requestDenied, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(requestIsOld), name: possibleOldRequest, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(requestIsHidden), name: requestHidden, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(requestIsReceived), name: requestReceived, object: nil)
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func requestIsApproved()
    {
        // This will be called when an auth request has been approved... Add any custom UI here
    }
    
    func requestIsDenied()
    {
        // This will be called when an auth request has been denied... Add any custom UI here
    }
    
    func requestIsOld()
    {
        // This will be called when the user responds to a possible old request... Add any custom UI here
    }
    
    func requestIsHidden()
    {
        // This will be called when an auth request has been hidden after setting up additional security factors from the auth request flow
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.refresh()
        }
    }
    
    func requestIsReceived()
    {
        // This will be called when the device has received a pending Auth Request
        
        authRequestView.checkForPendingAuthRequest(self, withCompletion: { (error) in
            if((error) != nil)
            {
                print("\(error)")
            }
        })
    }
    
    @IBAction func back()
    {
        if let navController = self.navigationController
        {
            navController.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func refresh()
    {
        authRequestView.checkForPendingAuthRequest(self, withCompletion: { (error) in
            if((error) != nil)
            {
                print("\(error)")
            }
        })
    }
    
}