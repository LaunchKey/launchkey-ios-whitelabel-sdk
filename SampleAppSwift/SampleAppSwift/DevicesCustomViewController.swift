//
//  DevicesCustomViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

var devicesArray = [IOADevice]()

class DevicesCustomViewController:UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblDevices: UITableView!
    
    var devicesChildView:DevicesViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Devices (Custom UI)"
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(DevicesCustomViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
                
        devicesChildView = DevicesViewController.init(parentView: self)
        
        devicesChildView.getDevices { (array, error) in
            
            if((error) != nil)
            {
                print("\(error)")
            }
            else
            {
                devicesArray = array!
                
                for item in devicesArray
                {
                    let deviceObject = item
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
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func btnUnlinkPressed(_ sender: AnyObject)
    {
        var indexPath: IndexPath?
        
        if let button = sender as? UIButton
        {
            if let superview = button.superview
            {
                if let cell = superview.superview as? DevicesCustomTableViewCell
                {
                    indexPath = tblDevices.indexPath(for: cell)
                }
            }
        }
        
        if let row = indexPath?.row, row == 0
        {
            AuthenticatorManager.sharedClient().unlinkDevice(nil, withCompletion: { (error) in
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
        else if let row = indexPath?.row, row < devicesArray.count
        {
            let object = devicesArray[row]
            
            AuthenticatorManager.sharedClient().unlinkDevice(object, withCompletion: { (error) in
                
                if((error) != nil)
                {
                    print("\(error)")
                }
                else
                {
                    self.devicesChildView.getDevices { (array, error) in
                        
                        devicesArray = array!
                        
                        self.tblDevices.reloadData()
                    }
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return devicesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell :DevicesCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DevicesCell") as! DevicesCustomTableViewCell
        
        let object = devicesArray[indexPath.row]
        
        cell.labelDeviceName.text = object.name

        if(indexPath.row != 0)
        {
            cell.labelCurrentDevice.isHidden = true;
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
        
        cell.btnUnlink.addTarget(self, action:#selector(DevicesCustomViewController.btnUnlinkPressed), for:.touchUpInside)

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
}
