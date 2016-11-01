//
//  AuthorizationsCustomViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

var authsArray = NSArray ()

class AuthorizationsCustomViewController:UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblAuths: UITableView!
    
    var authorizationChildView:AuthorizationViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Authorizations (Custom UI)"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AuthorizationsCustomViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = WhiteLabelConfigurator.sharedConfig().getPrimaryTextAndIconsColor()
        
        authorizationChildView = AuthorizationViewController.init(parentView: self)
        
        authorizationChildView.getApplications { (array, error) in
            
            if((error) != nil)
            {
                print("\(error)")
            }
            else
            {
                authsArray = array
                
                for item in authsArray
                {
                    let appObject = item as! LKWApplication
                    print("app name: \(appObject.name)")
                }
                
                self.tblAuths.reloadData()
            }
        }
    }
    
    @IBAction func back()
    {
        if let navController = self.navigationController
        {
            navController.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func btnRemovePressed(sender: AnyObject)
    {
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton
        {
            if let superview = button.superview
            {
                if let cell = superview.superview as? AuthCustomTableViewCell
                {
                    indexPath = tblAuths.indexPathForCell(cell)
                }
            }
        }
        
        authorizationChildView.clearApplication(authsArray[indexPath.row] as! LKWApplication)
        
        self.tblAuths.reloadData();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return authsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell :AuthCustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("AuthCell") as! AuthCustomTableViewCell
        
        let object = authsArray[indexPath.row] as! LKWApplication
        
        cell.labelAuthName.text = object.name
        
        cell.labelAuthContext.text = object.context
        
        cell.labelAction.text = object.action
        
        cell.labelStatus.text = object.status
        
        if(object.session == "0")
        {
            cell.labelTransactional.hidden = false
        }
        else
        {
            cell.labelTransactional.hidden = true
        }
        
        cell.btnRemove.addTarget(self, action:#selector(AuthorizationsCustomViewController.btnRemovePressed), forControlEvents:.TouchUpInside)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
}