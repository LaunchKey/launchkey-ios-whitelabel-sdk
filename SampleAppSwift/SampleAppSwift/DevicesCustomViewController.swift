//
//  DevicesCustomViewController.swift
//  WhiteLabelDemoAppSwift
//
//  Created by ani on 8/7/16.
//  Copyright © 2016 LaunchKey. All rights reserved.
//

import Foundation

var devicesArray = [LKCDevice]()

class DevicesCustomViewController:UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblDevices: UITableView!
    
    var devicesChildView:DevicesViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Devices (Custom UI)"
        
        devicesArray = [LKCDevice]()
        
        //Navigation Bar Buttons
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "NavBack"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(DevicesCustomViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
                        
        LKCAuthenticatorManager.sharedClient().getDevices { (array, error) in
            
            if((error) != nil)
            {
                print("\(error!)")
                let reason = (error! as NSError).localizedDescription
                if reason == "The Internet connection appears to be offline." {
                    let alertController = UIAlertController(title: "Error", message:"This authenticator can't establish a connection with the network. To proceed, please verify that this device is connected to an active wireless or cellular network with internet connectivity.", preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
                    }
                    alertController.addAction(okBtn)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else
            {
                devicesArray = array!
                
                for item in devicesArray
                {
                    let deviceObject = item
                    print("device name: \(deviceObject.name!)")
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
            
            let alertController = UIAlertController(title: "Unlink this device?", message:nil, preferredStyle: .alert)
                    
            let unlink = UIAlertAction(title: "Unlink", style: .default) { (action:UIAlertAction) in
            
                LKCAuthenticatorManager.sharedClient().unlinkDevice(nil, withCompletion: { (error) in
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

            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            }
            
            alertController.addAction(unlink)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
        else if let row = indexPath?.row, row < devicesArray.count
        {
            let object = devicesArray[row]
            let remoteDeviceName = object.name as String?
            let message = String(format: "Unlink %@?", remoteDeviceName!)
            
            let alertController = UIAlertController(title: message, message:nil, preferredStyle: .alert)
                    
            let unlink = UIAlertAction(title: "Unlink", style: .default) { (action:UIAlertAction) in
                
                LKCAuthenticatorManager.sharedClient().unlinkDevice(object, withCompletion: { (error) in
                    
                    if((error) != nil)
                    {
                        print("\(error)")
                    }
                    else
                    {
                        LKCAuthenticatorManager.sharedClient().getDevices { (array, error) in
                            
                            devicesArray = array!
                            
                            self.tblDevices.reloadData()
                        }
                    }
                })
            }

            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            }
            
            alertController.addAction(unlink)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
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
        
        cell.labelStatus.text = "Linked"
        
        cell.btnUnlink.addTarget(self, action:#selector(DevicesCustomViewController.btnUnlinkPressed), for:.touchUpInside)

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
}
