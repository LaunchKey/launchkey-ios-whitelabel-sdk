//
//  DevicesDefaultViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

class DevicesDefaultViewController:UIViewController
{
    @IBOutlet weak var containerView: UIView!
    
    var devicesChildView:DevicesViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Devices (Default UI)"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(ContainerViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        devicesChildView = DevicesViewController.init(parentView: self)
        
        self.addChild(devicesChildView)
        containerView.addSubview(devicesChildView.view)
        devicesChildView.didMove(toParent: self)
        
    }
    
    @IBAction func back()
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
}
