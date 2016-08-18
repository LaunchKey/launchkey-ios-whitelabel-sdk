//
//  LogsCustomViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

var logsArray = NSMutableArray ()

class LogsCustomViewController:UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblLogs: UITableView!
    
    var logsChildView:LogsViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Logs (Custom UI)"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LogsCustomViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = WhiteLabelConfigurator.sharedConfig().getPrimaryTextAndIconsColor()
                
        logsChildView = LogsViewController.init(parentView: self)
        
        logsChildView.getLogs { (array, error) in
            
            if((error) != nil)
            {
                print("\(error)")
            }
            else
            {
                logsArray = array
                
                for item in logsArray
                {
                    let obj = item as! NSDictionary
                    for (key, value) in obj
                    {
                        print("Key: \(key) - Value: \(value)")
                    }
                }
                
                self.tblLogs.reloadData()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return logsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell :LogsCustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("LogsCell") as! LogsCustomTableViewCell
        
        let object = logsArray[indexPath.row] as! NSDictionary
        
        cell.labelLogName.text = object["app_name"] as? String
        
        let contextString = object["context"] as? String
        if(contextString != nil || contextString != "")
        {
            cell.labelContext.text = object["context"] as? String
        }
        
        let deviceString = object["device_name"] as? String
        if(deviceString != nil || deviceString != "")
        {
            cell.labelDevice.text = object["device_name"] as? String
        }
        
        cell.labelDateAndTime.text = object["date_updated"] as? String
        
        cell.labelState.text = object["status"] as? String

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
}