//
//  LogsCustomViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

var logsArray = NSArray ()

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
        
        logsChildView.getLogEvents{ (array, error) in
            
            if((error) != nil)
            {
                print("\(error)")
            }
            else
            {
                logsArray = array
                
                for item in logsArray
                {
                    let logObject = item
                    print("app name: \(logObject.appName)")
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
        
        let object = logsArray[indexPath.row] as! LKWLogEvent
        
        cell.labelLogName.text = object.appName
        
        let contextString = object.context
        if(contextString != nil || contextString != "")
        {
            cell.labelContext.text = contextString
        }
        
        let deviceString = object.appName
        if(deviceString != nil || deviceString != "")
        {
            cell.labelDevice.text = deviceString
        }
        
        cell.labelDateAndTime.text = object.dateUpdated
        
        cell.labelState.text = object.status
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
}