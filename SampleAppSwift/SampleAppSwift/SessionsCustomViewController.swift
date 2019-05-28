//
//  SessionsCustomViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

var authsArray = [IOASession]()

class SessionsCustomViewController:UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblAuths: UITableView!    
    
    var authorizationChildView:SessionsViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Sessions (Custom UI)"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SessionsCustomViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        authorizationChildView = SessionsViewController.init(parentView: self)
        
        authorizationChildView.getSessions { (array, error) in
            
            if((error) != nil)
            {
                print("\(error)")
            }
            else
            {
                authsArray = array!
                
                for item in authsArray
                {
                    let appObject = item
                    print("app name: \(appObject.serviceName)")
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
            authorizationChildView.clear(authsArray[row])
            self.tblAuths.reloadData();
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return authsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell :SessionCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AuthCell") as! SessionCustomTableViewCell

        let object = authsArray[indexPath.row]
        
        cell.labelAuthName.text = object.serviceName
        
        cell.btnRemove.addTarget(self, action:#selector(SessionsCustomViewController.btnRemovePressed), for:.touchUpInside)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
}
