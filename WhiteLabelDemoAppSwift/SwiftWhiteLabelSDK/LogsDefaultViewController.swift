//
//  LogsDefaultViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

class LogsDefaultViewController:UIViewController
{
    @IBOutlet weak var containerView: UIView!
    
    var logsChildView:LogsViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Logs (Default UI)"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ContainerViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = WhiteLabelConfigurator.sharedConfig().getPrimaryTextAndIconsColor()
        
        logsChildView = LogsViewController.init(parentView:self)
        
        self.addChildViewController(logsChildView)
        containerView.addSubview(logsChildView.view)
        logsChildView.didMoveToParentViewController(self)
        
    }
    
    @IBAction func back()
    {
        if let navController = self.navigationController
        {
            navController.popViewControllerAnimated(true)
        }
    }
}