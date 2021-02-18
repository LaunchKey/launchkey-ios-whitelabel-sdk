//
//  SessionsCustomViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

var sessionsArray = [LKCSession]()

class SessionsCustomViewController:UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblAuths: UITableView!    
    
    var sessionsChildView:SessionsViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Sessions (Custom UI)"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SessionsCustomViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        let rightBarItem = UIBarButtonItem(title: "End All", style: .plain, target: self, action: #selector(SessionsCustomViewController.endAllSessions))
        rightBarItem.accessibilityIdentifier = "sessions_end_all"
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                
        LKCAuthenticatorManager.sharedClient().getSessions { (array, error) in
            
            if((error) != nil)
            {
                print("\(error!)")
            }
            else
            {
                sessionsArray = array!
                
                for item in sessionsArray
                {
                    let appObject = item
                    print("app name: \(appObject.serviceName!)")
                }
                
                self.tblAuths.reloadData()
            }
        }
    }
    
    @IBAction func back()
    {
        if let navController = self.navigationController
        {
            navController.popViewController(animated: true)
        }
    }
    
    func refreshView()
    {
        LKCAuthenticatorManager.sharedClient().getSessions { (array, error) in
            
            if((error) != nil)
            {
                print("\(error!)")
            }
            else
            {
                sessionsArray = array!
                self.tblAuths.reloadData()
            }
        }
    }
    
    @IBAction func endAllSessions()
    {
        LKCAuthenticatorManager.sharedClient().endAllSessions{(error) in
            if((error) != nil)
            {
                print("\(error!)")
            }
            else
            {
                self.refreshView()
            }
        }
    }
    
    @IBAction func btnRemovePressed(sender: AnyObject)
    {
        var indexPath: IndexPath?
        
        if let button = sender as? UIButton
        {
            if let superview = button.superview
            {
                if let cell = superview.superview as? SessionCustomTableViewCell
                {
                    indexPath = tblAuths.indexPath(for: cell)
                }
            }
        }
        
        if let row = indexPath?.row {
            LKCAuthenticatorManager.sharedClient().end(sessionsArray[row], completion: { (error) in
                self.tblAuths.reloadData();
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sessionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell :SessionCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AuthCell") as! SessionCustomTableViewCell

        let object = sessionsArray[indexPath.row]
        
        cell.labelAuthName.text = object.serviceName
        
        cell.btnRemove.addTarget(self, action:#selector(SessionsCustomViewController.btnRemovePressed), for:.touchUpInside)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
}
