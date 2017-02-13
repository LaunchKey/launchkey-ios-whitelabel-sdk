//
//  SessionsDefaultViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

class SessionsDefaultViewController:UIViewController
{
    @IBOutlet weak var containerView: UIView!
    
    var authorizationChildView:SessionsViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Sessions (Default UI)"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ContainerViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        authorizationChildView = SessionsViewController.init(parentView: self)
        
        self.addChildViewController(authorizationChildView)
        containerView.addSubview(authorizationChildView.view)
        authorizationChildView.didMove(toParentViewController: self)
        
    }
    
    @IBAction func back()
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
}
