//
//  AuthorizationsDefaultViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

class AuthorizationsDefaultViewController:UIViewController
{
    @IBOutlet weak var containerView: UIView!
    
    var authorizationChildView:AuthorizationViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Authorizations (Default UI)"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ContainerViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = WhiteLabelConfigurator.sharedConfig().getPrimaryTextAndIconsColor()
        
        authorizationChildView = AuthorizationViewController.init(parentView: self)
        
        self.addChildViewController(authorizationChildView)
        containerView.addSubview(authorizationChildView.view)
        authorizationChildView.didMoveToParentViewController(self)
        
    }
    
    @IBAction func back()
    {
        if let navController = self.navigationController
        {
            navController.popViewControllerAnimated(true)
        }
    }
}