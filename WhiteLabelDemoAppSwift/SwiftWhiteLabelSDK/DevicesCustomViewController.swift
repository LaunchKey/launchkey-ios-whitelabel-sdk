//
//  DevicesCustomViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

var devicesArray = NSArray ()

class DevicesCustomViewController:UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblDevices: UITableView!
    
    var devicesChildView:DevicesViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Devices (Custom UI)"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DevicesCustomViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = WhiteLabelConfigurator.sharedConfig().getPrimaryTextAndIconsColor()
        
        devicesChildView = DevicesViewController.init(parentView: self)
        
        devicesChildView.getDevices { (array, error) in
            
            if((error) != nil)
            {
                print("\(error)")
            }
            else
            {
                devicesArray = array
                
                for item in devicesArray
                {
                    let deviceObject = item as! LKWDevice
                    print("device name: \(deviceObject.name)")
                }
                
                self.tblDevices.reloadData()
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
    
    @IBAction func btnUnlinkPressed(sender: AnyObject)
    {
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton
        {
            if let superview = button.superview
            {
                if let cell = superview.superview as? DevicesCustomTableViewCell
                {
                    indexPath = tblDevices.indexPathForCell(cell)
                }
            }
        }
        
        if(indexPath.row == 0)
        {
            WhiteLabelManager.sharedClient().unlinkDevice(nil, withController:self, withCompletion: { (error) in
                if((error) != nil)
                {
                    print("\(error)")
                }
                else
                {
                    self.back()
                }
            })
        }
        else
        {
            
            let object = devicesArray[indexPath.row] as! LKWDevice
            
            WhiteLabelManager.sharedClient().unlinkDevice(object, withController:nil, withCompletion: { (error) in
                
                if((error) != nil)
                {
                    print("\(error)")
                }
                else
                {
                    self.devicesChildView.getDevices { (array, error) in
                        
                        devicesArray = array
                        
                        self.tblDevices.reloadData()
                    }
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return devicesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell :DevicesCustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("DevicesCell") as! DevicesCustomTableViewCell
        
        let object = devicesArray[indexPath.row] as! LKWDevice
        
        cell.labelDeviceName.text = object.name
        
        if(indexPath.row != 0)
        {
            cell.labelCurrentDevice.hidden = true;
        }
        
        //pending link
        if(object.isLinking())
        {
            cell.labelStatus.text = "Linking"
        }
            //pending unlink
        else if(object.isUnlinking())
        {
            cell.labelStatus.text = "Unlinking"
        }
            //normal
        else
        {
            cell.labelStatus.text = "Linked"
        }
        
        cell.btnUnlink.addTarget(self, action:#selector(DevicesCustomViewController.btnUnlinkPressed), forControlEvents:.TouchUpInside)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
}